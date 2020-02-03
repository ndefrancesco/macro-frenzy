/* ***************  BW invert tool ***************
 * Nicolás De Francesco, Feb. 2020
 * 
 * This tool inverts the lightness of the image, conserving color hues and saturation.
 * It was created for inverting black or white background images for presentations.
 * The whole idea spawned from this tweet: 
 * https://twitter.com/rhutto3/status/1223001958811725825?s=20
 * 
 * The main routine is derived form Jérôme Mutterer's insightful snippet: 
 * https://twitter.com/jmutterer/status/1224027996320927748?s=20	
 * 
 * Right click on the icon to configure additional gamma compression. 	
 * 	
 */

var useGamma = true;
var gammaValue = 0.45;
macro "B/W invert Action Tool - R00ff F808f Cfff F117e Cf80 O33aa O4488" {
	title=getTitle();
	setBatchMode(true);
	run("Duplicate...", " ");
	run("Invert");
	run("HSB Stack");
	setThreshold(0, 127);
	run("Create Selection");
	resetThreshold();
	run("Add...", "value=128 slice");
	run("Make Inverse");
	run("Subtract...", "value=128 slice");
	run("Select None");
	run("RGB Color");
	if (useGamma) run("Gamma...", "value=&gammaValue");
	setBatchMode(false);
	rename("BW inverted - "+title);
	}

macro "B/W invert Action Tool Options"{
	Dialog.create("BW inverter tool options");
	Dialog.addCheckbox("Add gamma compression", useGamma);
	Dialog.addNumber("gamma value:", gammaValue, 2, 4, "");
	Dialog.show();
	
	useGamma = Dialog.getCheckbox();
	gammaValue = Dialog.getNumber();
	}
