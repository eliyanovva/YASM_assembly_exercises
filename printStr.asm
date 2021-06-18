section .data

LF equ 10 ; line feed
NULL equ 0; end of string

TRUE equ 1
FALSE equ 0
EXIT_SUCCESS equ 0
STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_read equ 0
SYS_write equ 1
SYS_open equ 2
SYS_close equ 3
SYS_fork equ 57
SYS_exit equ 60
SYS_creat equ 85 ;file open/create
SYS_time equ 201 ;get time

O_CREAT equ 0x40
O_TRUNC equ 0x200
O_APPEND equ 0x400

O_RDONLY equ 000000q
O_WRONLY equ 000001q
O_RDWR equ 000002q

S_IRUSR equ 00400q
S_IWUSR equ 00200q
S_IXUSR equ 00100q

BUFF_SIZE equ 255


newLine db LF, NULL
header db LF, "File Read Example"
        db LF, LF, NULL
fileName db "test.txt", NULL ; put the name of a text file in your local directory
fileDesc dq 0

errMsgOpen db "Error opening the file.", LF, NULL
errMsgRead db "Error reading from the file.", LF, NULL

;------------------------

section .bss
readBuffer resb BUFF_SIZE

;------------------------

section .text

global _start
_start:

mov rdi, header
call printString

openInputFile:
    mov rax, SYS_open   ; file open
    mov rdi, fileName   ; file name string
    mov rsi, O_RDONLY   ; read only
    syscall

    cmp rax, 0
    jl errorOnOpen

    mov qword[fileDesc], rax    ; save descriptor

    ; read from the file

    mov rax, SYS_read
    mov rdi, qword[fileDesc]
    mov rsi, readBuffer
    mov rdx, BUFF_SIZE
    syscall

    cmp rax, 0
    jl errorOnRead

    ; print the buffer

    mov rsi, readBuffer
    mov byte[rsi+rax], NULL
    mov rdi, readBuffer
    call printString

    printNewLine

    ; close the file

    mov rax, SYS_close
    mov rdi, qword[fileDesc]
    syscall

    jmp exampleDone

errorOnOpen:
    mov  rdi, errMsgOpen
    call printString

    jmp exampleDone

errorOnRead:
    mov rdi, errMsgRead
    call printString
    jmp exampleDone

exampleDone:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


global printString
printString:
    push rbp
    mov rbp, rsp
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
    je prtDone

; Call OS to output str

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

prtDone:
    pop rbx
    pop rbp
    ret





