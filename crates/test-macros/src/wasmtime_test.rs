//! Wasmtime test macro.
//!
//! This macro is a helper to define tests that exercise multiple configuration
//! combinations for Wasmtime. Currently compiler strategies and wasm features
//! are supported.
//!
//! Usage
//!
//! To exclude a compiler strategy:
//!
//! ```rust
//! #[wasmtime_test(strategies(not(Winch)))]
//! fn my_test(config: &mut Config) -> Result<()> {
//!    Ok(())
//! }
//! ```
//!
//! To use just one specific compiler strategy:
//!
//! ```rust
//! #[wasmtime_test(strategies(only(Winch)))]
//! fn my_test(config: &mut Config) -> Result<()> {
//!     Ok(())
//! }
//! ```
//!
//! To explicitly indicate that a wasm features is needed
//! ```
//! #[wasmtime_test(wasm_features(gc))]
//! fn my_wasm_gc_test(config: &mut Config) -> Result<()> {
//!   Ok(())
//! }
//! ```
//!
//! If the specified wasm feature is disabled by default, the macro will enable
//! the feature in the configuration passed to the test.
//!
//! If the wasm feature is not supported by any of the compiler strategies, no
//! tests will be generated for such strategy.
use proc_macro::TokenStream;
use quote::{ToTokens, TokenStreamExt, quote};
use syn::{
    Attribute, Ident, Result, ReturnType, Signature, Visibility, braced,
    meta::ParseNestedMeta,
    parse::{Parse, ParseStream},
    parse_macro_input, token,
};
use wasmtime_test_util::wast::Compiler;

/// Test configuration.
struct TestConfig {
    strategies: Vec<Compiler>,
    flags: wasmtime_test_util::wast::TestConfig,
    /// The test attribute to use. Defaults to `#[test]`.
    test_attribute: Option<proc_macro2::TokenStream>,
}

impl TestConfig {
    fn strategies_from(&mut self, meta: &ParseNestedMeta) -> Result<()> {
        meta.parse_nested_meta(|meta| {
            if meta.path.is_ident("not") {
                meta.parse_nested_meta(|meta| {
                    if meta.path.is_ident("Winch") {
                        self.strategies.retain(|s| *s != Compiler::Winch);
                        Ok(())
                    } else if meta.path.is_ident("CraneliftNative") {
                        self.strategies.retain(|s| *s != Compiler::CraneliftNative);
                        Ok(())
                    } else if meta.path.is_ident("CraneliftPulley") {
                        self.strategies.retain(|s| *s != Compiler::CraneliftPulley);
                        Ok(())
                    } else {
                        Err(meta.error("Unknown strategy"))
                    }
                })
            } else if meta.path.is_ident("only") {
                meta.parse_nested_meta(|meta| {
                    if meta.path.is_ident("Winch") {
                        self.strategies.retain(|s| *s == Compiler::Winch);
                        Ok(())
                    } else if meta.path.is_ident("CraneliftNative") {
                        self.strategies.retain(|s| *s == Compiler::CraneliftNative);
                        Ok(())
                    } else if meta.path.is_ident("CraneliftPulley") {
                        self.strategies.retain(|s| *s == Compiler::CraneliftPulley);
                        Ok(())
                    } else {
                        Err(meta.error("Unknown strategy"))
                    }
                })
            } else {
                Err(meta.error("Unknown identifier"))
            }
        })?;

        if self.strategies.len() == 0 {
            Err(meta.error("Expected at least one strategy"))
        } else {
            Ok(())
        }
    }

    fn wasm_features_from(&mut self, meta: &ParseNestedMeta) -> Result<()> {
        meta.parse_nested_meta(|meta| {
            for (feature, enabled) in self.flags.options_mut() {
                if meta.path.is_ident(feature) {
                    *enabled = Some(true);
                    return Ok(());
                }
            }
            Err(meta.error("Unsupported test feature"))
        })?;

        Ok(())
    }

    fn test_attribute_from(&mut self, meta: &ParseNestedMeta) -> Result<()> {
        let v: syn::LitStr = meta.value()?.parse()?;
        self.test_attribute = Some(v.value().parse()?);
        Ok(())
    }
}

impl Default for TestConfig {
    fn default() -> Self {
        Self {
            strategies: vec![
                Compiler::CraneliftNative,
                Compiler::Winch,
                Compiler::CraneliftPulley,
            ],
            flags: Default::default(),
            test_attribute: None,
        }
    }
}

/// A generic function body represented as a braced [`TokenStream`].
struct Block {
    brace: token::Brace,
    rest: proc_macro2::TokenStream,
}

