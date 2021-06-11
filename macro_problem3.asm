; Example program for macro
; Define macro with three arguments: aver <lst> <len> <ave>

	%define mul2(x) shl x, 1
	
	%macro double_nums 2

	lea ebx, dword[%1]
	mov ecx, dword[%2]
	mov r12, 0
	
	%%Loop
	mov eax, dword [rbx + r12 * 4] 
	mul2(eax)
	mov dword[rbx + r12 *4], eax

	inc r12
	loop %%Loop

	%endmacro


	section .data

	EXIT_SUCCESS equ 0
	SYS_exit equ 60


	section .data
	list1 dd 4, 5, 2, -3, 1
	len1 dd 5
	
	list2 dd 2, 6, 3, -2, 1, 8, 19
	len2 dd 7

	list3 dd 2, 3, 4, 5, 6, 7
	len3 dd 6


	section .text
	global _start

	_start
	bits 64

	double_nums list1, len1
	double_nums list2, len2
	double_nums list3, len3


last:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
