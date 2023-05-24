 .section	.rodata
    .align 8 # Align address to multiple of 8
.L10:
    .quad .pstrlen # Case 50: loc_A
    .quad .defult # Case 51: loc_def
    .quad .replaceChar # Case 52: loc_B
    .quad .pstrijcpy # Case 53: loc_C
    .quad .swapCase # Case 54: loc_D
    .quad .pstrijcmp # Case 55: loc_def
    .quad .defult # Case 56: loc_D
    .quad .defult # Case 57: loc_D
    .quad .defult # Case 58: loc_D
    .quad .defult # Case 59: loc_D
    .quad .pstrlen # Case 60: loc_D

int_format: .string "%d"
char_format: .string " %c"
print_50: .string "first pstring length: %d, second pstring length: %d\n"
print_52: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
print_53_54: .string "length: %d, string: %s\n"
print_55: .string "compare result: %d\n"
print_defult: .string "invalid option!\n"

 .text
.global run_func
run_func:
    pushq   %rbp
    movq    %rsp, %rbp
    leaq    -50(%rdi),%rdi
    cmpq    $10,%rdi
    ja .defult # if >, goto default-case
    jmp * .L10(,%rdi, 8)
    movq    %rbp, %rsp
    popq    %rbp
    ret


# 50 or 60
.pstrlen:
    movq    %rsi, %rdi
    call pstrlen
    movq    %rax, %r14
    movq    %rdx, %rdi
    call pstrlen
    movq    %rax, %r15
    movq    $print_50, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    movq    $0, %rax
    call printf
    movq    %rbp, %rsp
    popq    %rbp
    ret

# 52
.replaceChar:
    push    %rsi
    push    %rdx
    subq    $16, %rsp
    movq    $char_format, %rdi
    movq    %rsp, %rsi 
    movq    $0, %rax
    call scanf
    #old char
    movzbq    (%rsp), %r14
    subq    $16, %rsp
    movq    $char_format, %rdi
    movq    %rsp, %rsi 
    movq    $0, %rax
    call scanf
    #new char
    movzbq    (%rsp), %r15
    addq	$32, %rsp
    pop	%r11
    pop	%rbx
    movq    %rbx, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    call replaceChar
    # new string1
    movq    %rax, %r12
    movq    %r11, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    call replaceChar
    # new string2
    movq    %rax, %r13
    movq    $print_52, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    leaq    1(%r12), %rcx
    leaq    1(%r13), %r8
    call printf
    movq    %rbx, %rsi
    movq    %r11, %rdx
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
    
# 53
.pstrijcpy:
    #dst
    movq    %rsi, %r12
    #src
    movq    %rdx, %r13
    subq    $16, %rsp
    movq    $int_format, %rdi
    movq    %rsp, %rsi 
    movq    $0,%rax
    call scanf
    # start
    movzbq    (%rsp), %r14
    subq    $16, %rsp
    movq    $int_format, %rdi
    movq    %rsp, %rsi 
    movq    $0,%rax
    call scanf
    # last
    movq    (%rsp), %r15
    movq    %r12, %rdi
    movq    %r13, %rsi
    movq    %r14, %rdx
    movq    %r15, %rcx
    call pstrijcpy
    movq    %rax, %r14
    movq    $print_53_54, %rdi
    movzbq    (%r14), %rsi
    leaq    1(%r14), %rdx
    call printf 
    movq    $print_53_54, %rdi
    movzbq    (%r13), %rsi
    leaq    1(%r13), %rdx
    call printf 
    movq    %r12, %rsi
    movq    %r13, %rdx 
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
# 54
.swapCase:
    #dst
    movq    %rsi, %r12
    #src
    movq    %rdx, %r13
    movq    %r12, %rdi
    call swapCase
    movq    %rax, %r14
    movq    %r13, %rdi
    call swapCase
    movq    %rax, %r15
    movq    $print_53_54, %rdi
    movzbq    (%r14), %rsi
    leaq    1(%r14), %rdx
    call printf
    movq    $print_53_54, %rdi
    movzbq    (%r15), %rsi
    leaq    1(%r15), %rdx
    call printf
    movq    %r12, %rsi
    movq    %r13, %rdx 
    movq    %rbp, %rsp
    popq    %rbp
    ret

# 55
.pstrijcmp:
    #pstr1
    movq    %rsi, %r14
    #pstr2
    movq    %rdx, %r15
    subq    $16, %rsp
    movq    $int_format, %rdi
    movq    %rsp, %rsi 
    movq    $0,%rax
    call scanf
    # start
    movq    (%rsp), %r12
    subq    $16, %rsp
    movq    $int_format, %rdi
    movq    %rsp, %rsi 
    movq    $0,%rax
    call scanf
    # last
    movq    (%rsp), %r13
    movq    %r14, %rdi
    movq    %r15, %rsi
    movq    %r12, %rdx
    movq    %r13, %rcx
    call pstrijcmp
    movq    $print_55, %rdi
    movq    %rax, %rsi
    call printf
    movq    %r14, %rsi
    movq    %r15, %rdx
    movq    %rbp, %rsp
    popq    %rbp
    ret

# defult
.defult:
    movq    $print_defult,%rdi
    movq    $0, %rax
    call printf
    movq    %rbp, %rsp
    popq    %rbp
    ret

    