impl Parse for Block {
    fn parse(input: ParseStream) -> Result<Self> {
        let content;
        Ok(Self {
            brace: braced!(content in input),
            rest: content.parse()?,
        })
    }
}

impl ToTokens for Block {
    fn to_tokens(&self, tokens: &mut proc_macro2::TokenStream) {
        self.brace.surround(tokens, |tokens| {
            tokens.append_all(self.rest.clone());
        });
    }
}

/// Custom function parser.
/// Parses the function's attributes, visibility and signature, leaving the
/// block as an opaque [`TokenStream`].
struct Fn {
    attrs: Vec<Attribute>,
    visibility: Visibility,
    sig: Signature,
    body: Block,
}

impl Parse for Fn {
    fn parse(input: ParseStream) -> Result<Self> {
        let attrs = input.call(Attribute::parse_outer)?;
        let visibility: Visibility = input.parse()?;
        let sig: Signature = input.parse()?;
        let body: Block = input.parse()?;

        Ok(Self {
            attrs,
            visibility,
            sig,
            body,
        })
    }
}

impl ToTokens for Fn {
    fn to_tokens(&self, tokens: &mut proc_macro2::TokenStream) {
        for attr in &self.attrs {
            attr.to_tokens(tokens);
        }
        self.visibility.to_tokens(tokens);
        self.sig.to_tokens(tokens);
        self.body.to_tokens(tokens);
    }
}

pub fn run(attrs: TokenStream, item: TokenStream) -> TokenStream {
    let mut test_config = TestConfig::default();

    let config_parser = syn::meta::parser(|meta| {
        if meta.path.is_ident("strategies") {
            test_config.strategies_from(&meta)
        } else if meta.path.is_ident("wasm_features") {
            test_config.wasm_features_from(&meta)
        } else if meta.path.is_ident("with") {
            test_config.test_attribute_from(&meta)
        } else {
            Err(meta.error("Unsupported attributes"))
        }
    });

    parse_macro_input!(attrs with config_parser);

    match expand(&test_config, parse_macro_input!(item as Fn)) {
        Ok(tok) => tok,
        Err(e) => e.into_compile_error().into(),
    }
}

fn expand(test_config: &TestConfig, func: Fn) -> Result<TokenStream> {
    let mut tests = vec![quote! { #func }];
    let attrs = &func.attrs;

    let test_attr = test_config
        .test_attribute
        .clone()
        .unwrap_or_else(|| quote! { #[test] });

    for strategy in &test_config.strategies {
        let strategy_name = format!("{strategy:?}");
        let (asyncness, await_) = if func.sig.asyncness.is_some() {
            (quote! { async }, quote! { .await })
        } else {
            (quote! {}, quote! {})
        };
        let func_name = &func.sig.ident;
        match &func.sig.output {
            ReturnType::Default => {
                return Err(syn::Error::new(func_name.span(), "Expected `Restult<()>`"));
            }
            ReturnType::Type(..) => {}
        };
        let test_name = Ident::new(
            &format!("{}_{}", strategy_name.to_lowercase(), func_name),
            func_name.span(),
        );

        // Ignore non-pulley tests in Miri as that's the only compiler which
        // works in Miri.
        let ignore_miri = match strategy {
            Compiler::CraneliftPulley => quote!(),
            _ => quote!(#[cfg_attr(miri, ignore)]),
        };

        let test_config = format!("wasmtime_test_util::wast::{:?}", test_config.flags)
            .parse::<proc_macro2::TokenStream>()
            .unwrap();
        let strategy_ident = quote::format_ident!("{strategy_name}");

        let tok = quote! {
            #test_attr
            #(#attrs)*
            #ignore_miri
            #asyncness fn #test_name() {
                let _ = env_logger::try_init();
                let mut config = Config::new();
                wasmtime_test_util::wasmtime_wast::apply_test_config(
                    &mut config,
                    &#test_config,
                );
                wasmtime_test_util::wasmtime_wast::apply_wast_config(
                    &mut config,
                    &wasmtime_test_util::wast::WastConfig {
                        compiler: wasmtime_test_util::wast::Compiler::#strategy_ident,
                        pooling: false,
                        collector: wasmtime_test_util::wast::Collector::Auto,
                    },
                );
                let result = #func_name(&mut config) #await_;
        if wasmtime_test_util::wast::Compiler::#strategy_ident.should_fail(&#test_config) {
            assert!(result.is_err());
        } else {
            result.unwrap();
        }
            }
        };

        tests.push(tok);
    }
    Ok(quote! {
        #(#tests)*
    }
    .into())
}
