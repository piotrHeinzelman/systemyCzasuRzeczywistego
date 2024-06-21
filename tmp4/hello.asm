extern ExitProcess
extern MessageBoxA
extern DialogBoxA
extern MessageBoxExA
extern ShowWindow
extern CreateWindowExA
extern GetLocalTime
extern _mktime64
extern  puts
extern GetSystemTimeAsFileTime


extern printf
;extern GetFileTitleA

  bits 64
  default rel

section .data	

	titleDefault db "ASM info:",10,13,0

	msg db "Witamy w W10",10,13,0;
	cap db "Windows 10 mowi:",10,13,0;
	par db "                  ",10,13,0;
	
	regStr db "....++++....++++",10,13,0
	
	inputString db 260 dup 0,10,13,0;
	inputStringLen db 0;
	
	timeRaport        db '%0.2d.%0.2d.%d-%0.2d.%0.2d.%0.2d',0; 
	
	cycles dq 100000000000000000;
	
	
_SYSTEMTIME_Struct_Year db 0;
	_one db 0;
	_two db 0;
	_three db 0;
	_four db 0;
	_Minute db 0;
	_Second db 0;
	_Milliseconds db 0;
	
	
;	typedef struct _SYSTEMTIME {
;	WORD wYear;
;	WORD wMonth;
;	WORD wDayOfWeek;
;  WORD wDay;
;  WORD wHour;
;  WORD wMinute;
;  WORD wSecond;
;  WORD wMilliseconds;
;} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;
	
	
section .text
	global main
	
main:
	push rbp
	mov rbp,rsp
	
	; console write x64 windows
	;  sub     rsp, 28h                        ; Reserve the shadow space
    ;    mov     rcx, msg                    ; First argument is address of message
    ;    call    puts                            ; puts(message)
    ;    add     rsp, 28h                        ; Remove shadow space
    ;    ret
	
	;

	 
	
	
	
	
	
	
	
	
	
	
	
	
	;[rdx+8] <- tu wskaznik na %1, pierwszy parametr wywolania
	; A190B
	
	mov rsi,[rdx+8]; -- print 1 argument
;	call printString;
	
 
	mov rdi,inputString 
	call copyString;
	
	mov rsi,inputString
	call printString;
	
	
	
	; time test
	mov rax,0	
	mov rbx,0
	mov rcx,_SYSTEMTIME_Struct_Year	
	mov rdx,_SYSTEMTIME_Struct_Year
	;call GetLocalTime
	call GetSystemTimeAsFileTime
	
	mov rbx,[_one];

		; fun...
		mov rdx,10000000000  ;
		fun:
		dec rdx    ;
		cmp rdx,0  ;
		jne fun


	mov rdx,_SYSTEMTIME_Struct_Year
	call GetSystemTimeAsFileTime
	mov rax,[_one];
	sub rax,rbx ; delta time to rax
	
	

	;mov rax,0x1122334455667788 ;
	;mov rax,0
	;mov ax,word [_one]
	mov rdi,regStr
	call register64bitToStringHEX ; rax value, rdi destnation address
	
 	mov rsi,regStr
	call printString;
	
	
	; time
    ;mov     edx,[_st]
    ;movzx   eax,WORD PTR SYSTEMTIME.wSecond[edx]
    ;push    OFFSET str1
    ;call    crt_printf
    ;add     esp,4*7  
	
	;mov     edx,OFFSET _st ; structure SYSTEMTIME. (Values here are binary: year, month, day, hour, etc.)
	;call GetSystemTime;

 
	
	; // https://stackoverflow.com/questions/44081355/input-output-in-x64-assembly
	; https://stackoverflow.com/questions/44081355/input-output-in-x64-assembly
	; https://www.davidgrantham.com/nasm-information/
	; https://sonictk.github.io/asm_tutorial/
	; https://stackoverflow.com/questions/65619337/why-does-createwindow-in-64-bit-visual-studio-c-destroy-itself-on-creation
	; https://board.flatassembler.net/topic.php?t=18321 
	
	xor   ECX, ECX
	call  ExitProcess
	
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





global register64bitToStringHEX ; rax value, rdi destnation address
register64bitToStringHEX:
	push rbp
	mov rbp,rsp

	rol RAX,16
	call register16bitToStringHEX
	add rdi,4	
	
	rol RAX,16
	call register16bitToStringHEX
	add rdi,4
	
	rol RAX,16
	call register16bitToStringHEX
	add rdi,4
	
	rol RAX,16
	call register16bitToStringHEX


	leave
ret




global register16bitToStringHEX ; rax value, rdi destnation address
register16bitToStringHEX:
	push rbp
	mov rbp,rsp

	push rax
	push rbx
	push rcx
	push rdi
	
	;add rdi,4
	mov cl,0x4


	register16bitToString_loop:
	rol ax,4
	mov bl,al
	and bl,0x0f
	add bl,0x30
	cmp bl,0x39
	JNA no_add
	; nie wieksze
	add bl,0x7
	no_add:
	mov [rdi],bl
	
	inc rdi
	
	dec cl
	cmp cl,0
	jnz register16bitToString_loop
	

	pop rdi
	pop rcx	
	pop rbx
	pop rax

	leave
ret