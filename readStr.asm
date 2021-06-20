section .data

; Define standard constants

LF equ 10 ; line feed
NULL equ 0 ; end of string
TRUE equ 1
FALSE equ 0

EXIT_SUCCESS equ 0 ; success code

STDIN equ 0 ; standard input
STDOUT equ 1 ; standard output
STDERR equ 2 ; standard error

SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; file open
SYS_close equ 3 ; file close
SYS_fork equ 57 ; fork
SYS_exit equ 60 ; terminate
SYS_creat equ 85 ; file open/create
SYS_time equ 201 ; get time

STRLEN equ 51 ; The string length includes the terminating Null character

pmpt db "Enter Text: ", NULL ;
newLine db LF, NULL

section .bss
chr resb 1
str1 resb STRLEN+1
str2 resb STRLEN+1

section .text

global _start
_start:

    mov rsi, STRLEN
    mov rdi, str1
    call readString

    mov rsi, STRLEN
    mov rdi, str2
    call readString

exampleDone:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

; FUNCTION INPUT:
;   rsi contains the max length of the string
;   rdi contains the string address

global readString
readString:
; Display prompt
    push rdi
    mov rdi, pmpt
    call printString
    pop rdi

; Read characters from user

    mov rbx, rdi
    mov r12, 0
    mov r8, rsi ; store max length in r8
    mov r9, rdi ; store string address in r9

readCharacters:
    mov rax, SYS_read ; system code for read
    mov rdi, STDIN ; standard in
    lea rsi, byte[chr] ; address of chr (defined in the data section)
    mov rdx, 1 ; count
    syscall

    mov al, byte[chr] ; get character
    cmp al, LF ; compare input character to \n
    je readDone ; finish reading if equal

    inc r12 ; count++
    cmp r12, r8 ; if #characters is more than max length, stop placing in the buffer
    jae readCharacters

    mov byte[rbx], al ; store character on the input address
    inc rbx ; update address for the next character

    jmp readCharacters

readDone:
    mov byte[rbx], NULL ; NULL termination
    ; Output line

    mov rdi, r9 ; print the string on the console
    call printString
    mov rax, r12 ; return the number of characters without NULL

    ret

; print string function, the string should be null terminated
; arguments: address, string

global printString
printString:
    push rbx
    mov rbx, rdi
    mov rdx, 0

strCountLoop:
    cmp byte[rbx], NULL
    je strCountDone
    inc rdx
    inc rbx
    jmp strCountLoop

strCountDone:
    cmp rdx, 0
    je printDone
; Call OS to output string
    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT

    syscall

printDone:
    pop rbx
    ret

; find string length
; input is the address where the length is stored in rdi
; output is the length in rax

strLen:
    push rbx
    push rdx
    mov rbx, rdi
    mov rdx, 0

CountLoop:
    cmp byte[rbx], NULL
    je funcStrLenDone
    inc rdx
    inc rbx
    jmp CountLoop

funcStrLenDone:
    mov rax, rdx ; store the string length in rax
    pop rdx
    pop rbx
    ret
