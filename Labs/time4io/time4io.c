
#include <stdint.h>   // Declarations of uint_32 and the like 
#include <pic32mx.h>  // Declarations of system-specific addresses etc 
#include "mipslab.h"  // Declatations for these labs 

int getsw(){
    return (int)((PORTD & 0x00000F00) >> 8);
    //Returns the value of bits 11 to 5.
}

int getbtns(){
   return (int)((PORTD & 0x000000E0) >> 5);
    //Returns the value of 7 to 5.
}


