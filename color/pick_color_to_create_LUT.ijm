// This macro creates a LUT from a chosen color
// written by Nicolás De Francesco shared on twitter @nevermore_78 on 15-5-21
// https://twitter.com/nevermore_78/status/1393444693594316802?s=20&t=nBl0WVCyjCsfVkg7V7leUw
// inspired by a tweet by @DrMattBenton
// Pick one!  (@FijiSc macro)
#@ ColorRGB(value="red") color
newImage("new_LUT","8-bit ramp",256,32,1);
c=split(color,",");
r=Array.resample(newArray(0,c[0]),256);
g=Array.resample(newArray(0,c[1]),256);
b=Array.resample(newArray(0,c[2]),256);
setLut(r,g,b);
saveAs("LUT");
//  :)
