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
	par db "                                       ",0;
	
	
	regStr db "                 : obliczony Can CRC",13,"liczba cykli:                       "
	regStra db " ",13,"czas calkowity: [ms]              "
	resStr2b db " ",13,"czas sredni cyklu CRC: [us]              "
	resStr3 db "                 ",13,0
	
	inputString db 260 dup 0,10,13,0;
	inputStringLen db 0;
	
	timeRaport        db "                ",10,13,0; 
	
	cycles dq 100000000000;
	
 
	
_SYSTEMTIME_Struct_Year dw 0;
	_one dw 0;
	_two dw 0;
	_three dw 0;
	_four dw 0;
	_Minute dw 0;
	_Second dw 0;
	_Milliseconds dw 0;
	
	
 
	
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
	; https://www.felixcloutier.com/x86/jcc
	; https://www.felixcloutier.com/x86/; 
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


global copyString ; rsi source address, rdi destnation address : return chars num
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

	CRCLoops: ; 10^6 loop
	mov ax,0x0
	mov rbx , inputString ; Message
	mov ch, byte[ inputStringLen ]

	mov cl,0x07 ; 8 bit of char
	mov rdx,0
	
	
	mov dl, [rbx] ; in dl next datachar [8 bit data]
		; CRC !!!
		oneCRC:
		
		 
				; CRCNXT = NXTBIT EXOR CRC_RG(14) 
				;
				;  RAX  ; data   ; XOR ; CF ;
				;   14  ; bit[0] ;     ;    ;
				;    0  ;  0     ; 0   ; 0  ;
				;    0  ;  1     ; 1   ; 0  ;
				;    1  ;  0     ; 1   ; 1  ;
				;    1  ;  1     ; 0   ; 1  ;  if (CF) result= databyte[0] 
				;                               else   result=~databyte[0]  
				
		bt ax,14 ; copy ax[14] to CarryFlag	CF
		jnc noCF ; CF==0?
				 ; CF<>0
				 
		XOR dl, 0x01; if (CF) databyte[0] = ~databyte[0]
				 ; CF==0
				 ;
noCF: 	 		 ; result=databit
		
		SHL ax,1	 ;	CRC_RG(14:1) = CRC_RG(13:0)
				 ;  CRC_RG(0) = 0;
		
				 ; IF CRCNXT THEN
		bt dx,0  ; testbit databit[0] retult in CF!
				 ; 
				 ; === IF NOT CRCNXT 
				 ; === IF NOT CF 
				 ; GOTO REPEAT			 
		jnc no4599;
		
		XOR ax,0x4599 ; CRC_RG(14:0) = CRC_RG(14:0) EXOR (4599hex);
		
no4599:
		         ; prepare next byte
		
		
		
		
		cmp cl,0 ; last byte of char ?
		jz lastByteOfChar     ; no last byte		
			dec cl;
			shr dl,1;	Data[0] = Data[1], data[n]=data[n-1]
		jmp oneCRC
		
		lastByteOfChar:
		   cmp ch,0
		   jz data_end;		
		   dec 	ch   ; char num in data
		
		   mov cl,0x07	;
		   inc rbx 	;
		   mov dl, [rbx] ; in dl next datachar [8 bit data]
		jmp oneCRC

	data_end:	
	; / 10^6 loop	
	dec r15
	jnz CRCLoops
	
	and rax,0x3fff;
	mov rdi,regStr;  result (RAX) save as String in [regStr]
	call register64bitToStringHEX ; rax value, rdi destnation address

jmp CRC_end
