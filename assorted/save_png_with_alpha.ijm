#@ ImagePlus (label="RGB image") rgbImage
#@ ImagePlus (label="alpha image") alphaImage

setBatchMode(true);

selectImage(alphaImage);
getDimensions(alpha_width, alpha_height, alpha_channels, alpha_slices, alpha_frames);
if (bitDepth()!=8 || nSlices!=1) exit("alpha channel must be 8-bit, single slice");

run("Copy");

selectImage(rgbImage);
alphaPNG = "alpha_" + getTitle();
PNGid = getImageID();
getDimensions(rgb_width, rgb_height, rgb_channels, rgb_slices, rgb_frames);
if (bitDepth()!=24 || nSlices!=1) exit("alpha channel must be 24-bit, single slice");
if (rgb_width != alpha_width || rgb_height != alpha_height) exit("images must have the same size");

run("Select None");
run("Duplicate...", "title=&alphaPNG");
run("Make Composite");
setSlice(3);
run("Add Slice", "add=channel");
setSlice(4);
run("Paste");
run("Select None");
run("Set Label...", "label=alpha");
Stack.setActiveChannels("1110");
run("PNG...");

setBatchMode(false);