#include <stdlib.h>
#include <6502.h>
#include <lynx.h>
#include <tgi.h>
// enable Mikeys interrupt response
//#define CLI asm("\tcli")

// These header files are related to the processor family, the Lynx and the TGI libraries.

//  this array will contain a string “tgi” that indicates that the loading of the driver was successful.
extern char lynxtgi[]; 



void initialize()
{
	// driver for the Tiny Graphics Interface (TGI)
	// allows for 2D graphics primitives like drawing and text 
  	// Lynx file is called lynx-160-102-16.tgi and is part of the Lynx specific CC65 files
	tgi_install(&lynxtgi);
	// performs the initialization of the loaded drivers of which the TGI graphics driver is just one
	// There are two additional drivers (joystick and comlynx) that you can load as well. 
  	tgi_init();
	// represents the CLI assembly instruction for the 65SC02 processor
	// allows you to clear the Interrupt Disable flag of the processor,   
  	CLI();
	
  	while (tgi_busy())  {  };
 
  	tgi_setpalette(tgi_getdefpalette());
  	tgi_setcolor(COLOR_WHITE);
  	tgi_setbgcolor(COLOR_BLACK);
  	tgi_clear();
}


// Render the screen
// 
void show_screen()
{
	// clearing the screen and redrawing all
  	tgi_clear();
	
	//  set the color for text
 	tgi_setcolor(COLOR_WHITE);
	// some text at a specific x and y coordinate	
	// where x is across from 0 (left) to 160 (right) and y is from 0 (top) to 102 (bottom). 
  	tgi_outtextxy(30, 48, "Hello, World!");
 
	// display is updated
	// tgi_updatedisplay function is a Lynx-only  
  	tgi_updatedisplay();
}

// The entry point is the main function
void main(void)  {	
  	initialize();
	  
	// An infinite loop where we remain forever  
  	while (1)
  	{
    	if (!tgi_busy())
    	{
      		show_screen();
    	}
  	};
}