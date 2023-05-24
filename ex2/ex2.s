# 323098616 Neryia DayanZada
    .text
.global go
 go:
    # A[0] in %rdi align 4 Bytes
    # sum
    xorq    %r11, %r11
    # i
    xorq    %rdx, %rdx

# while loop
.L1:
    # check if it even
    leaq    (%rdi, %rdx, 4), %r15
    movl    $1, %ebx
    testl    (%r15), %ebx
    je .L2

# if not even
.L3:
    addl    (%r15), %r11d
    jmp .L4

#if even
.L2:
    movq    %rdx, %rsi
    movq    %rdi, %r10
    movl    (%r15), %edi 
    call    even
    movq    %r10, %rdi
    addl    %eax, %r11d
    jmp .L4

#loop
.L4:
    incq    %rdx
    cmpq    $9, %rdx
    jle .L1
    movl    %r11d, %eax
    ret

even:
    # num in %rsi and i in %sil
    movq    %rsi, %rcx
    sall    %cl, %edi
    movl    %edi, %eax
    ret
