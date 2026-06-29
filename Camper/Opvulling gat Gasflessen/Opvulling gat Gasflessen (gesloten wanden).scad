width = 105;
depth = 90;
height = 90;
wallThickness = 4;
borderHeight = 4;
borderwidth = 10;

center = true;

rotate([0,180,0]){
    difference() {

        union() {
            translate([0,0,(borderHeight)/2]) {
                cube([width+borderwidth*2,depth+borderwidth*2,borderHeight], center);
            }
            translate([0,0,(height+borderHeight)/2]) {
                cube([width,depth,height+borderHeight], center);
            }
        }
        translate([0,0,0]) {
            cube([width-wallThickness,depth-wallThickness,height*2], center);
        }
    }
}