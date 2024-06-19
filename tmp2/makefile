hello.exe: hello.obj
	gcc hello.obj -o hello.exe
hello.obj: hello.asm
	nasm -f win64 hello.asm -o hello.obj
#	ld hello.obj -o hello.exe	
#gcc hello.obj -o hello.exe

	
