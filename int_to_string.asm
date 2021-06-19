section .data

    NULL equ 0
    EXIT_SUCCESS equ 0
    SYS_exit equ 60

    intNum1 dd 1498
    intNum2 dd -1498

section .bss

    strNum1 resb 10
    strNum2 resb 10

section .text
global _start
_start:

;ORDER OF FUNCTION INPUT REGISTERS: rdi - rsi - rdx - rcx - r8 - r9
; edi: signed integer, rsi:address where the string will be stored

    mov rsi, strNum1 ; set second parameter
    mov edi, dword[intNum1] ; set first parameter
    call to_ascii ; call function

    mov rsi, strNum2 ; set second parameter
    mov edi, dword[intNum2] ; set first parameter
    call to_ascii ; call function


last:                       ; exit the program with a syscall
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


; The function takes as input a signed integer and an address.
; It converts the integer to its string representation and stores it on the address.

to_ascii:
    mov eax, edi ; put the integer input in eax
    mov rbx, rsi ; put the string address in rbx
    mov rcx, 0


; put a minus sign in front of the number
    cmp eax, 0 ; check is integer > 0
    jg addPlus ; if integer > 0, go add plus instead of minus

    mov r12b, "-" ; add minus to the address
    mov byte[rbx], r12b
    not eax ; convert the negative number to positive by -n = !(n)+1
    add eax, 1

    jmp start_proc ; skip adding a plus, go directly to the procedure

addPlus: ; add a plus in the address, if the number is positive
    mov r12b, "+"
    mov byte[rbx], r12b

start_proc:
    mov ebx, 10
divideLoop:
    mov edx, 0
    div ebx
    push rdx
    inc rcx

    mov r8d, 0
    cmp eax, r8d
    jne divideLoop

    mov rbx, rsi
    mov r11, 1 ; start from 1, because the first char is the sign

popLoop:
    pop rax
    add al, "0"
    mov byte[rbx + r11], al
    inc r11
    loop popLoop

    mov byte[rbx + r11], 0

    ret
