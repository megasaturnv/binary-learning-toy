//Counting_Toy.scad by MegaSaturnv 2021-04-02
 
//TODO:
// * Replace signed and unsigned lines with variables and calculations

/////////////////////////////
// Customizable Parameters //
/////////////////////////////
/* [Basic] */
ROUNDED_EDGES      = true;

RENDER_BOX_BASE    = true;
RENDER_BOX_LID     = true;
RENDER_DISPLAY_LID = true;
RENDER_ARDUINO_LID = true;
RENDER_TP4056_LID  = true;

CURRENT_DATE = "2021-04-11";

BOX_X             = 150;
BOX_Y             = 71;
BOX_Z             = 40;
BOX_LID_Z         = 4;
BOX_LID_TOLERANCE = 0.4;
BOX_THICKNESS     = 2;

BOX_SCREW_MOUNT_DIAMETER      = 12;
BOX_SCREW_MOUNT_HOLE_DIAMETER = 3.2;
BOX_SCREW_MOUNT_HOLE_DEPTH    = 26;
BOX_SCREW_MOUNT_POSITION      = 6;

TEXT_SIZE         = 5;
TEXT_DEPTH        = 0.4;
TEXT_FONT         = "Liberation Sans:style=Bold";
TEXT_UPPER_OFFSET = 3;
TEXT_LOWER_OFFSET = 7;

DISPLAY_WIDTH      = 50.4;
DISPLAY_LENGTH     = 19.1;
DISPLAY_THICKNESS  = 8;
DISPLAY_TOP_MARGIN = 10;

SWITCH_HOLE_DIAMETER = 6.2;
SWITCH_HOLE_KEY_SIZE = 1.2;
SWITCH_POST_DIAMETER = 13;
SWITCH_POST_HEIGHT   = 7-BOX_THICKNESS;

UPPER_SWITCH_DISTANCE_BETWEEN = 9.5;
UPPER_SWITCH_QUANTITY         = 8;
UPPER_SWITCH_Y                = 50;
UPPER_SWITCH_TEXT_2           = ["1", "2", "4", "8", "16", "32", "64", "+/-"];

LOWER_SWITCH_Y = 15;
LOWER_SWITCH_X = 43;

LINES_WIDTH = 1;
LINES_DEPTH = 0.4;

18650_HOLDER_HEIGHT         = 30;
18650_TRIANGLE_EXTRA_HEIGHT = 2;
18650_HEIGHT                = 65;
18650_DIAMETER              = 18.3;
18650_SHELF_SIZE            = 8;

CIRCUITBOARDS_SCREW_MOUNT_DIAMETER      = 8; //4.7
CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER = 2.5;
CIRCUITBOARDS_SCREW_MOUNT_HOLE_DEPTH    = 6;
CIRCUITBOARDS_WALL_THICKNESS            = 1;
CIRCUITBOARDS_LID_THICKNESS             = 2;

ON_OFF_SWITCH_HOLE_WIDTH  = 19.1;
ON_OFF_SWITCH_HOLE_LENGTH = 12.6;
ON_OFF_SWITCH_POS_X       = 17.4;
ON_OFF_SWITCH_POS_Z       = 20;

TP4056_WIDTH           = 17.1;
TP4056_LENGTH          = 28.5;
TP4056_THICKNESS       = 4.6;
TP4056_MOUNT_HEIGHT    = 5;
TP4056_USB_HOLE_HEIGHT = 3.0;
TP4056_USB_HOLE_WIDTH  = 8.5;
TP4056_CHARGING_LEDS_CUTOUT_POS_X  = 14.4;
TP4056_CHARGING_LEDS_CUTOUT_POS_Y  = 5.6;
TP4056_CHARGING_LEDS_CUTOUT_WIDTH  = 2;
TP4056_CHARGING_LEDS_CUTOUT_LENGTH = 6;

ARDUINO_PRO_MINI_WIDTH        = 18.7;
ARDUINO_PRO_MINI_LENGTH       = 33.9;
ARDUINO_PRO_MINI_THICKNESS    = 3.3;
ARDUINO_PRO_MINI_SCREW_HEIGHT = 2.5;

/* [Advanced] */
//Use $fn = 24 if it's a preview. $fn = 96 for the render. Increase 96 to produce a smoother curve.
$fn = $preview ? 24 : 96;


