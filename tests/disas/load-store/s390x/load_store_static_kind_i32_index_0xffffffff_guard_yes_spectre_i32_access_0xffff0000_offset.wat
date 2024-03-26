;;! target = "s390x"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation -O static-memory-forced -O static-memory-guard-size=4294967295 -O dynamic-memory-guard-size=4294967295"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store offset=0xffff0000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load offset=0xffff0000))

;; wasm[0]::function[0]:
;;    0: stmg    %r14, %r15, 0x70(%r15)
;;    6: lgr     %r1, %r15
;;    a: aghi    %r15, -0xa0
;;    e: stg     %r1, 0(%r15)
;;   14: llgfr   %r4, %r4
;;   18: ag      %r4, 0x50(%r2)
;;   1e: llilh   %r2, 0xffff
;;   22: strv    %r5, 0(%r2, %r4)
;;   28: lmg     %r14, %r15, 0x110(%r15)
;;   2e: br      %r14
;;
;; wasm[0]::function[1]:
;;   30: stmg    %r14, %r15, 0x70(%r15)
;;   36: lgr     %r1, %r15
;;   3a: aghi    %r15, -0xa0
;;   3e: stg     %r1, 0(%r15)
;;   44: llgfr   %r4, %r4
;;   48: ag      %r4, 0x50(%r2)
;;   4e: llilh   %r5, 0xffff
;;   52: lrv     %r2, 0(%r5, %r4)
;;   58: lmg     %r14, %r15, 0x110(%r15)
;;   5e: br      %r14