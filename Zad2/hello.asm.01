extern printf
section .data
msg db 'Witaj Swiecie',0
fmt db "Windows 10 mowi: %s",10,0
section .text
global main

main:
push rbp
mov  rbp,rsp
	mov rcx,fmt
	mov rdx,msg
	sub rsp,32
	call printf
	add rsp,32
leave
ret
	