/////////////
// Modules //
/////////////
// https://www.thingiverse.com/thing:58478
// Rounded primitives for openscad
// (c) 2013 Wouter Robers 
module rcube(Size=[20,20,20],b=2)
{hull(){for(x=[-(Size[0]/2-b),(Size[0]/2-b)]){for(y=[-(Size[1]/2-b),(Size[1]/2-b)]){for(z=[-(Size[2]/2-b),(Size[2]/2-b)]){ translate([x,y,z]) sphere(b);}}}}}

module rcubeSlice(Size=[20,20,20],b=2) {
	translate([0, 0, -b])
	difference() {
		rcube([Size[0], Size[1], Size[2]+b*2], b);
	}
	cube([Size[0], Size[1], b]);
	translate([0, 0, Size[2]]) cube([Size[0], Size[1], b]);	
}

module roundedCorner(sideLength=8, thickness=2, cylinderCenter=false) {
	difference() {
		cube([sideLength, sideLength, thickness]);
		if (cylinderCenter) { //Cylinder cutout is in the centre
			translate([0, 0, -0.01]) cylinder(r=sideLength, h=thickness+0.02);
		} else { //Corner of the object is in the centre
			translate([sideLength, sideLength, -0.01]) cylinder(r=sideLength, h=thickness+0.02);
		}
	}
}

module drawAvatar(pxSize=2, thickness=2, center=true) {
    avatar = [
    " X X ",
    "XX XX",
    " XXX ",
    "  X  ",
    "X X X"];
    for (i = [0 : len(avatar)-1], j = [0 : len(avatar[i])-1]) {
        if (avatar[i][j] == "X") {
			if (center)	{
				translate([-(len(avatar)*pxSize)/2, -(len(avatar[0])*pxSize)/2, 0])
				translate([i*pxSize, j*pxSize, 0])
				cube([pxSize, pxSize, thickness]);
			} else {
				translate([i*pxSize, j*pxSize, 0])
				cube([pxSize, pxSize, thickness]);
			}
        }
    }
}

module switchHolePostOld(holeDiameter=6, postDiameter=12, keySize=1, height=2) {
	difference() {
		cylinder(d=postDiameter, h=height);
		difference() {
			translate([0, 0, -0.01]) cylinder(d=holeDiameter, h=height+0.02);
			translate([keySize/-2, holeDiameter/2 - keySize/2, -0.01]) cube([keySize, keySize, height+0.02]);
		}
	}
}
module switchHolePost(holeDiameter=6, postDiameter=12, keySize=1, height=2, justHole=false) {
	if (justHole) {
		difference() {
			cylinder(d=holeDiameter, h=height);
			translate([keySize/-2, holeDiameter/2 - keySize/2, -0.01]) cube([keySize, keySize, height+0.02]);
		}
	} else {
		difference() {
			cylinder(d=postDiameter, h=height);
			translate([0, 0, -0.01]) cylinder(d=holeDiameter, h=height+0.02);
		}
		translate([keySize/-2, holeDiameter/2 - keySize/2, 0]) cube([keySize, keySize, height]);
	}
}

module screwMountingPosts(width=50, length=30, screwHoleHeight=5, screwHoleOuterDiameter=6, screwHoleInnerDiameter=3, screwHoleInnerDepth=3, center=true, justHole=false) {
	if (center) {
		for (i=[-1,1], j=[-1,1]) {
			translate([i*(width/2), j*(length/2), 0]) difference() {
				if (!justHole) cylinder(d=screwHoleOuterDiameter, h=screwHoleHeight);
				translate([0,0,screwHoleHeight-screwHoleInnerDepth]) cylinder(d=screwHoleInnerDiameter, h=screwHoleInnerDepth+0.01);
			}
		}
	} else {
		for (i=[0,2], j=[0,2]) {
			translate([i*(width/2), j*(length/2), 0]) difference() {
				if (!justHole) cylinder(d=screwHoleOuterDiameter, h=screwHoleHeight);
				translate([0,0,screwHoleHeight-screwHoleInnerDepth]) cylinder(d=screwHoleInnerDiameter, h=screwHoleInnerDepth+0.01);
			}
		}
	}
}

module screwMount(height, diameter, holeDepth, holeDiameter, JustHole=false) {
	difference() {
		if (!JustHole) {
			cylinder(h=height, r=diameter/2);
		}
		translate([0, 0, height-holeDepth]) cylinder(h=holeDepth+0.01, r=holeDiameter/2);
	}
}

