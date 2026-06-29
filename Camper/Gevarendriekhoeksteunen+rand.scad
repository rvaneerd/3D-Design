height=65;
width=50;
depth=35;

mountBaseWidth=15;
mountBaseHeight=5;

difference() {
    union() {
        cube([height+mountBaseWidth,width+mountBaseWidth,mountBaseHeight]);
        translate([mountBaseWidth,mountBaseWidth,0]) {
            cube([height,width,depth]);
        }
    }
    translate([mountBaseWidth+mountBaseHeight,mountBaseWidth+mountBaseHeight,0]) {
        cube([height-mountBaseHeight,width-mountBaseHeight,depth-mountBaseHeight]);
    }
}