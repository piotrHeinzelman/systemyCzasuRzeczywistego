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


  bits 64
  default rel

section .data	

	titleDefault db "ASM info:",10,13,0

	msg db "Witamy w W10",10,13,0;
	cap db "Windows 10 mowi:",10,13,0;
	par db "                  ",10,13,0;
	
	regStr db "....++++....++++ : obliczony CRC",13,"liczba cykli:                       "
	regStra db " ",13,"czas calkowity: [ms]              "
	resStr2b db " ",13,"czas sredni cyklu CRC: [us]              "
	resStr3 db "                 ",13,0
	
	inputString db 260 dup 0,10,13,0;
	inputStringLen db 0;
	
	timeRaport        db "                ",10,13,0; 
	
	cycles dq 100000000;
	
	myHigh db 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40   ;
	myLow  db 0x00, 0xc0, 0xc1, 0x01, 0xc3, 0x03, 0x02, 0xc2, 0xc6, 0x06, 0x07, 0xc7, 0x05, 0xc5, 0xc4, 0x04, 0xcc, 0x0c, 0x0d, 0xcd, 0x0f, 0xcf, 0xce, 0x0e, 0x0a, 0xca, 0xcb, 0x0b, 0xc9, 0x09, 0x08, 0xc8, 0xd8, 0x18, 0x19, 0xd9, 0x1b, 0xdb, 0xda, 0x1a, 0x1e, 0xde, 0xdf, 0x1f, 0xdd, 0x1d, 0x1c, 0xdc, 0x14, 0xd4, 0xd5, 0x15, 0xd7, 0x17, 0x16, 0xd6, 0xd2, 0x12, 0x13, 0xd3, 0x11, 0xd1, 0xd0, 0x10, 0xf0, 0x30, 0x31, 0xf1, 0x33, 0xf3, 0xf2, 0x32, 0x36, 0xf6, 0xf7, 0x37, 0xf5, 0x35, 0x34, 0xf4, 0x3c, 0xfc, 0xfd, 0x3d, 0xff, 0x3f, 0x3e, 0xfe, 0xfa, 0x3a, 0x3b, 0xfb, 0x39, 0xf9, 0xf8, 0x38, 0x28, 0xe8, 0xe9, 0x29, 0xeb, 0x2b, 0x2a, 0xea, 0xee, 0x2e, 0x2f, 0xef, 0x2d, 0xed, 0xec, 0x2c, 0xe4, 0x24, 0x25, 0xe5, 0x27, 0xe7, 0xe6, 0x26, 0x22, 0xe2, 0xe3, 0x23, 0xe1, 0x21, 0x20, 0xe0, 0xa0, 0x60, 0x61, 0xa1, 0x63, 0xa3, 0xa2, 0x62, 0x66, 0xa6, 0xa7, 0x67, 0xa5, 0x65, 0x64, 0xa4, 0x6c, 0xac, 0xad, 0x6d, 0xaf, 0x6f, 0x6e, 0xae, 0xaa, 0x6a, 0x6b, 0xab, 0x69, 0xa9, 0xa8, 0x68, 0x78, 0xb8, 0xb9, 0x79, 0xbb, 0x7b, 0x7a, 0xba, 0xbe, 0x7e, 0x7f, 0xbf, 0x7d, 0xbd, 0xbc, 0x7c, 0xb4, 0x74, 0x75, 0xb5, 0x77, 0xb7, 0xb6, 0x76, 0x72, 0xb2, 0xb3, 0x73, 0xb1, 0x71, 0x70, 0xb0, 0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9c, 0x5c, 0x5d, 0x9d, 0x5f, 0x9f, 0x9e, 0x5e, 0x5a, 0x9a, 0x9b, 0x5b, 0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89, 0x4b, 0x8b, 0x8a, 0x4a, 0x4e, 0x8e, 0x8f, 0x4f, 0x8d, 0x4d, 0x4c, 0x8c, 0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40   ;

	
	
