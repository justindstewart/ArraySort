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
;  File name: asmSwap.asm
;  This module's call name: asmSwap
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2015-Oct-28
;  Purpose: Receives two memory addresses and swaps them before passing them back to sort function.
;  Preconditions: The first argument is passed in via rdi, and the second argument via rsi
;  Postconditions: The memory addresses in rdi and rsi will have swapped
;  Future enhancements: None planned.
;Translator information
;  Linux: nasm -f elf64 -l asmSwap.lis -o asmSwap.o asmSwap.asm
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
	
global asmSwap                                              ;Set a global call name in order to be called by another program.

segment .data                                               ;Initialized data are placed in this segment.

segment .bss                                                ;Uninitialized data are declared in this segment.

;==========================================================================================================================================================================
;===== Begin the application here: asmSwap ================================================================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Instructions for the program are placed in the following segment.

asmSwap:                                                    ;Begin execution of the program here.

push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now

mov        r14, [rdi]					    ;Copy the memory address stored in rdi (passed in from calling function, bubbleSort) into r14 for swap.
mov        r13, [rsi]					    ;Copy the memory address stored in rsi (passed in from calling function, bubbleSort) into r13 for swap.

mov        [rsi], r14					    ;Swap the address originally in rdi into rsi.
mov        [rdi], r13					    ;Swap the address originally in rsi into rdi.

pop        rbp                                              ;Restore the value rbp held when this function began execution.

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.
;==========================================================================================================================================================================
;===== End of the application: asmSwap ====================================================================================================================================
;==========================================================================================================================================================================

ret                                                         ;Pop an 8-byte integer from the system stack and return to calling function.
;===== End of program asmSwap =============================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

