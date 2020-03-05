/* Macro tool to move channels in multichannel images with sub-pixel resolution
 * Nicolas De Francesco - March 2020
 */

var net_dx;
var net_dy;
var title;
var corrected="";
var temp;
var small = 30;
var big = 90;


macro "Setup [F5]" {
	title = getTitle();
	corrected = "corrected-"+title;
	temp = "temp-"+title;
	
	getDimensions(width, height, channels, slices, frames);
	
	net_dx=newArray(channels);
	net_dy=newArray(channels);

	if(!isOpen(corrected)) run("Duplicate...", "title=&corrected duplicate");
	moveChannel(1, 0, 0);
	}

macro "Move channels Tool - Cf0f L18f8L818f Cfb8 O11ee O22cc" {
   	shift=1;
	ctrl=2; 
	rightButton=4;
	alt=8;
	leftButton=16;
	insideROI = 32;
	getCursorLoc(x, y, z, flags);
	
	if(flags&leftButton!=0 && corrected==getTitle()){ 
		x2=x;
		y2=y;
		Stack.getPosition(channel, slice, frame);
		
		while (flags & leftButton != 0){
			getCursorLoc(x, y, z, flags);
			if (x!=x2 || y!=y2){
				dx = x - x2;
				dy = y - y2;
				mult = small;
				if(flags & ctrl == 0) mult = big;
				moveChannel(channel, dx/mult, dy/mult);
				wait(50);
				x2=x;
				y2=y;
				}
		 	}
		}
	}

macro "Move channels Tool Options" {
	Dialog.create("Move Channels Options");
	Dialog.addMessage(	"Usage:\n \n"+
				      	"Select the image to correct, and press F5 to create\n"+
				      	"a working copy (or to reset it). Select the move channel tool.\n \n"+
				      	"Select a channel to move in the copy, and click & drag.\n"+		
						"Pressing Ctrl amplifies the mouse movement.\n"+
						"The zoom state of the image also changes the amount moved.\n \n"+
						"You can save the new image at any point.\n \n" );
						
	Dialog.addNumber("Small step multiplier:", small);
	Dialog.addNumber("Big step multiplier:", big);
	Dialog.show();
	small = Dialog.getNumber();
	big = Dialog.getNumber();
	}

function moveChannel(channel, ndx, ndy){
	setBatchMode(true);
	selectWindow(title);
	run("Duplicate...", "title=&temp duplicate channels=&channel");
	net_dx[channel-1] += ndx;
	net_dy[channel-1] += ndy;
	run("Translate...", "x="+net_dx[channel-1]+" y="+net_dy[channel-1]+" interpolation=Bicubic slice");
	run("Copy");
	close();
	selectWindow(corrected);
	Stack.setChannel(channel);
	run("Paste");
	run("Select None");
	setBatchMode(false);
	}
