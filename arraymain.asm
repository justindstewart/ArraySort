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
;  File name: amortmain.asm
;  This module's call name: amort 
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2015-Oct-28
;  Purpose: This is the main assembly calling function that will call the individual modules to fill, sort and output the arrays.
;  Future enhancements: None planned.
;Translator information
;  Linux: nasm -f elf64 -l arraymain.lis -o arraymain.o arraymain.asm
;References and credits
;  Pointer and Reference Passing Project - Holliday
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;Permission Information
;  This work is private and shall not be posted online, copied or referenced. 
;===== Begin area for source code =========================================================================================================================================

;%include "debug.inc"					    ;External macro used in debugging registers. - NOT CURRENTLY USED
	
extern printf                                               ;External C program used to output data, backup of registers is important if data is to be preserved.

extern scanf						    ;External C program used to retrieve data, backup of registers is important if data is to be preserved.

extern bubbleSort					    ;External C program used to retrieve data, backup of registers is important if data is to be preserved.

extern inputArray					    ;External x86 program used to retrieve input values to be put into an array.

extern outputArray					    ;External x86 program used to output values in an array.

global array                                                ;Set a global call name in order to be called by another program, i.e. the driver.

segment .data                                               ;Initialized data are placed in this segment.

;===== Messages to be output to user ======================================================================================================================================

welcome db "Welcome to Array Processing programmed by Justin Stewart.", 10, 10, 0

floatsInput db "Please enter the quadword floats for storange in an array.:", 10, 0

thanks db 10, "Thank you. This is the array:", 10, 0

preSort db 10, "Next the array will be sorted by pointers.", 10, 10, 0

postSort db "The array after sorting by pointers is:", 10, 0

finalOut db 10, "The array without sorting by pointers is still present:", 10, 0

;===== Declare printf/scanf formats =======================================================================================================================================

stringformat db "%s", 0

floatformat db "%lf", 0

intformat db "%ld", 0

segment .bss                                                ;Uninitialized data are declared in this segment.

dataArray resq 100					    ;Array to hold the values of the given array input by the user
pointerArray  resq 100					    ;Array to hold the sorted memory addresses of the elements of the data array
constPointerArray resq 100				    ;Array to hold the original memory addresses of the elements of the data array

;==========================================================================================================================================================================
;===== Begin the application here: Array Processing  ======================================================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Instructions for the program are placed in the following segment.

array:                                                      ;Begin execution of the program here.

;The next two instructions must be performed at the start of every assembly program.
push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now.

mov r12, rdi						    ;Move into r12 the memory address of the variable that was passed into the assembly function

;===== Output welcome message =============================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, welcome                                     ;"Welcome to Array Processing programmed by Justin Stewart."
call printf                                                 ;An external function that handles output.

;===== Output title =======================================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, floatsInput                                 ;"Please enter the quadword floats for storange in an array.:"
call printf                                                 ;An external function that handles output.

;===== Fill array with data from user =====================================================================================================================================

mov 	   rdi, dataArray				    ;Copy the address of the array(and first element) into rdi in order to pass it into the fill function.
call inputArray						    ;Call the function used to fill the array.
mov 	   r15, rbx					    ;inputArray will fill the array and drop the true size into rbx when it returns. Save this value in r15.

;===== Thank you message ==================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, thanks                                      ;"Thank you. This is the array: "
call printf    						    ;An external function that handles output.

;===== Copy array =========================================================================================================================================================
;Take the original array of values and copy the addresses of each element into two new arrays, one for sorting and the other for keeping the original.

mov	   r14, 0					    ;Set a loop counter to step up from zero until it reaches the length of the array. 
mov qword  [pointerArray], dataArray			    ;Move the first memory address into the sorted array and specify the size
mov qword  [constPointerArray], dataArray		    ;Move the first memory address into the constant array and specify the size
mov 	   r13, dataArray				    ;Move the array address into a temporary register to be used as a pointer to the elements

;===== Begin Loop =========================================================================================================================================================

topofloop:

cmp 	   r14, r15					    ;Compare the counter in r14 to the length of the inputted array in r15. 
jge endofloop						    ;If the above conidition is greater-than or even, then jump to the end of the loop.
mov	   [pointerArray + r14*8], r13			    ;Move the memory address in r13 into the given array position
mov	   [constPointerArray + r14*8], r13		    ;Move the memory address in r13 into the given array position
inc 	   r14						    ;Increase the loop counter.
add r13, 8						    ;Increase the pointers position
jmp topofloop						    ;Jump to the top of the loop.

endofloop:						    ;End of the loop to copy array.

;===== Output Array =======================================================================================================================================================

mov  qword rdi, constPointerArray                           ;Move the constant array into rdi to be output by the outputArray function
mov        rsi, r15					    ;Move the size of the array into rsi to be used by the outputArray functions loop
mov        rdx, dataArray				    ;Move the original array starting address into rdx so that the proper index can be calculated for output
call outputArray					    ;An external function that handles output of pointer arrays					

;===== Presort message ====================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, preSort                                     ;"Next the array will be sorted by pointers."
call printf                                                 ;An external function that handles output.

;===== Sort Array =========================================================================================================================================================

mov  qword rdi, pointerArray				    ;Move the pointer array to be sorted into rdi for the sort function to act on
mov        rsi, r15					    ;Move the size of the array into rsi for the sort function to properly loop with
call bubbleSort					   	    ;An external function used to sort an array of pointers

;===== Postsort message ===================================================================================================================================================
;No important data in registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, postSort                                    ;"The array after sorting by pointers is:"
call printf                                                 ;An external function that handles output.

;===== Output Array =======================================================================================================================================================

mov  qword rdi, pointerArray                                ;Move the pointer array into rdi to be output by the outputArray function
mov        rsi, r15					    ;Move the size of the array into rsi to be used by the outputArray functions loop
mov	   rdx, dataArray				    ;Move the original array starting address into rdx so that the proper index can be calculated for output
call outputArray					    ;An external function that handles output of pointer arrays					

;===== Presort message ====================================================================================================================================================
;No important data in lower registers, therefore printf will be called without backup of any data.

mov  qword rax, 0                                           ;Zero indicates to printf that there is no data to grab from lower registers.
mov        rdi, stringformat                                ;"%s"
mov        rsi, finalOut                                    ;"The array without sorting by pointers is still present:"
call printf                                                 ;An external function that handles output.

;===== Output Array =======================================================================================================================================================

mov  qword rdi, constPointerArray                           ;Move the constant array into rdi to be output by the outputArray function
mov        rsi, r15					    ;Move the size of the array into rsi to be used by the outputArray functions loop
mov	   rdx, dataArray				    ;Move the original array starting address into rdx so that the proper index can be calculated for output
call outputArray					    ;An external function that handles output of pointer arrays					

;===== Set the value to be returned to the caller =========================================================================================================================
;Presently the value to be returned to the caller is in r15.  That value needs to be copied to the pointer passed in with rdi.

push r12						    ;Push the memory addressed originally passed into function onto the stack
pop rdi							    ;Pop the memory address back into its original spot, rdi
mov 	   [rdi], r15					    ;Copy the length of the array into the memory location of rdi to be passed back to the driver
mov        rax, dataArray				    ;Copy the address of the dataArray into rax for return to driver
pop        rbp                                              ;Restore the value rbp held when this function began execution.

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.
;==========================================================================================================================================================================
;===== End of the application: Array Processing ===========================================================================================================================
;==========================================================================================================================================================================

ret                                                         ;Pop an 8-byte integer from the system stack and return to calling function.
;===== End of program array ===============================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

