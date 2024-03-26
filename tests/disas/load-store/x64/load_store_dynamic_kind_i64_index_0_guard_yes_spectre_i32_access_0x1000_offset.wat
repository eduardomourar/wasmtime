;;! target = "x86_64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store offset=0x1000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load offset=0x1000))

;; wasm[0]::function[0]:
;;    0: pushq   %rbp
;;    1: movq    %rsp, %rbp
;;    4: movq    0x58(%rdi), %r11
;;    8: movq    0x50(%rdi), %rax
;;    c: subq    $0x1004, %r11
;;   13: xorq    %rdi, %rdi
;;   16: leaq    0x1000(%rax, %rdx), %rsi
;;   1e: cmpq    %r11, %rdx
;;   21: cmovaq  %rdi, %rsi
;;   25: movl    %ecx, (%rsi)
;;   27: movq    %rbp, %rsp
;;   2a: popq    %rbp
;;   2b: retq
;;
;; wasm[0]::function[1]:
;;   30: pushq   %rbp
;;   31: movq    %rsp, %rbp
;;   34: movq    0x58(%rdi), %r11
;;   38: movq    0x50(%rdi), %rax
;;   3c: subq    $0x1004, %r11
;;   43: xorq    %rdi, %rdi
;;   46: leaq    0x1000(%rax, %rdx), %rsi
;;   4e: cmpq    %r11, %rdx
;;   51: cmovaq  %rdi, %rsi
;;   55: movl    (%rsi), %eax
;;   57: movq    %rbp, %rsp
;;   5a: popq    %rbp
;;   5b: retq