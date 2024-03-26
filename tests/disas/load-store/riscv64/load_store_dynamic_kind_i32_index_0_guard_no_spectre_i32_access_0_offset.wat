;;! target = "riscv64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store offset=0)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0))

;; wasm[0]::function[0]:
;;    0: addi    sp, sp, -0x10
;;    4: sd      ra, 8(sp)
;;    8: sd      s0, 0(sp)
;;    c: mv      s0, sp
;;   10: ld      a4, 0x58(a0)
;;   14: slli    a5, a2, 0x20
;;   18: srli    a5, a5, 0x20
;;   1c: addi    a4, a4, -4
;;   20: bltu    a4, a5, 0x20
;;   24: ld      a0, 0x50(a0)
;;   28: add     a5, a0, a5
;;   2c: sw      a3, 0(a5)
;;   30: ld      ra, 8(sp)
;;   34: ld      s0, 0(sp)
;;   38: addi    sp, sp, 0x10
;;   3c: ret
;;   40: .byte   0x00, 0x00, 0x00, 0x00
;;
;; wasm[0]::function[1]:
;;   44: addi    sp, sp, -0x10
;;   48: sd      ra, 8(sp)
;;   4c: sd      s0, 0(sp)
;;   50: mv      s0, sp
;;   54: ld      a4, 0x58(a0)
;;   58: slli    a3, a2, 0x20
;;   5c: srli    a5, a3, 0x20
;;   60: addi    a4, a4, -4
;;   64: bltu    a4, a5, 0x20
;;   68: ld      a0, 0x50(a0)
;;   6c: add     a5, a0, a5
;;   70: lw      a0, 0(a5)
;;   74: ld      ra, 8(sp)
;;   78: ld      s0, 0(sp)
;;   7c: addi    sp, sp, 0x10
;;   80: ret
;;   84: .byte   0x00, 0x00, 0x00, 0x00