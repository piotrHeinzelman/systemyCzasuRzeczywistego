extern ExitProcess
extern MessageBoxA
extern DialogBoxA
extern MessageBoxExA
extern ShowWindow
extern CreateWindowExA
extern GetSystemTime

extern printf
;extern GetFileTitleA

  bits 64
  default rel

section .data	

	titleDefault db "ASM info:",10,13,0

	msg db "Witamy w W10",10,13,0;
	cap db "Windows 10 mowi:",10,13,0;
	par db "                  ",10,13,0;
	
	inputString db 260 dup 0;
	inputStringLen db 0;
	
	timeRaport        db '%0.2d.%0.2d.%d-%0.2d.%0.2d.%0.2d',0; 
	
section	.data?
	_st db "???????????????????";
	
	
section .text
	global main
	
main:
	push rbp
	mov rbp,rsp
	
	;[rdx+8] <- tu wskaznik na %1, pierwszy parametr wywolania
	; A190B
	
	mov rsi,[rdx+8]; -- print 1 argument
;	call printString;
	
 
	mov rdi,inputString 
	call copyString;
	
	mov rsi,inputString
	call printString;
	
	; time
    mov     edx,[_st]
    ;movzx   eax,WORD PTR SYSTEMTIME.wSecond[edx]
    ;push    OFFSET str1
    ;call    crt_printf
    ;add     esp,4*7  
	
	;mov     edx,OFFSET _st ; structure SYSTEMTIME. (Values here are binary: year, month, day, hour, etc.)
	call GetSystemTime;

	;int 21
	
	; // https://stackoverflow.com/questions/44081355/input-output-in-x64-assembly
	; https://stackoverflow.com/questions/44081355/input-output-in-x64-assembly
	

	
	
	; int MessageBoxA(
	; HWND hWnd okno nadrzedne
	; LPCSTR plText tekst do wyswietlenia
	; LPCSTR lpCaption tytul okna
	; UINT	uType	typ okna
	; )
 
	
	
	mov rcx,0
	;lea rdx,[msg]
	mov rdx,[rdx+8]
	lea r8,[cap]
	mov r9d,0	; okno w przyciskiem okna
	sub rsp,32		; przstrzen ukryta
	call MessageBoxA; zwraca IDOK=1 jesli kliknieto okna
	add rsp,32
	
;	mov rcx,0
;	lea rdx,[msg]
;	lea r8,[cap]
;	mov r9d,0	; okno w przyciskiem okna
;	sub rsp,32		; przstrzen ukryta
;	call MessageBoxA; zwraca IDOK=1 jesli kliknieto okna
;	add rsp,32
	
leave
ret

	



global printString ; rsi <= stringAddress / like linux
printString:
	push rbp
	mov rbp,rsp
	push rax	;
	push rbx	;
	push rcx
	push rdx
	push r8
	push r9
	push rsi
	push rdi

	mov rcx,0
	mov rdx,rsi
	lea r8,[cap]
	mov r9d,0	; okno w przyciskiem okna
	sub rsp,32		; przstrzen ukryta
	call MessageBoxA; zwraca IDOK=1 jesli kliknieto okna
	add rsp,32

	
	pop rdi
	pop rsi
	pop r9
	pop r8
	pop rdx
	pop rcx
	pop rbx
	pop rax
	leave
ret


global copyString ; rsi source address, rdi destnation address
copyString:
	push rbp
	mov rbp,rsp
	
	push rax
	push rbx
	push rdx
	push rsi
	push rdi
	
	
	mov rdx,0
	mov dl,0 ; length in 4bit
	mov dh,0 ; length in 8bit
	
	copyString_check_nextChar:
	mov al,byte [rsi]
	inc rsi
	cmp al, byte 0
	je copyString_endString
	
	sub al,0x30
	cmp al,0x0a
	jb copyString_copyAL_toChar    ; jesli mniejsze - wartosc w al
	
	sub al,0x07 ;11
	cmp al,0x10
	jb copyString_copyAL_toChar
	
	sub al,0x20
	cmp al,0x10
	jb copyString_copyAL_toChar
	
	jmp copyString_check_nextChar
	
	
	copyString_copyAL_toChar:
	;copy al to string
;	add al,0x41 ; test only
	bt dx,0
	JNC no_move		 ; jesli parzyste pierwszy znak, trzeci znak...
	
	; mov AL <-4bit, AL=[rdi]*16+AL
	dec rdi
	mov rbx,0
	mov bl,byte [rdi]
	shl bl,4
	add al,bl
	inc dh
	

	no_move:
	mov [rdi],al
	inc rdi
	inc dl
	

	jmp copyString_check_nextChar
	
	copyString_endString:
	mov [rdi], byte 10
	inc rdi
	mov [rdi], byte 13
	inc rdi

	mov [inputStringLen],dh 
	pop rdi
	pop rsi
	pop rdx
	pop rbx
	pop rax
	
	leave
ret