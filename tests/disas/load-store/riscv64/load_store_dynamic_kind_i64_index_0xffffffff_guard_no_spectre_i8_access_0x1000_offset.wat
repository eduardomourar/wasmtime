;;! target = "riscv64"
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
;;    0: addi    sp, sp, -0x10
;;    4: sd      ra, 8(sp)
;;    8: sd      s0, 0(sp)
;;    c: mv      s0, sp
;;   10: ld      a1, 0x58(a0)
;;   14: bltu    a1, a2, 0x28
;;   18: ld      a4, 0x50(a0)
;;   1c: add     a2, a4, a2
;;   20: lui     t6, 1
;;   24: add     t6, t6, a2
;;   28: sb      a3, 0(t6)
;;   2c: ld      ra, 8(sp)
;;   30: ld      s0, 0(sp)
;;   34: addi    sp, sp, 0x10
;;   38: ret
;;   3c: .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;   40: addi    sp, sp, -0x10
;;   44: sd      ra, 8(sp)
;;   48: sd      s0, 0(sp)
;;   4c: mv      s0, sp
;;   50: ld      a1, 0x58(a0)
;;   54: bltu    a1, a2, 0x28
;;   58: ld      a3, 0x50(a0)
;;   5c: add     a2, a3, a2
;;   60: lui     t6, 1
;;   64: add     t6, t6, a2
;;   68: lbu     a0, 0(t6)
;;   6c: ld      ra, 8(sp)
;;   70: ld      s0, 0(sp)
;;   74: addi    sp, sp, 0x10
;;   78: ret
;;   7c: .byte   0x00, 0x00, 0x00, 0x00