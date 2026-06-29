width=32;
depth=18;
length=90;
caseThickness=2.5;
mountingLipLength=20;
screwDiameter=3.5;

module screwHole () {
    color("green",1.0) {
        translate([0,0,caseThickness/2])
            cylinder(h = caseThickness, d1 = screwDiameter, d2 = screwDiameter*3, center = true);
        translate([0,0,-caseThickness]){
            cylinder(h=(caseThickness*2), d=screwDiameter);
        };
    }
}

module box() {
    difference() {
        cube([width+2*caseThickness,depth+2*caseThickness,length+1*caseThickness], center = true);
        translate([0,0,caseThickness])
            cube([width,depth,length], center = true);
    }
}

module mountPlate() {
    difference() {
        color("blue", 1.0) {
            cube([width+2*caseThickness,caseThickness,length+2*mountingLipLength], center = true);
        }
        rotate([-90,0,0]) {
            translate([(width-10)/2,(length+mountingLipLength)/2,0])
                screwHole();
            translate([-(width-10)/2,(length+mountingLipLength)/2,0])
                screwHole();
            translate([(width-10)/2,-(length+mountingLipLength)/2,0])
                screwHole();
            translate([-(width-10)/2,-(length+mountingLipLength)/2,0])
                screwHole();
        }
    }
}

module mountSupports() {
    color("red", 1.0) {
        // Top left
        translate([width/2,-(depth/2+3*caseThickness),length/2-caseThickness])
            rotate([90,0,0])
                cylinder(h = 10, d = 5, center = true);
        // Top right
        translate([-width/2,-(depth/2+3*caseThickness),length/2-caseThickness])
            rotate([90,0,0])
                cylinder(h = 10, d = 5, center = true);
        // Bottom left
        translate([width/2,-(depth/2+2*caseThickness)-5,-(length/2-caseThickness)])
            rotate([90,0,0])
                cylinder(h = 19, d = 5, center = true);
        // Bottom right
        translate([-width/2,-(depth/2+2*caseThickness)-5,-(length/2-caseThickness)])
            rotate([90,0,0])
                cylinder(h = 19, d = 5, center = true);
    }
}

module UnderDeskAircoRemoteControlStorage() {
    union () {
        box();
        rotate([-5,0,0])
            translate([0,-(depth+2.5*caseThickness),0])
                mountPlate();
        mountSupports();
    }
}

UnderDeskAircoRemoteControlStorage();