;;! target = "aarch64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i64 1)

  (func (export "do_store") (param i64 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i64) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; wasm[0]::function[0]:
;;    0: stp     x29, x30, [sp, #-0x10]!
;;    4: mov     x29, sp
;;    8: ldr     x7, [x0, #0x58]
;;    c: cmp     x2, x7
;;   10: b.hi    #0x28
;;   14: ldr     x9, [x0, #0x50]
;;   18: add     x9, x9, #1, lsl #12
;;   1c: strb    w3, [x9, x2]
;;   20: ldp     x29, x30, [sp], #0x10
;;   24: ret
;;   28: .byte   0x1f, 0xc1, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;   40: stp     x29, x30, [sp, #-0x10]!
;;   44: mov     x29, sp
;;   48: ldr     x7, [x0, #0x58]
;;   4c: cmp     x2, x7
;;   50: b.hi    #0x68
;;   54: ldr     x9, [x0, #0x50]
;;   58: add     x8, x9, #1, lsl #12
;;   5c: ldrb    w0, [x8, x2]
;;   60: ldp     x29, x30, [sp], #0x10
;;   64: ret
;;   68: .byte   0x1f, 0xc1, 0x00, 0x00