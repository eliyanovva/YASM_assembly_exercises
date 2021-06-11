 section .data
    NULL equ 0
    EXIT_SUCCESS equ 0
    SYS_exit equ 60

    list1 dd 4, 5, 2, -3, 1
	len1 dd 5
	ave1 dd 0
	sum1 dd 0

	list2 dd 2, 6, 3, -2, 1, 8, 17
	len2 dd 7
	ave2 dd 0
	sum2 dd 0

global main
section .text
main:
    mov rcx, ave2
    mov rdx, sum2
    mov esi, dword[len2]
    mov rdi, list2
    call stats1
    ret


global stats1
stats1:
    push r12
    mov r12, 0
    mov rax, 0

sumLoop:
    add eax, dword[rdi + r12*4]
    inc r12
    cmp r12, rsi
    jl sumLoop

    mov dword [rdx], eax

    cdq
    idiv esi
    mov dword[rcx], eax

    pop r12
    ret

