/* 
 *  This macro applies a gamma-corrected LUT to all channels in an image.
 */

getDimensions(width, height, channels, slices, frames);
Stack.getPosition(currChannel, currSlice, currFrame);
setBatchMode(true);
for(c=1; c<=channels; c++){
	if(Stack.isHyperstack) Stack.setChannel(c);
	getLut(r, g, b);
	setLUTFromRGBGamma(r[255], g[255], b[255], 0.45);
	}
	
if(Stack.isHyperstack) Stack.setChannel(currChannel);
setBatchMode(false);

function setLUTFromRGBGamma(maxR, maxG, maxB, gamma){
	r=newArray(256);
	g=newArray(256);
	b=newArray(256);
	
	for (i=0; i<256; i++){
		v=pow(i/256, gamma);
		r[i]=v*maxR;
		g[i]=v*maxG;
		b[i]=v*maxB;
		}
	setLut(r, g, b);
	}
