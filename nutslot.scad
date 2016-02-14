widthAcrossCorners=6; //in mm for an M3 nut
widthAcrossFlats=2*sin(60)*widthAcrossCorners/2; //in mm for an M3 nut.
thickness=2.4; //in mm for an M3 nut

//cube([5,20,10]); //Solid block for holes

module scaledNutSlot(scaleFactor) {
linear_extrude(height=scaleFactor*thickness) 
union() {
    rotate([0,0,360/12]) circle(r=scaleFactor*widthAcrossCorners/2,$fn=6);
    translate([-scaleFactor*widthAcrossFlats/2,0,0]) square(size=[scaleFactor*widthAcrossFlats,20],center=false);
    translate([-scaleFactor*widthAcrossFlats/6,-20,0]) square(size=[scaleFactor*widthAcrossFlats/3,20],center=false);
}
}

difference() {
cube(size=[110,10,10]);
translate([6,6,6])
rotate([90,0,0])
for(scaleFactor = [1.00:0.05:1.5]) {
    translate([(scaleFactor-1)*20*widthAcrossFlats*2,0,0]) scaledNutSlot(scaleFactor);
}
}