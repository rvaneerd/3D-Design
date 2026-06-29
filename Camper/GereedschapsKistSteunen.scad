height=65;
width=65;
depth=85;   // Gereedschapkoffer

wallThickness=5;

screwDiameter=4;
screwHoleAccess = 15;

module screwHole () {
    translate([0,0,wallThickness/2])
        cylinder(h = wallThickness, d1 = screwDiameter, d2 = screwDiameter*3, center = true);
    translate([0,0,depth]){
        cylinder(h=(wallThickness*2), d=screwHoleAccess);
    };
}


module lock() {
    rotate([0,270,0]) {
        union() {
            difference() {
                cube([height+wallThickness,width,depth+2*wallThickness]);
                translate([wallThickness,wallThickness,wallThickness]) {
                    cube([height,width,depth]);
                }
            }
            translate([0,0,depth/2+wallThickness]) {
                difference() {
                    cylinder(h = depth+2*wallThickness, d = 4 + 2*wallThickness, center = true);
                    cylinder(h = depth+2*wallThickness, d = 4, center = true);
                }
            }
        }
    }
}

module RotatingCorner() {
    rotate([0,270,0]) {
        difference() {
            difference() {
                cube([height+wallThickness,width,depth+2*wallThickness]);
                translate([wallThickness,wallThickness,wallThickness]) {
                    cube([height,width,depth]);
                }
            }
//            union() {
//                translate([height/4,width/4,0]){
//                    screwHole();
//                }
                translate([height*3/4,width/4,0]){
                    screwHole();
                };
//            }
        }
    }
}
module corner() {
    rotate([0,270,0]) {
        difference() {
            difference() {
                cube([height+wallThickness,width,depth+2*wallThickness]);
                translate([wallThickness,wallThickness,wallThickness]) {
                    cube([height,width,depth]);
                }
            }
            union() {
                translate([height/4,width/4,0]){
                    screwHole();
                }
                translate([height*3/4,width*3/4,0]){
                    screwHole();
                };
            }
        }
    }
}

module locks () {
    lock();
    translate([0,width*2.25,0]) {
        mirror([0,1,0]) {
            lock();
        }
    }
}

module RotatingCorners () {
    RotatingCorner();
    translate([0,width*2.25,0]) {
        mirror([0,1,0]) {
            RotatingCorner();
        }
    }
}

module MountingCorners() {
    corner();
    translate([0,width*2.25,0]) {
        mirror([0,1,0]) {
            corner();
        }
    }
}

MountingCorners();
//translate([-depth - 3*wallThickness,0,0])
////    locks();
//    RotatingCorners();