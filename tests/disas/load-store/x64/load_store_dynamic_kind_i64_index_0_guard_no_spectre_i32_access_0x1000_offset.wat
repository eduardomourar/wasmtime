;;! target = "x86_64"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -W memory64 -O static-memory-maximum-size=0 -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

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
;;    4: movq    0x58(%rdi), %r9
;;    8: subq    $0x1004, %r9
;;    f: cmpq    %r9, %rdx
;;   12: ja      0x28
;;   18: movq    0x50(%rdi), %rsi
;;   1c: movl    %ecx, 0x1000(%rsi, %rdx)
;;   23: movq    %rbp, %rsp
;;   26: popq    %rbp
;;   27: retq
;;   28: ud2
;;
;; wasm[0]::function[1]:
;;   30: pushq   %rbp
;;   31: movq    %rsp, %rbp
;;   34: movq    0x58(%rdi), %r9
;;   38: subq    $0x1004, %r9
;;   3f: cmpq    %r9, %rdx
;;   42: ja      0x58
;;   48: movq    0x50(%rdi), %rsi
;;   4c: movl    0x1000(%rsi, %rdx), %eax
;;   53: movq    %rbp, %rsp
;;   56: popq    %rbp
;;   57: retq
;;   58: ud2