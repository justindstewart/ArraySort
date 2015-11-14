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
;  File name: inputArray.asm
;  This module's call name: inputArray 
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2015-Sep-27
;  Purpose: Receives an address for an array and prompts the user to input float numbers until the user is finished. Returns the array size to the main assembly program.
;  Preconditions: The address of the array must be passed into rdi for this to function
;  Postconditions: The size of the array will be placed into rbx for the calling function to use
;  Future enhancements: None planned.
;Translator information
;  Linux: nasm -f elf64 -l inputArray.lis -o inputArray.o inputArray.asm
;References and credits
;  Pointer and Reference Passing Project - Holliday  
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;Permission Information
;  This work is private and shall not be posted online, copied or referenced. 
;===== Begin area for source code =========================================================================================================================================

;%include "debug.inc"					    ;External macro used in debugging registers. - NOT IN USE
	
extern printf                                               ;External C program used to output data, backup of registers is important if data is to be preserved.

extern scanf						    ;External C program used to retrieve data, backup of registers is important if data is to be preserved.

extern getchar						    ;External C program used to retrieve char data.

global inputArray                                           ;Set a global call name in order to be called by another program.

segment .data                                               ;Initialized data are placed in this segment.

;===== Messages to be output to user ======================================================================================================================================

promptChar db "Do you have data to enter into the array (Y or N)? ", 0

promptFloat db "Enter the next float number: ", 0

;===== Declare printf/scanf formats =======================================================================================================================================

stringformat db "%s", 0

floatformat db "%lf", 0

segment .bss                                                ;Uninitialized data are declared in this segment.

;==========================================================================================================================================================================
;===== Begin the application here: inputArray  ============================================================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Instructions for the program are placed in the following segment.

inputArray:                                                 ;Begin execution of the program here.

;The next two instructions must be performed at the start of every assembly program.
push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now.

mov 	   r13, rdi					    ;Copy the address of the first element of the array into r13

;===== Output choice to continue ==========================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptChar                                  ;"Do you have data to enter into the array (Y or N)? "
call printf                                                 ;An external function that handles output.

;===== Retrieve choice from user ==========================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

call getchar						    ;An external function that reads in a char from the input stream.
mov 	   r15, rax					    ;Move the choice to input more data by user into r15 for comparison later.
mov 	   r14, 0					    ;Set r14 to be the array index and initialize it to zero.

;General Purpose Registers as of last instruction:
;
;         |-----------------------|
;  r15:   |  -    -     -    (Y/N)|
;         |-----------------------|
;  r14:   |  -    -     -    index|
;         |-----------------------|
;  r13:   |  -    -     -    arloc|
;         |-----------------------|


;===== beginloop: Begin loop code here ====================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

beginloop:
cmp 	   r15, 'Y'					    ;Compare the user inputted value to 'Y' as a sentinel value for the loop
jne endloop

;===== Output float prompt ================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptFloat                                 ;"Enter the next float number: "
call printf                                                 ;An external function that handles output.

;===== Receive float from user ============================================================================================================================================
;No important data in registers, therefore scanf will be called without backup of any data.

mov  qword rax, 0					    ;Zero indicates to scanf that there is no data to grab from lower registers.
mov 	   rdi, floatformat				    ;"%lf"
push qword 0						    ;Reserve 8 bytes of storage for the incomming number.
mov 	   rsi, rsp					    ;Give scanf a point to the reserved storage.

;Integer stack as of last instruction:
;
;          |------|
;   rsp+8: |rflags|
;          |------|
;   rsp:   |  0.0 | rsi
;          |------|

call scanf					    	    ;An external function that handles input from user.

;Integer stack as of last instruction:
;
;          |------|
;   rsp+8: |rflags|
;          |------|
;   rsp:   | flt  | rsi
;          |------|

mov	   r11, [rsp]					    ;Move the value that was input by the user from the stack into r11
mov        [r13 + r14*8], r11			    	    ;Move the float value into the proper position in the array
pop	   rax						    ;Make free the storage that was used by scanf.

;===== Output choice to continue ==========================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptChar                                  ;"Do you have data to enter into the array (Y or N)? "
call printf                                                 ;An external function that handles output.

;===== Retrieve choice from user ==========================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

mov  qword rax, 0					    ;Zero indicates to printf that there is no data to grab from lower registers.
call getchar						    ;An external function that reads in a char from the input stream. Read in newline to clear buffer.
call getchar						    ;An external function that reads in a char from the input stream.
mov 	   r15, rax					    ;Move the choice to input more data by user into r15 for comparison later.
inc 	   r14						    ;Increment the counter

jmp beginloop

endloop:

;===== Set the value to be returned to the caller =========================================================================================================================
;Presently the value to be returned to the caller is in r14.  That value needs to be copied to rbx.

mov 	   rbx, r14					    ;A copy of the count of elements input in the array is now passed into rbx

pop        rbp                                              ;Restore the value rbp held when this function began execution.

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.
;==========================================================================================================================================================================
;===== End of the application: inputArray =================================================================================================================================
;==========================================================================================================================================================================

ret                                                         ;Pop an 8-byte integer from the system stack and return to calling function.
;===== End of program inputArray ==========================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

