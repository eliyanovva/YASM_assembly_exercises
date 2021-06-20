; r11 is used in a syscall, so don't use it to preserve a register. I used r13 to store the password length for that reason.

section .data

; Standard constants

LF equ 10 ; line feed
NULL equ 0 ; end of string
TRUE equ 1
FALSE equ 0
SUCCESS equ 1
NOSUCCESS equ 0
EXIT_SUCCESS equ 0 ; success code
STDIN equ 0 ; standard input
STDOUT equ 1 ; standard output
STDERR equ 2; standard error

SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; open
SYS_close equ 3 ; close
SYS_fork equ 57 ; fork
SYS_exit equ 60 ; terminate
SYS_creat equ 85 ; file open/create
SYS_time equ 201 ; get time

O_CREAT equ 0x40
O_TRUNC equ 0x200
O_APPEND equ 0x400

O_RDONLY equ 000000q ; read only
O_WRONLY equ 000001q ; write only
O_RDWR equ 000002q ; read and write

S_IRUSR equ 00400q
S_IWUSR equ 00200q
S_IXUSR equ 00100q

;--------
; Variables and constants

BUFF_SIZE equ 255
newLine db LF, NULL
header db LF, "File Read Example.", LF, LF, NULL
fileName db "password_storage.txt", NULL
fileDesc dq 0
errMsgOpen db "Error opening file.", LF, NULL
errMsgRead db "Error reading from file.", LF, NULL

;--------------------------------------------------

section .bss
readBuffer resb BUFF_SIZE
password_size resq 1

;--------------------------------------------------

section .text
global _start
_start:

; INPUT
; address of file - rdi
; address to store password - rsi
; max length of pass - rdx
; address to store password length - rcx

; OUTPUT
; password length - rax

    mov rdi, fileName
    mov rsi, readBuffer
    mov rdx, BUFF_SIZE
    mov rcx, password_size
    call startReadFile

exit:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


startReadFile:


    mov r8, rdi ; store the input because the input registers are used with the syscalls later
    mov r9, rsi
    mov r10, rdx
    mov r13, rcx

    mov rdi, header
    call printString

; open file
openInputFile:
    mov rax, SYS_open ; file open/create
    mov rdi, r8 ; file name string
    mov rsi, O_RDONLY ; allow read and write
    syscall

    cmp rax, 0 ; check for success
    jl errorOnOpen

    mov qword[fileDesc], rax ; save descriptor

; read from file
    mov rax, SYS_read
    mov rdi, qword[fileDesc]
    mov rsi, r9
    mov rdx, r10
    syscall

    cmp rax, 0
    jl errorOnRead

; null terminate the buffer and print it

    mov rsi, readBuffer
    mov byte[rsi+rax], NULL
    mov rdi, readBuffer
    mov r12, rax ; store string length
    call printString


    printNewLine

; close file
    mov rax, SYS_close
    mov rdi, qword[fileDesc]
    syscall

    mov rax, SUCCESS
    mov qword[r13], r12

    jmp exampleDone

; Error on open
errorOnOpen:
    mov rdi, errMsgOpen
    call printString
    mov rax, NOSUCCESS
    jmp exampleDone

; Error on write
errorOnRead:
    mov rdi, errMsgRead
    call printString
    mov rax, NOSUCCESS
    jmp exampleDone

exampleDone:

    ret


global printString
printString:
    push rbp
    mov rbp, rsp
    push rbx

; Count chars in string

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
    je prtDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

    prtDone:
    pop rbx
    pop rbp
    ret

; find the length of a string stored on address in rdi
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
