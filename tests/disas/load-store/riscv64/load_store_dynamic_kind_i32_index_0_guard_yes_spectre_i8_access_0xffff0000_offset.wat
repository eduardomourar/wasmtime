;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0xffff0000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0xffff0000))

;; wasm[0]::function[0]:
;;    0: addi    sp, sp, -0x10
;;    4: sd      ra, 8(sp)
;;    8: sd      s0, 0(sp)
;;    c: mv      s0, sp
;;   10: slli    a5, a2, 0x20
;;   14: srli    a1, a5, 0x20
;;   18: auipc   a2, 0
;;   1c: ld      a2, 0x50(a2)
;;   20: add     a2, a1, a2
;;   24: bgeu    a2, a1, 8
;;   28: .byte   0x00, 0x00, 0x00, 0x00
;;   2c: ld      a4, 0x58(a0)
;;   30: ld      a5, 0x50(a0)
;;   34: sltu    a2, a4, a2
;;   38: add     a1, a5, a1
;;   3c: lui     a0, 0xffff
;;   40: slli    a4, a0, 4
;;   44: add     a1, a1, a4
;;   48: neg     a5, a2
;;   4c: not     a2, a5
;;   50: and     a4, a1, a2
;;   54: sb      a3, 0(a4)
;;   58: ld      ra, 8(sp)
;;   5c: ld      s0, 0(sp)
;;   60: addi    sp, sp, 0x10
;;   64: ret
;;   68: .byte   0x01, 0x00, 0xff, 0xff
;;   6c: .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;   70: addi    sp, sp, -0x10
;;   74: sd      ra, 8(sp)
;;   78: sd      s0, 0(sp)
;;   7c: mv      s0, sp
;;   80: slli    a5, a2, 0x20
;;   84: srli    a1, a5, 0x20
;;   88: auipc   a2, 0
;;   8c: ld      a2, 0x50(a2)
;;   90: add     a2, a1, a2
;;   94: bgeu    a2, a1, 8
;;   98: .byte   0x00, 0x00, 0x00, 0x00
;;   9c: ld      a3, 0x58(a0)
;;   a0: ld      a4, 0x50(a0)
;;   a4: sltu    a2, a3, a2
;;   a8: add     a1, a4, a1
;;   ac: lui     a0, 0xffff
;;   b0: slli    a3, a0, 4
;;   b4: add     a1, a1, a3
;;   b8: neg     a5, a2
;;   bc: not     a2, a5
;;   c0: and     a3, a1, a2
;;   c4: lbu     a0, 0(a3)
;;   c8: ld      ra, 8(sp)
;;   cc: ld      s0, 0(sp)
;;   d0: addi    sp, sp, 0x10
;;   d4: ret
;;   d8: .byte   0x01, 0x00, 0xff, 0xff
;;   dc: .byte   0x00, 0x00, 0x00, 0x00