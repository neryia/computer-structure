 .section	.rodata
format_scan_string:    .string "%s"
format_scan_int:    .string "%d"

 .text
.global run_main
run_main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    subq    $272, %rsp
    movq    $format_scan_int, %rdi
    movq    $0,%rax
    movq    %rsp, %rsi 
    call scanf

    movq    $format_scan_string, %rdi
    movq    $0,%rax
    leaq    1(%rsp), %rsi 
    call scanf
    # r15 consist str1
    movq    %rsp, %r15
    movzbq  (%r15), %r13
    leaq    1(%r15, %r13), %r13
    movq    $0, (%r13)    
    
    subq    $272, %rsp
    movq    $format_scan_int, %rdi
    movq    $0,%rax
    movq    %rsp, %rsi 
    call scanf
    # esi consist the lengh of str2
    movq    $format_scan_string, %rdi
    movq    $0,%rax
    leaq    1(%rsp), %rsi 
    call scanf
    # r8 consist str2
    movq    %rsp, %r14
    movzbq    (%r14), %r13
    leaq    1(%r14, %r13), %r13
    movq    $0, (%r13) 
    
    # scan option
    subq    $16, %rsp
    movq    $format_scan_int, %rdi
    movq    %rsp, %rsi 
    movq    $0,%rax
    call scanf
    
    movq    (%rsp), %rdi
    movq    %r15, %rsi
    movq    %r14, %rdx
    call run_func
    
    movq    %rbp, %rsp
    popq    %rbp
    xorq    %rax, %rax
    ret


    
