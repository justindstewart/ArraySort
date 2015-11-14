//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
//Author information
//  Author name: Justin Stewart
//  Author email: scubastew@csu.fullerton.edu
//  Author location: Long Beach, Calif.
//Course information
//  Course number: CPSC240
//  Assignment number: 4
//  Due date: 2015-Oct-29
//Project information
//  Project title: Array Processing
//  Purpose: The purpose of this project is to provide experience working with arrays in x86-64. This program will prompt the user for data, which will be read into an
//           array. It will then make a copy of the array and sort the copy. Finally it will output the arrays. Each step will be handled in a seperate module.
//  Status: In progress.
//  Project files: arraymain.asm, arraydriver.c, outputArray.asm, inputArray.asm, asmSwap.asm, bubbleSort.c
//Module information
//  File name: arraydriver.c
//  This module's call name: array.out  This module is invoked by the user.
//  Language: C
//  Date last modified: 2015-Oct-28
//  Purpose: This module is the top level driver: it will call array
//  Status: Executed with no errors.
//  Future enhancements: None planned
//Translator information (Tested in Linux shell)
//  Gnu compiler: gcc -c -m64 -Wall -std=c99 -l arraydriver.lis -o arraydriver.o arraydriver.c
//  Gnu linker: gcc -m64 -o array.out arraymain.o arraydriver.o inputArray.o outputArray.o bubbleSort.o asmSwap.o
//  Gnu linker w/ debug:   gcc -m64 -o array.out arraymain.o arraydriver.o inputArray.o outputArray.o debug.o bubbleSort.o asmSwap.o
//  Execute:      ./array.out
//References and credits
//  No references: this module is standard C language
//Format information
//  Page width: 172 columns
//  Begin comments: 61
//  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern double *array(long *a);

int main()
{
	double *myArray;			//Pointer to array that will be filled via assembly call "array"
 	long *size = malloc(sizeof(long));	//Pointer to the size of the array that will be passed into the assembly function
	
	//OUTPUT - Begin start of code, output to user the start of the assembly program
 	printf("%s","This driver program will start the main assembly program of Assignment 4.\n");

	//array - Assembly function used to fill an array
	myArray = array(size);

	//OUTPUT - Output the array filled via the assembly program
 	printf("\n%s\n","Without knowing the purpose the driver received this array:");

	//FOR - Loop through the array outputting each element
 	for(long i = 0; i < *size; i++)
 	{
		printf("%1.11lf\n", myArray[i]);
	}

 	printf("\n%s\n","The driver program will now return 0 to the operating system.  Have a nice day.");

 	return 0;
}//End of main

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
