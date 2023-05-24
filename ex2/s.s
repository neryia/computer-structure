	.file	"ex2.c"
	.text
	.globl	even
	.type	even, @function
even:
	movl	%edi, %eax
	movl	%esi, %ecx
	sall	%cl, %eax
	ret
go:
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %r12
	movl	$0, %ebx
	movl	$0, %ebp
	jmp	.L3
.L4:
	addl	%edi, %ebp
.L5:
	addl	$1, %ebx
.L3:
	cmpl	$9, %ebx
	jg	.L8
	movslq	%ebx, %rax
	movl	(%r12,%rax,4), %edi
	testb	$1, %dil
	jne	.L4
	movl	%ebx, %esi
	call	even
	addl	%eax, %ebp
	jmp	.L5
.L8:
	movl	%ebp, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
main:


