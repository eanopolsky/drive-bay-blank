/*
3.5" Drive Bay Blank
(C) 2016 Eric Anopolsky

All dimensions are in mm.
TODO: Alter dimensions to compensate for shrinkage.
TODO: Consider adding mouse ears if necessary to prevent warping.
TODO: Measure hex nuts to determine whether 5.5mm is the width across flats or width across corners.
TODO: Consider packing multiple blanks into each print.
*/

//variables for part without holes
thickness=5; //thickness of the walls of the blank
depth=85+30+10; //depth of the blank into the PC case. 147mm per spec, but we can get away with less.
width=101.60; //width of the front of the blank
height=25; //height of the front of the blank

//variables for screw cutouts
screwHoleCenterHeight=4.5; //distance between the center of each screw hole and the bottom of the part.
/* Per http://www.metrication.com/engineering/fastener.html
 * the width across corners of a metrix hex nut is twice the
 * basic screw diameter.
 */
hexNutWidth=6; //This variable contains the "width across corners" measurement.
hexNutHeight=2;
M3ScrewClearance=3.30;
interiorHeight=screwHoleCenterHeight+(hexNutWidth/2*sin(60))*2+thickness; //distance between the top and bottom of the part inside the PC case

module partWithoutHoles() {
    union() {
    intersection() { 
        linear_extrude(height) polygon([[0,0],[0,depth],[thickness,depth],[thickness,thickness],[width-thickness,thickness],[width-thickness,depth],[width,depth],[width,0]]); //Main part body.
        rotate([0,-90,0]) translate([0,0,-width]) linear_extrude(height=width) polygon([[0,0],[0,depth],[       interiorHeight,depth],[interiorHeight,thickness+height-interiorHeight],[height,thickness],[height,0]]); //Trims interior height to optimize build time.
    }
    linear_extrude(thickness) { //Triangular front panel braces.
        translate([thickness,thickness]) polygon([[0,0],[0,2*thickness],[2*thickness,0]]);
        translate([-thickness,thickness]) polygon([[width,0],[width,2*thickness],[width-2*thickness,0]]);
    }
    }
}

module screwNutCutout() {
//rotate([0,0,360/12]) //Rotating the nut cutout is perhaps unhelpful due to overhang. 
union() {
    //This produces a simple hex shape, resulting in 30 degree overhangs.
    //translate([0,0,-1]) linear_extrude(height=hexNutHeight+1) circle(hexNutWidth/2,$fn=6);
    
    //This produces a hex shape with a modified side to allow for 60 degree overhangs.
    translate([0,0,-1]) linear_extrude(height=hexNutHeight+1)
    union() {
        circle(hexNutWidth/2,$fn=6);
        polygon([[hexNutWidth/2*cos(60),hexNutWidth/2*sin(60)],[0,2*hexNutWidth/2*sin(60)],[-hexNutWidth/2*cos(60),hexNutWidth/2*sin(60)]]);
      }
    //The hole for the M3 screw:
    linear_extrude(height=thickness+1) circle(M3ScrewClearance/2,$fn=40);
}
}

module partWithHoles() {
difference() {
    partWithoutHoles();
    translate([thickness,85,screwHoleCenterHeight]) rotate([90,0,-90]) screwNutCutout();
    translate([thickness,85+30,screwHoleCenterHeight]) rotate([90,0,-90]) screwNutCutout();
    translate([width-thickness,85,screwHoleCenterHeight]) rotate([90,0,90]) screwNutCutout();
    translate([width-thickness,85+30,screwHoleCenterHeight]) rotate([90,0,90]) screwNutCutout();
}
}

partWithHoles();


//A second copy to double the time between human intervention.
//translate([width+3*thickness,depth+3*thickness,0]) rotate([0,0,180]) partWithHoles(); 

//Prusa i3 build area.
//color("blue") square([200,200]);