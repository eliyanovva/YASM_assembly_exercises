section .data
    NULL equ 0
    EXIT_SUCCESS equ 0
    SYS_exit equ 60

	list dd -2, 1, 2, 3, 8, 17
	len dd 6
	ave dd 0
	sum dd 0
	max dd 0
	min dd 0
	med1 dd 0
	med2 dd 0

global main

section .text
main:
    push ave
    push sum
    mov r9d, dword[max]
    mov r8d, dword[med2]
    mov ecx, dword[med1]
    mov edx, dword[min]
    mov esi, dword[len]
    mov rdi, list
    call stats2
    add rsp, 16

    ret

global stats2

stats2:
    push rbp
    mov rbp, rsp
    push r12

    ; max and min

    mov eax, dword[rdi]
    mov edx, eax

    mov r12, rsi
    dec r12
    mov eax, dword[rdi+r12*4]
    mov r9d, eax

    ; medians
    mov rax, rsi
    mov rdx, 0
    mov r12, 2
    div r12

    cmp rdx, 0
    je evenLength

    mov r12d, dword[rdi + rax*4]
    mov ecx, r12d
    mov r8d, r12d
    jmp medDone

evenLength:
    mov r12d, dword[rdi+rax*4]
    mov r8d, r12d
    dec rax
    mov r12d, dword[rdi+rax*4]
    mov ecx, r12d
medDone:

;sum

    mov r12, 0
    mov rax, 0

sumLoop:
    add eax, dword[rdi + r12*4]
    inc r12
    cmp r12, rsi
    jl sumLoop

    mov r12, qword[rbp+16]
    mov rax, r12

;average
    cdq
    idiv rsi
    mov r12, qword[rbp+24]
    mov rax, r12

    pop r12
    pop rbp

    ret



