/*
3.5" Drive Bay Blank
(C) 2016 Eric Anopolsky

All dimensions are in mm.
TODO: Alter dimensions to compensate for shrinkage.
*/

/* Dimensional accuracy.
 * When printed using PLA on a RepRap Prusa i3 from HIC, width 
 * was set to 101.60 and height was set to 25. Actual width was 101.20
 * and actual height was 25.06. The blank fit into the bay acceptably.
 * 
 * However, M3 nuts did not fit into the cutouts. Width across corners 
 * for the cutouts was set to 6. Actual width across corners was around 5.
 *
 * Screw holes were also slightly too small. They were set to 3.30, but
 * were actually around 3.0 in the printed part. This caused very minor
 * binding on screw insertion, but not enough to justify changing the
 * parameter at this time.
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
hexNutWidth=7; //This variable contains the "width across corners" measurement. Actually 6mm, but set to 7mm as they were too small.
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

//One copy:
partWithHoles();

//Two copies:
/*
partWithHoles();
translate([width+3*thickness,depth+3*thickness,0]) rotate([0,0,180]) partWithHoles(); 
*/

//Three copies:
/*
translate([0,width,0]) rotate([0,0,-90]) partWithHoles();
translate([0,width*2+thickness,0]) rotate([0,0,-90]) partWithHoles();
translate([depth+thickness*4,thickness*4,0]) rotate([0,0,90]) partWithHoles();
*/

//Four copies:
/*
translate([0,width,0]) rotate([0,0,-90]) partWithHoles();
translate([0,width*2+thickness,0]) rotate([0,0,-90]) partWithHoles();
translate([depth+thickness*4,thickness*4,0]) rotate([0,0,90]) partWithHoles();
translate([depth+thickness*4,thickness*4+width+thickness,0]) rotate([0,0,90]) partWithHoles();
*/
//Prusa i3 build area.
//color("blue") square([200,200]);
