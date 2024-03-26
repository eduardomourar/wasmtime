;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -W memory64 -O static-memory-forced -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store offset=0xffff0000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load offset=0xffff0000))

;; wasm[0]::function[0]:
;;    0: stp     x29, x30, [sp, #-0x10]!
;;    4: mov     x29, sp
;;    8: mov     x11, #0
;;    c: ldr     x12, [x0, #0x50]
;;   10: add     x12, x12, x2
;;   14: mov     x13, #0xffff0000
;;   18: add     x12, x12, x13
;;   1c: mov     x10, #0xfffc
;;   20: cmp     x2, x10
;;   24: csel    x13, x11, x12, hi
;;   28: csdb
;;   2c: str     w3, [x13]
;;   30: ldp     x29, x30, [sp], #0x10
;;   34: ret
;;
;; wasm[0]::function[1]:
;;   40: stp     x29, x30, [sp, #-0x10]!
;;   44: mov     x29, sp
;;   48: mov     x11, #0
;;   4c: ldr     x12, [x0, #0x50]
;;   50: add     x12, x12, x2
;;   54: mov     x13, #0xffff0000
;;   58: add     x12, x12, x13
;;   5c: mov     x10, #0xfffc
;;   60: cmp     x2, x10
;;   64: csel    x13, x11, x12, hi
;;   68: csdb
;;   6c: ldr     w0, [x13]
;;   70: ldp     x29, x30, [sp], #0x10
;;   74: ret