section .data

; Standard constants

LF equ 10 ; line feed
NULL equ 0 ; end of string
TRUE equ 1
FALSE equ 0
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

;--------------------------------------------------
; Variables which will be used in main

newLine db LF, NULL
header db LF, "File Write Example.", LF, LF, NULL
fileName db "./password_storage.txt", NULL
password db "mamamieeli!123", NULL
len dq 0

writeDone db "Write Completed", LF, NULL
fileDesc dq 0
errMsgOpen db "Error opening file.", LF, NULL
errMsgWrite db "Error writing to file.", LF, NULL

;--------------------------------------------------

section .text
global _start
_start:

; Display header

mov rdi, fileName
mov rsi, password
call writeToFile

exit:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


writeToFile:

mov r8, rdi ; store address of the file in r8
mov r9, rsi ; store the password in r9

    push rdi
    mov rdi, header
    call printString
    pop rdi

; Open file

    push rsi
openInputFile:
    mov rax, SYS_creat ; file open/create
    ;mov rdi, fileName ; file name string
    mov rsi, S_IRUSR | S_IWUSR | S_IXUSR ; allow read and write
    syscall

    cmp rax, 0 ; check for success
    jl errorOnOpen

    mov qword[fileDesc], rax ; save descriptor

; Write to file
    pop rsi
    push rdi
    mov rdi, rsi
    call strLen
    pop rdi ; get the length of the password in rax

    mov rdx, rax ; set parameters for writing in the file
    mov rax, SYS_write
    mov rdi, qword[fileDesc]
    mov rsi, r9
    syscall

    cmp rax, 0
    jl errorOnWrite

    mov rdi, writeDone;
    call printString

; Close file
    mov rax, SYS_close
    mov rdi, qword[fileDesc]
    syscall

    jmp exampleDone

; Error on open
errorOnOpen:
    mov rdi, errMsgOpen
    call printString
    jmp exampleDone

; Error on write
errorOnWrite:
    mov rdi, errMsgWrite
    call printString
    jmp exampleDone

exampleDone:
    ret


; print NULL terminated string

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
