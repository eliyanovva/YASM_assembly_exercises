section .data
    NULL equ 0
    EXIT_SUCCESS equ 0
    SYS_exit equ 60


    list0 dd 4, 2, 1
    len0 dd 3

	list1 dd 8, 1, -2, 4, 5, 9
	len1 dd 6

    list2 dd -2, 12, 1, 4, 2, 3, 8, 17
	len2 dd 8

global main

section .text

main:
    mov esi, dword[len1]
    mov rdi, list1
    call sort
    mov r12, 0

showLoop:
    mov eax, dword[rdi+r12*4]
    inc r12
    cmp r12, rsi
    jl showLoop

    ret

global stats2

sort:

    push r12
    mov r12, 0

sumLoop:
    mov eax, dword[rdi + r12*4] ; small = arr[i]
    mov ebx, r12d   ;index =i
    mov r11, r12 ; for j = i

insideLoop:
    cmp eax, dword[rdi + r11*4] ; small > arr[j]
    jle skipIf
    mov eax, dword[rdi + r11*4] ; small = arr[j]
    mov ebx, r11d ; index = j


skipIf:
    inc r11 ; run the loop
    cmp r11, rsi

    jl insideLoop ; exit inside loop

    mov r8d, dword[rdi+r12*4] ; temp = arr[i]
    mov dword[rdi + rbx*4], r8d ; arr(index) = temp
    mov dword[rdi + r12*4], eax ; arr(i) = small

    inc r12
    cmp r12, rsi
    jl sumLoop  ; exit big loop

    pop r12
    ret