module triangle(XLength=5, YLength=8, thickness=2) {
    linear_extrude(height=thickness)
    {
        polygon(points=[[0,0],[XLength,0],[0,YLength]], paths=[[0,1,2]]);
    }
}

module holder18650(height=25, center=false, diameter18650=18, height18650=65, triangleExtraHeight=3.5) {
	if (center) {
		translate([-height18650/2, 0, 0])
		difference() {
			union() {
				//Main Block
				translate([-3, -diameter18650, -height]) cube([height18650+6, diameter18650 + 2, height-diameter18650/2]);
				//End caps
				//translate([-3, -diameter18650, -diameter18650]) cube([2, diameter18650, diameter18650]);
				//translate([height18650 + 1, -diameter18650, -diameter18650]) cube([2, diameter18650, diameter18650]);
			}
			translate([-1, -diameter18650/2, -diameter18650/2]) rotate([0, 90, 0]) cylinder(d=diameter18650, h=height18650+2);
			translate([height18650 + 3 + 0.01, -diameter18650-0.01, -height-0.01]) rotate([0, 270, 0]) triangle(height - diameter18650 + triangleExtraHeight + 0.01, diameter18650 + 0.01, height18650 + 6 + 0.02);
			translate([18650_SHELF_SIZE, -diameter18650-0.01, -height-0.01]) cube([height18650 - 2*18650_SHELF_SIZE, diameter18650+2.02, height+0.01]);
		}
	} else {
		translate([3, 0, 0])
		difference() {
			union() {
				//Main Block
				translate([-3, -diameter18650, -height]) cube([height18650+6, diameter18650 + 2, height-diameter18650/2]);
				//End caps
				//translate([-3, -diameter18650, -diameter18650]) cube([2, diameter18650, diameter18650]);
				//translate([height18650 + 1, -diameter18650, -diameter18650]) cube([2, diameter18650, diameter18650]);
			}
			translate([-1, -diameter18650/2, -diameter18650/2]) rotate([0, 90, 0]) cylinder(d=diameter18650, h=height18650+2);
			translate([height18650 + 3 + 0.01, -diameter18650-0.01, -height-0.01]) rotate([0, 270, 0]) triangle(height - diameter18650 + triangleExtraHeight + 0.01, diameter18650 + 0.01, height18650 + 6 + 0.02);
			translate([4, -diameter18650-0.01, -height-0.01]) cube([height18650-8 , diameter18650+2.02, height+0.01]);
		}
	}
}

module holder18650UpperHalf(center=false, diameter18650=18, height18650=65) {
	if (center) {
		translate([-height18650/2, 0, 0])
		difference() {
			translate([0, -diameter18650, -diameter18650/2]) cube([height18650, diameter18650, diameter18650/2]);
			translate([-0.01, -diameter18650/2, -diameter18650/2]) rotate([0, 90, 0]) cylinder(d=diameter18650, h=height18650+0.02);
		}
	} else {
		translate([3, 0, 0])
		difference() {
			translate([0, -diameter18650, -diameter18650/2]) cube([height18650, diameter18650, diameter18650/2]);
			translate([-0.01, -diameter18650/2, -diameter18650/2]) rotate([0, 90, 0]) cylinder(d=diameter18650, h=height18650+0.02);
		}
	}
}

