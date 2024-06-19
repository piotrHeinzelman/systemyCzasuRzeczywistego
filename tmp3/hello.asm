 

extern ExitProcess
extern MessageBoxA
extern DialogBoxA
extern MessageBoxExA
extern ShowWindow
extern CreateWindowExA
;extern GetFileTitleA

  bits 64
  default rel

section .data	

	msg db "Witamy w W10",10,13,0;
	cap db "Windows 10 mowi:",10,13,0;
	par db "                  ",10,13,0
	
	
section .text
	global main
	
main:
	push rbp
	mov rbp,rsp
	
	
	
	
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

	

