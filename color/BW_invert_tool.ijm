macro "B/W invert Action Tool - R00ff F808f Cfff F117e Cf80 O33aa O4488" {
	title=getTitle();
	setBatchMode(true);
	run("Duplicate...", " ");
	run("Gamma...", "value=2.2");
	run("Duplicate...", " ");
	run("HSB Stack");
	setSlice(2);
	setThreshold(0, 0);
	run("Create Selection");
	run("Select None");
	close();
	run("Restore Selection");
	run("Invert");
	run("Select None");
	run("Gamma...", "value=0.45");
	setBatchMode(false);
	rename("BW inverted - "+title);
	}
