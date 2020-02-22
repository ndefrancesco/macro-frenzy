/* Example macro that fits a minimum area rectangle into a ROI
 * 
 * The fitting is performed by fitMinRectangle() and auxiliary functions.
 * 
 * Nicolás De Francesco - feb 2020.
 */
 
Overlay.remove;
fitMinRectangle();
run("Properties... ", "  stroke=orange");
Overlay.addSelection;
Overlay.show;
run("Restore Selection");

function fiMintRectangle(){
	// fits a minimum area rectangle into a ROI, based on the minimum Feret diameter
	run("Convex Hull");
	getSelectionCoordinates(xp, yp);
	run("Undo"); // until run("Restore Selection"); for convex hull gets into production (ver >= 1.52u18)
	
	np = xp.length;
	
	minFD = getValue("Width") + getValue("Height");
	imin = -1;
	i2min = -1;
	jmin = -1;
	for (i = 0; i < np; i++) {
		maxLD=0;
		imax = -1;
		i2max = -1;
		jmax = -1;
		if(i<np-1) i2 = i + 1; else i2 = 0;
		for (j = 0; j < np; j++) {
			d = abs(perpDist(xp[i], yp[i], xp[i2], yp[i2], xp[j], yp[j]));
			if (maxLD < d) {
				maxLD = d;
				imax = i;
				jmax = j;
				i2max = i2;
				}
			}
		if (minFD > maxLD){
			minFD = maxLD;
			imin = imax;
			i2min = i2max;
			jmin = jmax;
			}
		}
	
	pd = perpDist(xp[imin], yp[imin], xp[i2min], yp[i2min], xp[jmin], yp[jmin]); //signed minFeret
	pairAngle = atan2( yp[i2min]- yp[imin], xp[i2min]- xp[imin]);
	minAngle = pairAngle + PI/2;
	
	hmin = 0;
	hmax = 0;
	
	for (i = 0; i < np; i++) {
		hd = parDist(xp[imin], yp[imin], xp[i2min], yp[i2min], xp[i], yp[i]);
		hmin = minOf(hmin, hd);
		hmax = maxOf(hmax, hd);
		}
	
	nxp=newArray(4);
	nyp=newArray(4);
	
	nxp[0] = xp[imin] + cos(pairAngle) * hmax;
	nyp[0] = yp[imin] + sin(pairAngle) * hmax;
	
	nxp[1] = nxp[0] + cos(minAngle) * pd; 
	nyp[1] = nyp[0] + sin(minAngle) * pd;
	
	nxp[2] = nxp[1] + cos(pairAngle) * (hmin-hmax); 
	nyp[2] = nyp[1] + sin(pairAngle) * (hmin-hmax);
	
	nxp[3] = nxp[2] + cos(minAngle) * - pd; 
	nyp[3] = nyp[2] + sin(minAngle) * - pd;
	
	makeSelection("polygon", nxp, nyp);
	}

function dist2(x1,y1,x2,y2){
	return pow(x1-x2, 2) + pow(y1-y2, 2);
	}

function perpDist(p1x, p1y, p2x, p2y, x, y){
	// signed distance from a point (x,y) to a line passing through p1 and p2
	return ((p2x - p1x)*(y - p1y) - (x - p1x)*(p2y - p1y))/sqrt(dist2(p1x, p1y, p2x, p2y));
	}
	
function parDist(p1x, p1y, p2x, p2y, x, y){
	// signed projection of vector (x,y)-p1 into a line passing through p1 and p2
	return ((p2x - p1x)*(x - p1x) + (y - p1y)*(p2y - p1y))/sqrt(dist2(p1x, p1y, p2x, p2y));
	}
