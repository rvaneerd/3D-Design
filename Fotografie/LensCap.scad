$fn=96;

lensDiameter = 95;
lensFrontThickness = 4.1;
lensCapThickness = 1.5;
capLockThickness = 0.5;
capLockDiameter = lensDiameter-capLockThickness*2;

module lensAdapter() {
cylinder(h = lensFrontThickness + lensCapThickness + capLockThickness, d = lensDiameter, center = true);
}

module lockingRing() {
    // Create the lockingRing
    translate([0,0,lensFrontThickness - lensCapThickness]) {
        color("red", 0.5)
        rotate_extrude() {
            translate([capLockDiameter/2, 0, 0])
            circle(r = capLockThickness);
        }
    }
}

module lensCap() {
    union () {
        difference () {
            color("blue", 0.5)
                cylinder(h = lensFrontThickness+lensCapThickness, d = lensDiameter+2*lensCapThickness, center = true);
            color("green", 0.5)
                translate([0,0,lensCapThickness])
                    lensAdapter();
        }
        lockingRing();
    }
}

//lockingRing();
//lensAdapter();
lensCap();