

section .data

    NULL equ 0
    EXIT_SUCCESS equ 0
    SYS_exit equ 60
    TRUE equ 1
    FALSE equ 0

    strNum1 db '+', '1', '4', '9', '8', 0  ; input the strings like that in order to be able to null-terminate them. otherwise '\0' is flagged as '\' and '0'
    strNum2 db '-', '1', '4', '9', '8', 0

    intNum dw 0

section .text
global _start
_start:

; edi: inputs the address where the string is stored
; rsi: inputs the address where the int will be stored later

    mov edi, strNum1 ;input parameter
    mov rsi, intNum ; input second parameter
    call to_int ; call function

    mov edi, strNum2 ; input parameter
    mov rsi, intNum ; input second parameter
    call to_int ; call function


last:                       ; exit the program with a syscall
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall



; The function takes as input the address of a signed integer stored as a string, and the address where an integer will be stored.
; It converts the string to its integer representation and stores it on the second input address. If the conversion is succesfull, it returns 1, and if the string contains bad input, the function returns 0 and doesn't touch the memory.


to_int:

    mov r8, 0
    mov r9, 0
    mov r10, 0
    mov r11, 0
    mov r12, 0

; find and ignore sign

    mov r8b, "+"
    mov r9b, "-"
    mov r10b, byte[edi]
    mov r11b, 1 ; accounts for the sign, which will be removed from the string length later

    cmp r8b, r10b
    je Positive

    cmp r9b, r10b
    je Negative

    dec r11b
    cmp r11b, 100 ; r11d is never 100, can't make it jump otherwise
    jne Positive

Negative:
    mov ebx, -1
    cmp ebx, 100
    jne strlen

Positive:
    mov ebx, 1

strlen:
    mov r12d, 0 ; will contain the string length WITH SIGN!

loop_len:
    cmp byte[edi+r12d], 0
    je leave_loop
    inc r12d
    loop loop_len

leave_loop:
    sub r12d, r11d ; string length fixed!
    mov rcx, r12
    dec rcx
    mov eax, 1 ;

loop_power:
    mov edx, 10
    mul edx ; get 10^n in eax !!! KEEP IN DIFFERENT REGISTER, CAUSE YOU EMPTY THIS ONE!
    ;mov eax, edx
    dec rcx
    cmp rcx, 0
    jg loop_power

    mov r10d, eax ; store highest power in r10d
    mov ecx, r12d

; store the number in r8d
    mov r8d, 0
    mov eax, 0
loop_calculate:
    mov al, byte[edi+r11d]
    sub al, "0"

    cmp al, 0 ; check for flawed input, which is not numeric
    jl bad_exit
    cmp al, 9
    jg bad_exit

    mul r10d
    add r8d, eax
    ; store 10^{n-1} in edx
    mov eax, r10d
    mov r13d, 10
    div r13d
    mov r10d, eax
    ; increase r11d to move to next char

    inc r11d
    loop loop_calculate

    mov eax, r8d
    cmp ebx, -1
    jne exit_function
    mov r9d, -1
    mul r9d

    mov dword[rsi], eax
    mov eax, TRUE
exit_function:
    ret

bad_exit:
    mov eax, FALSE
    ret