module arduinoMount(lid=false) {
	if(!lid) {
		difference() {
			union() {
				// Arduino pro mini mount
				cube([ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS, ARDUINO_PRO_MINI_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, ARDUINO_PRO_MINI_THICKNESS]);
				// Arduino pro mini screw mounts
				translate([CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, -CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 + CIRCUITBOARDS_WALL_THICKNESS, 0]) screwMountingPosts(ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, ARDUINO_PRO_MINI_WIDTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, ARDUINO_PRO_MINI_SCREW_HEIGHT + ARDUINO_PRO_MINI_THICKNESS, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DEPTH, center=false);
			}
			// Arduino pro mini cutout
			translate([CIRCUITBOARDS_WALL_THICKNESS, CIRCUITBOARDS_WALL_THICKNESS, 0]) cube([ARDUINO_PRO_MINI_LENGTH, ARDUINO_PRO_MINI_WIDTH, ARDUINO_PRO_MINI_THICKNESS+0.01]);
		}
	} else {
		difference() {
			union() {
				// Arduino pro mini lid
				translate([CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, 0, 0]) cube([ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, ARDUINO_PRO_MINI_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, CIRCUITBOARDS_LID_THICKNESS]);
				translate([(ARDUINO_PRO_MINI_LENGTH*1.1 + CIRCUITBOARDS_WALL_THICKNESS)/(24/9), (ARDUINO_PRO_MINI_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/4, CIRCUITBOARDS_WALL_THICKNESS]) cube([(ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS)/4, (ARDUINO_PRO_MINI_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/2, ARDUINO_PRO_MINI_SCREW_HEIGHT + ARDUINO_PRO_MINI_THICKNESS/4]);
				// Arduino pro mini lid screw holes
				translate([CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_WALL_THICKNESS -CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, 0]) screwMountingPosts(ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, ARDUINO_PRO_MINI_WIDTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_LID_THICKNESS, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER+1, CIRCUITBOARDS_LID_THICKNESS+0.01, center=false);
			}
			translate([ARDUINO_PRO_MINI_LENGTH + CIRCUITBOARDS_WALL_THICKNESS - BOX_SCREW_MOUNT_DIAMETER, ARDUINO_PRO_MINI_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, -0.01]) cube([BOX_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_LID_THICKNESS+0.02]);
		}
	}
}

module TP4056Mount(lid=false) {
	if(!lid) {
		difference() {
			union() {
				// TP4056 mount
				cube([TP4056_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, TP4056_LENGTH + 2*CIRCUITBOARDS_WALL_THICKNESS, TP4056_MOUNT_HEIGHT + TP4056_THICKNESS]);
				// TP4056 screw mounts
				translate([CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 + CIRCUITBOARDS_WALL_THICKNESS, 0]) screwMountingPosts(TP4056_WIDTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, TP4056_LENGTH - 3*CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, TP4056_MOUNT_HEIGHT + TP4056_THICKNESS, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DEPTH, center=false);
			}
			// TP4056 cutout
			translate([CIRCUITBOARDS_WALL_THICKNESS, CIRCUITBOARDS_WALL_THICKNESS, TP4056_MOUNT_HEIGHT]) cube([TP4056_WIDTH, TP4056_LENGTH, TP4056_THICKNESS+0.01]);
			// TP4056 cutout for Micro USB
			translate([(CIRCUITBOARDS_WALL_THICKNESS*2 + TP4056_WIDTH)/2 - TP4056_USB_HOLE_WIDTH/2, -0.02, TP4056_MOUNT_HEIGHT]) cube([TP4056_USB_HOLE_WIDTH, CIRCUITBOARDS_WALL_THICKNESS+0.04, TP4056_THICKNESS+0.01]);
			// TP4056 cutout for wires
			translate([(CIRCUITBOARDS_WALL_THICKNESS*2 + TP4056_WIDTH)/2 - TP4056_USB_HOLE_WIDTH/2, TP4056_LENGTH + CIRCUITBOARDS_WALL_THICKNESS - 0.02, TP4056_MOUNT_HEIGHT]) cube([TP4056_USB_HOLE_WIDTH, CIRCUITBOARDS_WALL_THICKNESS+0.04, TP4056_THICKNESS+0.01]);
			// TP4056 cutout for LEDs
			translate([TP4056_CHARGING_LEDS_CUTOUT_POS_X + CIRCUITBOARDS_WALL_THICKNESS, TP4056_CHARGING_LEDS_CUTOUT_POS_Y + CIRCUITBOARDS_WALL_THICKNESS, -0.01]) cube([TP4056_CHARGING_LEDS_CUTOUT_WIDTH, TP4056_CHARGING_LEDS_CUTOUT_LENGTH, TP4056_MOUNT_HEIGHT + 0.02]);
		}
	} else {
		difference() {
			union() {
				// TP4056 lid
				cube([TP4056_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, TP4056_LENGTH + 2*CIRCUITBOARDS_WALL_THICKNESS, CIRCUITBOARDS_LID_THICKNESS]);
				translate([(TP4056_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/4, (TP4056_LENGTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/2 - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_WALL_THICKNESS]) cube([(TP4056_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/2, (TP4056_LENGTH + 2*CIRCUITBOARDS_WALL_THICKNESS)/2, TP4056_THICKNESS/2]);
				// TP4056 lid screw holes
				translate([CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 + CIRCUITBOARDS_WALL_THICKNESS, 0]) screwMountingPosts(TP4056_WIDTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, TP4056_LENGTH - 3*CIRCUITBOARDS_WALL_THICKNESS - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_LID_THICKNESS, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER+1, CIRCUITBOARDS_LID_THICKNESS+0.01, center=false);
			}
			translate([TP4056_WIDTH + 2*CIRCUITBOARDS_WALL_THICKNESS, 0, -0.01]) cube([CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, BOX_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_LID_THICKNESS+0.02]);
		}
	}
}

module lowerBox() {
	difference() {
		/*union() {
			translate([BOX_X/2, BOX_Y/2, (BOX_Z-BOX_LID_Z)/2]) rcube([BOX_X,BOX_Y,BOX_Z-BOX_LID_Z],2);
			translate([0, 0, BOX_Z-BOX_LID_Z/2]) rcubeSlice([BOX_X, BOX_Y, BOX_LID_Z/2]);
		}*/
		difference() {
			// Main Cube
			cube([BOX_X, BOX_Y, BOX_Z - BOX_LID_Z/2]);
			// Rounded edges
			if (ROUNDED_EDGES) {
				translate([-0.01, -0.01, -0.01]) rotate([90, 0, 90]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_X, cylinderCenter=false);
				translate([-0.01, -0.01, -0.01]) rotate([90, 270, 180]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Y, cylinderCenter=false);
				translate([BOX_X+0.01, BOX_Y+0.01, -0.01]) rotate([90, 0, 270]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_X, cylinderCenter=false);
				translate([BOX_X+0.01, BOX_Y+0.01, -0.01]) rotate([90, 270, 0]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Y, cylinderCenter=false);

				for (i=[0,1], j=[0,1]) {
					translate([i*BOX_X, j*BOX_Y, 0])  if (i + j < 2) {
						rotate([0, 0, i*90 + j*-90]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Z, cylinderCenter=false);
					} else {
						rotate([0, 0, 180]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Z, cylinderCenter=false);
					}
				}
			}
		}
		translate([BOX_THICKNESS, BOX_THICKNESS, BOX_THICKNESS]) cube([BOX_X-BOX_THICKNESS*2,BOX_Y-BOX_THICKNESS*2,BOX_Z]);
	}
}

module upperBox() {
	difference() {
		union() {
			// Upper half of lid
			cube([BOX_X, BOX_Y, BOX_LID_Z/2]);
			// Lower half of lid
			translate([BOX_THICKNESS + BOX_LID_TOLERANCE, BOX_THICKNESS + BOX_LID_TOLERANCE, BOX_LID_Z/2]) cube([BOX_X - BOX_THICKNESS*2 - BOX_LID_TOLERANCE*2, BOX_Y - BOX_THICKNESS*2 - BOX_LID_TOLERANCE*2, BOX_LID_Z/2]);
			// Upper half of 18650 holder
			//translate([BOX_X - BOX_SCREW_MOUNT_DIAMETER, BOX_Y/2, BOX_LID_Z]) rotate([180, 0, 90]) holder18650UpperHalf(true, 18650_DIAMETER, 18650_HEIGHT);
			// TEMP
			translate([BOX_X - BOX_SCREW_MOUNT_DIAMETER, BOX_Y/2, BOX_LID_Z/2]) rotate([180, 0, 90]) holder18650UpperHalf(true, 18650_DIAMETER, 18650_HEIGHT);
		}
		// TEMP
		translate([BOX_X - BOX_SCREW_MOUNT_DIAMETER - 18650_DIAMETER/2, 18650_HEIGHT + 3 + 4, 18650_DIAMETER/2 + BOX_LID_Z/2]) rotate([180, 90, 90]) cylinder(d=18650_DIAMETER, h=18650_HEIGHT+8);

		// Rounded edges
		if (ROUNDED_EDGES) {
			translate([-0.01, -0.01, -0.01]) rotate([90, 0, 90]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_X, cylinderCenter=false);
			translate([-0.01, -0.01, -0.01]) rotate([90, 270, 180]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Y, cylinderCenter=false);
			translate([BOX_X+0.01, BOX_Y+0.01, -0.01]) rotate([90, 0, 270]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_X, cylinderCenter=false);
			translate([BOX_X+0.01, BOX_Y+0.01, -0.01]) rotate([90, 270, 0]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_Y, cylinderCenter=false);

			for (i=[0,1], j=[0,1]) {
				translate([i*BOX_X, j*BOX_Y, 0])  if (i + j < 2) {
					rotate([0, 0, i*90 + j*-90]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_THICKNESS+0.01, cylinderCenter=false);
				} else {
					rotate([0, 0, 180]) roundedCorner(sideLength=BOX_THICKNESS, thickness=BOX_THICKNESS+0.01, cylinderCenter=false);
				}
			}
		}
	}
}

////////////////
// Main Model //
////////////////
if (RENDER_BOX_BASE) difference() {
	union() {
		lowerBox();

		// Box screw mounts
		translate([BOX_SCREW_MOUNT_POSITION, BOX_SCREW_MOUNT_POSITION, BOX_THICKNESS]) screwMountingPosts(BOX_X - 2*BOX_SCREW_MOUNT_POSITION, BOX_Y - 2*BOX_SCREW_MOUNT_POSITION, BOX_Z - BOX_LID_Z - BOX_THICKNESS, BOX_SCREW_MOUNT_DIAMETER, BOX_SCREW_MOUNT_HOLE_DIAMETER, BOX_SCREW_MOUNT_HOLE_DEPTH, false);

		// Upper switch holes x8 screw mounts / posts
		for (i = [0:UPPER_SWITCH_QUANTITY-1])
			translate([BOX_X/2 - 3.5*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER) + i*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER), UPPER_SWITCH_Y, BOX_THICKNESS]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, SWITCH_POST_HEIGHT, false);

		// 7 segment display screw mounts / posts
		translate([BOX_X/2 - DISPLAY_WIDTH/2 + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, DISPLAY_TOP_MARGIN - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, BOX_THICKNESS]) screwMountingPosts(DISPLAY_WIDTH - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, DISPLAY_LENGTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, DISPLAY_THICKNESS - BOX_THICKNESS/2, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DEPTH, center=false);

		// Lower switch holes
	translate([BOX_X - LOWER_SWITCH_X, LOWER_SWITCH_Y, BOX_THICKNESS]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, SWITCH_POST_HEIGHT, false);
	translate([LOWER_SWITCH_X, LOWER_SWITCH_Y, BOX_THICKNESS]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, SWITCH_POST_HEIGHT, false);

		// 18650 holder
		translate([BOX_X - BOX_SCREW_MOUNT_DIAMETER, BOX_Y/2, BOX_Z - BOX_LID_Z]) rotate([0, 0, 270]) holder18650(18650_HOLDER_HEIGHT, true, 18650_DIAMETER, 18650_HEIGHT, 18650_TRIANGLE_EXTRA_HEIGHT);

		// TP4056 mount
		translate([BOX_SCREW_MOUNT_DIAMETER, BOX_THICKNESS - CIRCUITBOARDS_WALL_THICKNESS, BOX_THICKNESS]) TP4056Mount();

		// Arduino pro mini mount
		translate([BOX_X - BOX_THICKNESS - ARDUINO_PRO_MINI_LENGTH - CIRCUITBOARDS_WALL_THICKNESS, BOX_SCREW_MOUNT_DIAMETER, BOX_THICKNESS]) arduinoMount();
	}

	// 7 segment display
	translate([BOX_X/2 - DISPLAY_WIDTH/2, DISPLAY_TOP_MARGIN, BOX_THICKNESS/2]) cube([DISPLAY_WIDTH, DISPLAY_LENGTH, BOX_THICKNESS/2 + 0.01]);
	translate([BOX_X/2 - DISPLAY_WIDTH/2, DISPLAY_TOP_MARGIN + BOX_THICKNESS/2, -0.01]) cube([DISPLAY_WIDTH, DISPLAY_LENGTH - BOX_THICKNESS, BOX_THICKNESS/2 + 0.02]);

	// Lower switch holes
	translate([BOX_X - LOWER_SWITCH_X, LOWER_SWITCH_Y, -0.01]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, BOX_THICKNESS+0.02, true);
	translate([LOWER_SWITCH_X, LOWER_SWITCH_Y, -0.01]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, BOX_THICKNESS+0.02, true);
	// Lower switches text 1
	translate([BOX_X - LOWER_SWITCH_X+9.8, LOWER_SWITCH_Y + SWITCH_HOLE_DIAMETER/2 + TEXT_UPPER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text("Unsigned", size=TEXT_SIZE, font=TEXT_FONT, halign="center");
	translate([LOWER_SWITCH_X-2, LOWER_SWITCH_Y + SWITCH_HOLE_DIAMETER/2 + TEXT_UPPER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text("Dec", size=TEXT_SIZE, font=TEXT_FONT, halign="center");
	// Lower switches text 2
	translate([BOX_X - LOWER_SWITCH_X+6, LOWER_SWITCH_Y - SWITCH_HOLE_DIAMETER/2 - TEXT_LOWER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text("Signed", size=TEXT_SIZE, font=TEXT_FONT, halign="center");
	translate([LOWER_SWITCH_X-2, LOWER_SWITCH_Y - SWITCH_HOLE_DIAMETER/2 - TEXT_LOWER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text("Hex", size=TEXT_SIZE, font=TEXT_FONT, halign="center");

	// Upper switch holes x8
	for (i = [0:UPPER_SWITCH_QUANTITY-1])
		translate([BOX_X/2 - 3.5*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER) + i*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER), UPPER_SWITCH_Y, -0.01]) switchHolePost(SWITCH_HOLE_DIAMETER, SWITCH_POST_DIAMETER, SWITCH_HOLE_KEY_SIZE, BOX_THICKNESS+0.02, true);
	// Upper switch text 1
	for (i = [0:UPPER_SWITCH_QUANTITY-1])
		translate([BOX_X/2 - 3.5*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER) + i*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER), UPPER_SWITCH_Y + SWITCH_HOLE_DIAMETER/2 + TEXT_UPPER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text(str(pow(2, i)), size=TEXT_SIZE, font=TEXT_FONT, halign="center");
	// Upper switch text 2
	for (i = [0:UPPER_SWITCH_QUANTITY-1])
		translate([BOX_X/2 - 3.5*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER) + i*(UPPER_SWITCH_DISTANCE_BETWEEN+SWITCH_HOLE_DIAMETER), UPPER_SWITCH_Y - SWITCH_HOLE_DIAMETER/2 - TEXT_LOWER_OFFSET, -0.01]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text(UPPER_SWITCH_TEXT_2[i], size=TEXT_SIZE, font=TEXT_FONT, halign="center");

	//Lines - Unsigned
	translate([133, 23, -0.01]) cube([8, LINES_WIDTH, LINES_DEPTH]);
	translate([140, 23, -0.01]) cube([LINES_WIDTH, 36, LINES_DEPTH]);
	translate([136, 58, -0.01]) cube([5, LINES_WIDTH, LINES_DEPTH]);
	//Lines - Signed
	translate([125, 7,  -0.01]) cube([21, LINES_WIDTH, LINES_DEPTH]);
	translate([145, 7,  -0.01]) cube([LINES_WIDTH, 36, LINES_DEPTH]);
	translate([135, 42, -0.01]) cube([11, LINES_WIDTH, LINES_DEPTH]);

	//Avatar
	translate([15, 15, -0.01]) rotate([0, 0, 270]) drawAvatar(3, 0.4);

	// TP4056 Micro USB hole cutout
	translate([BOX_SCREW_MOUNT_DIAMETER + CIRCUITBOARDS_WALL_THICKNESS + TP4056_WIDTH/2 - TP4056_USB_HOLE_WIDTH/2, -0.01, BOX_THICKNESS + TP4056_MOUNT_HEIGHT]) cube([TP4056_USB_HOLE_WIDTH, BOX_THICKNESS+0.02, TP4056_USB_HOLE_HEIGHT]);

	// TP4056 LEDs hole cutout
	translate([BOX_SCREW_MOUNT_DIAMETER + TP4056_CHARGING_LEDS_CUTOUT_POS_X + CIRCUITBOARDS_WALL_THICKNESS, BOX_THICKNESS + TP4056_CHARGING_LEDS_CUTOUT_POS_Y, -0.01]) cube([TP4056_CHARGING_LEDS_CUTOUT_WIDTH, TP4056_CHARGING_LEDS_CUTOUT_LENGTH, BOX_THICKNESS+0.02]);

	// On/Off Switch
	translate([ON_OFF_SWITCH_POS_X, -0.01, ON_OFF_SWITCH_POS_Z]) cube([ON_OFF_SWITCH_HOLE_WIDTH, BOX_THICKNESS+0.02, ON_OFF_SWITCH_HOLE_LENGTH]);

	//Current Date
	translate([BOX_SCREW_MOUNT_DIAMETER + 2, BOX_Y - BOX_THICKNESS - TEXT_SIZE - 2, BOX_THICKNESS - TEXT_DEPTH]) linear_extrude(TEXT_DEPTH+0.01) text(CURRENT_DATE, size=TEXT_SIZE, font=TEXT_FONT);
}

if (RENDER_BOX_LID) translate([0, BOX_Y+10, 0]) difference() {
	upperBox();

	translate([BOX_SCREW_MOUNT_POSITION, BOX_SCREW_MOUNT_POSITION, 0]) screwMount(2*BOX_LID_Z, BOX_SCREW_MOUNT_DIAMETER, 2*BOX_LID_Z, BOX_SCREW_MOUNT_HOLE_DIAMETER+0.8, true);
	translate([BOX_X - BOX_SCREW_MOUNT_POSITION, BOX_SCREW_MOUNT_POSITION, 0]) screwMount(2*BOX_LID_Z, BOX_SCREW_MOUNT_DIAMETER, 2*BOX_LID_Z, BOX_SCREW_MOUNT_HOLE_DIAMETER+0.8, true);
	translate([BOX_SCREW_MOUNT_POSITION, BOX_Y - BOX_SCREW_MOUNT_POSITION, 0]) screwMount(2*BOX_LID_Z, BOX_SCREW_MOUNT_DIAMETER, 2*BOX_LID_Z, BOX_SCREW_MOUNT_HOLE_DIAMETER+0.8, true);
	translate([BOX_X - BOX_SCREW_MOUNT_POSITION, BOX_Y - BOX_SCREW_MOUNT_POSITION, 0]) screwMount(2*BOX_LID_Z, BOX_SCREW_MOUNT_DIAMETER, 2*BOX_LID_Z, BOX_SCREW_MOUNT_HOLE_DIAMETER+0.8, true);

	CUSTOM_TEXT = ["1 - 16-bit", "2 - 7-segment", "4 - Custom Text", "8 - Counter", "16 - Delay", "32 - Battery Voltage", "64 - Battery %", "128 - Temperature"];
	for (i = [0:len(CUSTOM_TEXT)]) {
		translate([10*i + 42, 67, -0.01]) rotate([0, 0, 90]) linear_extrude(TEXT_DEPTH) mirror([1, 0, 0]) text(CUSTOM_TEXT[i], size=TEXT_SIZE, font=TEXT_FONT, halign="left");
	}
}

if (RENDER_DISPLAY_LID) translate([0, -40, 0])  {
	// Display lid screw holes
	screwMountingPosts(DISPLAY_WIDTH - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, DISPLAY_LENGTH + CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_LID_THICKNESS, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER, CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER+1, CIRCUITBOARDS_LID_THICKNESS+0.01, center=false);
	// Display lid #1
	translate([-CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 - 1, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 - CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER/2, 0]) cube([DISPLAY_WIDTH/4 + 1, DISPLAY_LENGTH + CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER, CIRCUITBOARDS_LID_THICKNESS]);
	// Display lid #2
	translate([DISPLAY_WIDTH*0.75 - CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 - CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER/2, 0]) cube([DISPLAY_WIDTH/4 + 1, DISPLAY_LENGTH + CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER, CIRCUITBOARDS_LID_THICKNESS]);
	// Display lid connecting bar
	translate([-CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 + DISPLAY_WIDTH/4, CIRCUITBOARDS_SCREW_MOUNT_DIAMETER/2 - CIRCUITBOARDS_SCREW_MOUNT_HOLE_DIAMETER/2 + 0.25*0.75*DISPLAY_LENGTH, 0]) cube([DISPLAY_WIDTH/2, 0.75*DISPLAY_LENGTH, CIRCUITBOARDS_LID_THICKNESS]);
	
}

if (RENDER_TP4056_LID) translate([60, -40, 0]) {
	TP4056Mount(true);
}

if (RENDER_ARDUINO_LID) translate([100, -40, 0]) {
	arduinoMount(true);
}
