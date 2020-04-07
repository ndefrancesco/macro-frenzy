title=getTitle();
n=nSlices;
setBatchMode(true);
run("Duplicate...", "title=duplicate duplicate");
run("RGB Color");

newImage("Untitled", "8-bit black", 10, 10, 1);
run("mpl-plasma"); // change this to the desired LUT
getLut(R, G, B);
close();

R=Array.resample(R,n);
G=Array.resample(G,n);
B=Array.resample(B,n);

for (i = 0; i < n; i++) {
	selectWindow(title);
	setSlice(i+1);
	run("Duplicate...", "title=slice");
	r=newArray(0,R[i]);
	g=newArray(0,G[i]);
	b=newArray(0,B[i]);
	r=Array.resample(r,256);
	g=Array.resample(g,256);
	b=Array.resample(b,256);
	setLut(r, g, b);
	run("RGB Color");
	run("Copy");
	close();
	selectWindow("duplicate");
	setSlice(i+1);
	run("Paste");
	}

run("Select None");
setBatchMode(false);