_SYSTEMTIME_Struct_Year dw 0;
	_one dw 0;
	_two dw 0;
	_three dw 0;
	_four dw 0;
	_Minute dw 0;
	_Second dw 0;
	_Milliseconds dw 0;
	
	
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

						;[rdx+8] <- tu wskaznik na %1, pierwszy parametr wywolania
						; A190B
	
	mov rsi,[rdx+8]		; -- print 1 argument
						;	call printString;
	
 
	mov rdi,inputString ; copy input string to inputString
	call copyString;
						; print saved string 
						; mov rsi,inputString
						; call printString;
	
	
	
	; time test
	mov rax,0	
	mov rbx,0
	mov rcx,_SYSTEMTIME_Struct_Year	
	mov rdx,_SYSTEMTIME_Struct_Year
	;call GetLocalTime
	call GetSystemTimeAsFileTime
	
	mov r10,0
	mov r10, [_SYSTEMTIME_Struct_Year];

	mov r15,[cycles];
	jmp CRC
	CRC_end:
	
	
	mov rax,0	
	mov rbx,0
	mov rcx,_SYSTEMTIME_Struct_Year		
	mov rdx,_SYSTEMTIME_Struct_Year
	call GetSystemTimeAsFileTime
	
	mov r11,0
	mov r11, [_SYSTEMTIME_Struct_Year];
	sub r11,r10 ; delta time to rax
	
	mov rax,r11	;
	mov rdx,0;
	mov rbx,1000;
	div rbx         ;
	push rdx ; rdx  .xxxx
	mov rdi,resStr2b;
	call register64bitToStringDEC 
	pop rax ;

		; 1 cykli
	mov rax,qword [cycles]	
	mov rbx,1000000
	div rbx ;' nanoSek '	
	mov rbx,rax	
	
	mov rax,r11	;
	mov rdx,0;
	mov rbx,[cycles];
	div rbx         ;
	
	mov rdi,resStr3;
	call register64bitToStringDEC 

	
			
	mov rax,qword [cycles]	
	mov rdx,0
	mov rdi,regStra;
	call register64bitToStringDEC 
	
	
	
	
	
	
	mov rsi,regStr+12
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








global register64bitToStringDEC  ; rax value, rdi destnation address
register64bitToStringDEC:
	push rbp
	mov rbp,rsp

	push rax
	push rbx
	push rcx
	push rdi
	
	mov rbx,0x0a;
	
	push rax;
	push rdx;
	
	;add rdi,12

	mov rax,rdx	 	;  .xxx	
		register64bitToStringDEC_loop:
	mov rdx,0		;
	div rbx  		;
	add dl,0x30 	;
	mov [rdi],dl	;
	dec rdi			;
	cmp rax, 0		;
	jne	register64bitToStringDEC_loop
	
	mov [rdi],byte '.' ;
	dec rdi 
	
	
	pop rdx;
	mov rdx,0;
	pop rax;	

		register64bitToStringDEC_loop2:
	mov rdx,0		;
	div rbx  		;
	add dl,0x30 	;
	mov [rdi],dl	;
	dec rdi			;
	cmp rax, 0		;
	jne	register64bitToStringDEC_loop2

	pop rdi
	pop rcx	
	pop rbx
	pop rax

	leave
ret










global CRC
CRC:

	CRCLoops:
	mov ah, 0xff
	mov al, 0xff
	mov rbx , inputString ; Message
	mov ch, byte[ inputStringLen ]
	;inc ch
	mov rdx,0

		; CRC !!!
		oneCRC:
	
		mov R9B, byte [rbx]   ; dh = *pMessage
			 inc rbx    ; Message++
		mov dl, ah      ; index = HiByte ^ *pMessage
		xor dl, R9B		; index = dl			     	;		Index  = HiByte ^ *pMessage++; 
		
			mov r11,myHigh ;
			add r11,rdx    ;
		xchg ah,al;		
		mov al, byte [ r11 ] ;
		xchg ah,al
		xor ah,al		;		HiByte = LoByte ^ aCRCHi[Index];
		
			mov r11,myLow
			add r11,rdx			
		mov al,byte [ r11 ]
						;		LoByte = aCRCLo[Index]; 

		dec ch
		jnz oneCRC
		; CRC !!
		; HiByte = AH
		; LoByte = AL
		; Result = AX
		;		return (HiByte << 8 | LoByte); 
		
	; / 10^6 loop	
	dec r15
	jnz CRCLoops
	
	; print result
	; rax in rax
	mov rdi,regStr;
	call register64bitToStringHEX ; rax value, rdi destnation address


jmp CRC_end