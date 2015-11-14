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
//  File name: bubbleSort.c
//  This module's call name: bubbleSort.  This module is invoked by the user.
//  Language: C
//  Date last modified: 2015-Oct-28
//  Purpose: This module is a sort algorithm, using the bubble sort method. It will invoke a swap using x86-64.
//  Status: Executed with no errors.
//  Future enhancements: None planned
//Translator information (Tested in Linux shell)
//  Gnu compiler: gcc -c -m64 -Wall -std=c99 -l bubbleSort.lis -o bubbleSort.o bubbleSort.c
//References and credits
//  No references: this module is standard C language
//Format information
//  Page width: 172 columns
//  Begin comments: 61
//  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
//===== Begin code area ===================================================================================================================================================

//Prototype for bubble sort. Receives an array of address and a length of the array. Called from x86-64 main.
void bubbleSort(double **list, long length);

//Prototype for swap using x86-64.
extern void asmSwap(double **a, double **b);

void bubbleSort(double **list, long length)
{
	long iteration;		//CALC - Holds the iteration value to loop with.
	long index;		//CALC - Holds the index value to loop with.

	//FOR - Loop through array.
	for(iteration = 1; iteration < length; iteration++)
	{	
		//FOR - Loop through the array and compare the values of the dereferenced indexes.
		for(index = 0; index < length - iteration; index++)
		{	
			//IF - Compare the dereferenced values and swap if the first is greater then its neighbor  
			if(*list[index] > *list[index+1])
			{
				asmSwap(&list[index], &list[index + 1]);			
			}//END IF
		}//END FOR
	}//END FOR
}
