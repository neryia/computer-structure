    .section    .rodata
    format_invalid:    .string "invalid input!\n"

    .text

.global pstrlen
    .type pstrlen, @function
pstrlen:
   movzbq   (%rdi), %rax
   ret
   
   
.global replaceChar
    .type replaceChar, @function
replaceChar:
    # length of pstring in r9 
    movzbq    (%rdi), %r9
    movq    $0, %r8
    incq	%r8    
.replaceChar_while:
    leaq    (%rdi, %r8), %r10
    cmpb    %sil, (%r10)
    jne .replaceChar_rest
    movb    %dl, (%r10)
.replaceChar_rest:  
    incq    %r8
    cmpq    %r8, %r9
    jge .replaceChar_while
    movq    %rdi, %rax
    ret
    

.global pstrijcpy
    .type pstrijcpy, @function
pstrijcpy:
    push    %r15
    # length of dst in r9
    movzbq    (%rdi), %r9
    # length of src in r8
    movzbq    (%rsi), %r8
    
    movq    $0, %r10
    
    # check validtation
    cmpq    %r9, %rdx
    jge .pstrijcpy_invalid
    cmpq    %r10, %rdx
    jl .pstrijcpy_invalid
    cmpq    %r9, %rcx
    jge .pstrijcpy_invalid
    cmpq    %rdx, %rcx
    jl .pstrijcpy_invalid
    cmpq    %r8, %rdx
    jge .pstrijcpy_invalid
    cmpq    %r8, %rcx
    jge .pstrijcpy_invalid
    incq	%rdx
    incq	%rcx
    
# while loop
.pstrijcpy_while:
    leaq    (%rdi, %rdx), %r8
    leaq    (%rsi, %rdx), %r9
    movzbq    (%r9), %r15
    movb	%r15b,(%r8)
    incb    %dl
    cmpb    %dl, %cl    
    jge .pstrijcpy_while
    movq    %rdi, %rax
    pop %r15
    ret   
    
.pstrijcpy_invalid:
    movq    $0, %rax
    movq    $format_invalid, %rdi
    call printf
    pop	%r15
    ret
   
    
     
       
.global swapCase
    .type swapCase, @function
swapCase:
    # the length of pstring in r13 (1 byte)
    movzbq   (%rdi), %r11
    
    # the start of the string in r10
    leaq    1(%rdi), %r10
    movq    $0, %r15
    
# while loop
.swapCase_while:
    cmpq    %r11, %r15
    jge .finish
    movzbq	(%r10), %rbx
    # 'A' = 65
    leaq    -65(%rbx), %rbx
    cmpq    $25,%rbx
    ja .maybe_lower
    leaq    97(%rbx), %rbx
    movb    %bl, (%r10)
    jmp .swapCase_rest
.maybe_lower:
    movzbq    (%r10), %rbx
    # 'A' = 97
    leaq    -97(%rbx), %rbx
    cmpq    $25,%rbx
    ja .swapCase_rest
    leaq    65(%rbx), %rbx
    movb    %bl, (%r10)
.swapCase_rest:
    incq    %r15
    incq    %r10
    jmp .swapCase_while
.finish:
    movq    %rdi, %rax
    ret


          
.global pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:           
     # length of pstr1 in r13
    movzbq    (%rdi), %r13
    # length of pstr2 in r12
    movzbq    (%rsi), %r12
    movq    $0, %r10
    cmpq    %r13, %rdx
    jge .pstrijcmp_invalid
    cmpq    %r10, %rdx
    jl .pstrijcmp_invalid
    cmpq    %r13, %rcx
    jge .pstrijcmp_invalid
    cmpq    %rdx, %rcx
    jl .pstrijcmp_invalid
    cmpq    %r12, %rdx
    jge .pstrijcmp_invalid
    cmpq    %r12, %rcx
    jge .pstrijcmp_invalid
.pstrijcmp_while:
    leaq    (%rdi, %rdx), %r12
    leaq    (%rsi, %rdx), %r13
    cmpq    %r12, %r13
    jl .pstrijcmp_pstr1_biiger
    jg .pstrijcmp_pstr2_biiger
    incb    %dl
    cmpq    %rdx, %rcx
    jl .pstrijcmp_while
    movq    $0, %rax
    ret

.pstrijcmp_pstr1_biiger:
    movq    $1, %rax
    ret
 
.pstrijcmp_pstr2_biiger:
    movq    $-1, %rax
    ret
      
.pstrijcmp_invalid:
    movq    $0, %rax
    movq    $format_invalid, %rdi
    call printf
    movq    $-2, %rax
    ret     
