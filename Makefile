array.out: arraymain.o arraydriver.o inputArray.o outputArray.o bubbleSort.o asmSwap.o
	gcc -m64 -o array.out arraymain.o arraydriver.o inputArray.o outputArray.o bubbleSort.o asmSwap.o

arraymain.o: arraymain.asm
	nasm -f elf64 -l arraymain.lis -o arraymain.o arraymain.asm

inputArray.o: inputArray.asm
	nasm -f elf64 -l inputArray.lis -o inputArray.o inputArray.asm

outputArray.o: outputArray.asm
	nasm -f elf64 -l outputArray.lis -o outputArray.o outputArray.asm

bubbleSort.o: bubbleSort.c
	gcc -c -m64 -Wall -std=c99 -l bubbleSort.lis -o bubbleSort.o bubbleSort.c

asmSwap.o: asmSwap.asm
	nasm -f elf64 -l asmSwap.lis -o asmSwap.o asmSwap.asm

arraydriver.o: arraydriver.c
	gcc -c -m64 -Wall -std=c99 -l arraydriver.lis -o arraydriver.o arraydriver.c

clean:
	rm -f arraymain.lis arraydriver.lis arraymain.o arraydriver.o array.out inputArray.lis inputArray.o outputArray.lis outputArray.o bubbleSort.lis bubbleSort.o\
	debug.o asmSwap.o asmSwap.lis debug.lis
