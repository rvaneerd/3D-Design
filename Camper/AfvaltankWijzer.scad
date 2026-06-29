$fn=48;

barSize=8.6;
mountWidth=15;
mountThickness=20;
arrowSize=25;
arrowHead=5;

screwDiameter=4;
insertDiameter=6.1;

module mount() {
    difference() {
        cylinder(h = mountWidth, d = mountThickness+barSize, center=true);
        cube([barSize,barSize,mountWidth], center=true);
    }
}

module arrows() {
    arrowDistance = (barSize+mountThickness)/2-3;
    translate([arrowDistance,0,0]) {
        rotate([0,90,0]) {
            cylinder(h = arrowSize, d1 = mountWidth, d2 = arrowHead);
        }
    }
    translate([-1*arrowDistance,0,0]) {
        rotate([0,-90,0]) {
            cylinder(h = arrowSize, d1 = mountWidth, d2 = arrowHead);
        }
    }
}

module screwHole () {
    rotate([90,0,0]) {
        translate([0,0,(mountThickness+barSize)/2]) {
            cylinder(h = mountThickness, d1 = screwDiameter, d2 = screwDiameter*3, center = true);
        }
    }
}

module screwInsert () {
    rotate([90,0,0]) {
        translate([0,0,(mountThickness+barSize)/2]) {
            cylinder(h = mountThickness, d = insertDiameter, center = true);
        }
    }
}

difference() {
    mount();
//    screwHole();
    screwInsert();
    rotate([180,0,0]) {
        screwInsert();
    }
}
arrows();
