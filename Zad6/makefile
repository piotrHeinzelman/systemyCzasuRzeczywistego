crc06.exe: crc06.o
	gcc -o crc06  crc06.o -no-pie
crc06.o: crc06.asm
		nasm -f elf64 -g -F dwarf crc06.asm -l crc06.lst
		