// By MegaSaturnv

/////////////////////////////
// Customizable Parameters //
/////////////////////////////
/* [Basic] */
HOLE_HEIGHT = 4;
HOLE_X_SPACING = 7.3;
HOLE_Y_SPACING = 7.3;

switchHolesSizes = [5.7,  5.8,  5.9,  6.0,  6.1,  6.2,  6.3];  // 6.1 is best
keySizes         = [1.00, 1.05, 1.10, 1.15, 1.20, 1.25, 1.30]; // 1.2 is best

/* [Advanced] */
//Use $fn = 24 if it's a preview. $fn = 96 for the render. Increase 96 to produce a smoother curve.
$fn = $preview ? 24 : 96;

////////////////
// Main Model //
////////////////
difference() {
	cube([len(switchHolesSizes) * HOLE_X_SPACING + 0.25*switchHolesSizes[round(len(switchHolesSizes)/2)], len(keySizes) * HOLE_Y_SPACING + 0.25*switchHolesSizes[round(len(switchHolesSizes)/2)], HOLE_HEIGHT]);
	for (diameterInc = [0:len(switchHolesSizes)-1], keyInc = [0:len(keySizes)-1]) {
		translate([diameterInc * HOLE_X_SPACING + 0.75*switchHolesSizes[diameterInc], keyInc * HOLE_Y_SPACING + 0.75*switchHolesSizes[diameterInc], -0.01]) difference() {
			cylinder(d=switchHolesSizes[diameterInc], h=HOLE_HEIGHT+0.02);
			translate([keySizes[keyInc]/-2, switchHolesSizes[diameterInc]/2 - keySizes[keyInc]/2, 0]) cube([keySizes[keyInc], keySizes[keyInc], HOLE_HEIGHT+0.02]);
		}
	}
}
