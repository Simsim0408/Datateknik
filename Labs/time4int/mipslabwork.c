#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int mytime = 0x0001;
int sw;
int btns;
int timeoutcount = 0;

char textstring[] = "text, more text, and even more text!";

volatile int* tris_e = (volatile int*)0xbf886100;
volatile int* port_e = (volatile int*)0xbf886110;



void user_isr(void) {}

void labinit(void)
{
 *tris_e = *tris_e & 0xFFFFFF00; //Changes only bits 7 to 0 to outputs.
  *port_e = 0;  //Initialises the LEDs to be turned off when the program starts.


    T2CON = 0x70;
    PR2 = 31250;
    IFS(0) &= ~(1 << 8);
    IEC(0) |= (1 << 8);
    T2CONSET = 0x8000;

    TRISD = TRISD | 0x00000FE0;
}

void labwork(void)
{
    btns = getbtns();
    if (btns)
    {
        sw = getsw();

        if ((getbtns() & 0x4))
            mytime = (mytime & 0x0fff) | (getsw() << 12);

        if ((getbtns() & 0x2))
            mytime = (mytime & 0xf0ff) | (getsw() << 8);

        if ((getbtns() & 0x1))
            mytime = (mytime & 0xff0f) | (getsw() << 4);
    }

    if (IFS(0) & (1 << 8))
    {
        IFS(0) &= ~(1 << 8);
        
        timeoutcount++;

        if (timeoutcount >= 10)
        {
            timeoutcount = 0;
            time2string(textstring, mytime);
            display_string(3, textstring);
            tick(&mytime);
            display_update();
           *port_e = *port_e + 1;  //Increments the LEDS for each time "tick" is called.


        }
        display_image(96, icon);
    }
}
