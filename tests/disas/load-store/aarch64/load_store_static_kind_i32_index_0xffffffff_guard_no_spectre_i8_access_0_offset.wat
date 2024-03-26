;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-forced -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0))

;; wasm[0]::function[0]:
;;    0: stp     x29, x30, [sp, #-0x10]!
;;    4: mov     x29, sp
;;    8: ldr     x5, [x0, #0x50]
;;    c: strb    w3, [x5, w2, uxtw]
;;   10: ldp     x29, x30, [sp], #0x10
;;   14: ret
;;
;; wasm[0]::function[1]:
;;   20: stp     x29, x30, [sp, #-0x10]!
;;   24: mov     x29, sp
;;   28: ldr     x5, [x0, #0x50]
;;   2c: ldrb    w0, [x5, w2, uxtw]
;;   30: ldp     x29, x30, [sp], #0x10
;;   34: ret