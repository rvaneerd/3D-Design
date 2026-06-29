// Parameters
wall_thick = 2;
box_x = 100;
box_y = 50;
box_z = 50;
hole_dia = 8;
spacing = 10;

module hex_hole() {
    rotate([0, 0, 30])
    circle(d=hole_dia, $fn=6); // $fn=6 makes a hexagon
}

module patterned_side(wallLength, wallThinkness, wallHeight) {
    difference() {
        // The Solid Side
        cube([wallLength, wallThinkness, wallHeight]);
        
        // Subtract holes
        for (x = [spacing : spacing : box_x - spacing]) {
//            echo("x=",x);
            for (z = [spacing : spacing : box_z - spacing]) {
//                echo("z=",z);
// Perforatie langs de X-as
                translate([x, -1, z])
                    rotate([0, 90, 90])
                        linear_extrude(wall_thick + 10)
                            hex_hole();
//// Perforatie langs de Y-as
//                translate([-1, x, z])
//                    rotate([90, 0, 90])
//                        linear_extrude(wall_thick + 10)
//                            hex_hole();
            }
        }
    }
}

// Position the side
patterned_side(box_x, wall_thick, box_z);
translate([0,box_y,0])
    rotate([90,0,0])
        patterned_side(wall_thick, box_y, box_z);
translate([0,box_y-wall_thick,0])
    patterned_side(box_x, wall_thick, box_z);
translate([box_x-wall_thick,box_y,0])
    rotate([90,0,0])
        patterned_side(wall_thick, box_y, box_z);
