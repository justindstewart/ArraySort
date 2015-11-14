;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author information
;  Author name: Justin Stewart
;  Author email: scubastew@csu.fullerton.edu
;  Author location: Long Beach, Calif.
;Course information
;  Course number: CPSC240
;  Assignment number: 4
;  Due date: 2015-Oct-29
;Project information
;  Project title: Array Processing
;  Purpose: The purpose of this project is to provide experience working with arrays in x86-64. This program will prompt the user for data, which will be read into an
;           array. It will then make a copy of the array and sort the copy. Finally it will output the arrays. Each step will be handled in a seperate module.
;  Status: In progress.
;  Project files: arraymain.asm, arraydriver.c, outputArray.asm, inputArray.asm, asmSwap.asm, bubbleSort.c
;Module information
;  File name: outputArray.asm
;  This module's call name: outputArray
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2015-Oct-28
;  Purpose: Receive an array and its length and output the array to the user.
;  Preconditions: The address of the pointer array must be passed into rdi, the size of the array is copied into rsi, and the original address for start of array into rdx
;  Postconditions: This function will output the array, besides that nothing else has changed. None.
;  Future enhancements: None planned.
;Translator information
;  Linux: nasm -f elf64 -l outputArray.lis -o outputArray.o outputArray.asm
;References and credits
;  Pointer and Reference Passing Project - Holliday
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;Permission Information
;  This work is private and shall not be posted online, copied or referenced. 
;===== Begin area for source code =========================================================================================================================================

%include "savedata.inc"					    ;External macro used in backup of registers.

%include "debug.inc"					    ;External macro used in debugging registers.
	
extern printf                                               ;External C program used to output data, backup of registers is important if data is to be preserved.

global outputArray                                          ;Set a global call name in order to be called by another program.

segment .data                                               ;Initialized data are placed in this segment.

;===== Messages to be output to user ======================================================================================================================================

header db "Index		Physical Address		Hex Value			Decimal Value", 10, 0

output db "%2ld		%016lx		0x%016lx		%1.11lf", 10, 0

;===== Declare printf formats =============================================================================================================================================

stringformat db "%s", 0

segment .bss                                                ;Uninitialized data are declared in this segment.

align 64						    ;Ensure that the next allocation is aligned on an 64 byte memory address
backuparea resb 952					    ;Set a backup space for registers

;==========================================================================================================================================================================
;===== Begin the application here: outputArray ============================================================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Instructions for the program are placed in the following segment.

outputArray:                                                ;Begin execution of the program here.

push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now.
mainbackup backuparea

mov 	   r15, rsi					    ;Copy the size of the array into r15
mov 	   r14, rdi					    ;Copy the address of the incomming array into r14
mov	   r13, rdx					    ;Copy the original starting address into r13 for proper index output
mov	   r12, 0					    ;Set r12 to zero to be used as a counter

;===== Output header ======================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, header                                      ;"Index		Physical Address		Hex Value		Decimal Value"
call printf                                                 ;An external function that handles output.

;General Purpose Registers as of last instruction:
;
;         |-----------------------|
;  r15:   |  -    -     -    size | - Size of the array
;         |-----------------------|	
;  r14:   |  -    -     -    addr | - Beginning of passed in array
;         |-----------------------|
;  r13:   |  -    -     -    addr0| - Beginning of original array (pre-sort)
;         |-----------------------|
;  r12:   |  -    -     -    count| - Counter
;         |-----------------------|

;===== beginloop: Begin loop code here ====================================================================================================================================

beginloop:

cmp 	   r12, r15					    ;Compare the number of elements to the counter
jge 	   endloop					    ;If the compare returns a greater-than or equal value 

mov 	   r11, [r14 + 8*r12]				    ;Pass the given array address at calculated element into r11 for proper index calculation
mov 	   r10, r11					    ;Copy the array address calculated above into r10 to find the difference between it and original array start
sub 	   r10, r13					    ;Subtract the original array address (pre-sort) from the passed in array (post-sort/pre-sort)

mov 	   r8, 8					    ;Move the value (8) into r8 to the divisor of the difference in addresses caluclated above
mov 	   rax, r10					    ;Move the difference in addresses into the numerator position to be divided
cqo							    ;Convert quad word to octal word for division
div 	   r8						    ;Divide the value in rax (difference in array addresses) by 8
mov 	   r9, rax					    ;Move the calculated value (proper index) into r9 for output

;===== Output line ========================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov        rdi, output                                	    ;"%ld		%016lx		0x%016lx		%lf"
mov	   rsi, r9					    ;Move the index number into rsi for output
mov	   rdx, r11					    ;Move the physical memory address of the element into rdx for output
mov        rax, 1					    ;Tell printf there is one value from ymm registers it needs to grab
mov        rcx, [r11]			 	    	    ;Move an element of the array into rcx for outout in hex format
movsd      xmm0, [r11]                              	    ;Move an element of the array into xmm0 for output in decimal format
call printf                                                 ;An external function that handles output.
inc 	   r12						    ;Increase the counter and index variable

jmp beginloop						    ;Jump to the top of the loop

endloop:						    

mainrestore backuparea

pop        rbp                                              ;Restore the value rbp held when this function began execution.

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.
;==========================================================================================================================================================================
;===== End of the application: outputArray ================================================================================================================================
;==========================================================================================================================================================================

ret                                                         ;Pop an 8-byte integer from the system stack and return to calling function.
;===== End of program outputArray =========================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

