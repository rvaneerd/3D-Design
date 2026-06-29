$fn = 64;

// all units in mm (millimeters)
// Parameters
u_thickness = 3;
u_width = 9;
u_height = 11.5;

grip_length = 10;

depth = 5;

round_r = 1.5;

module u_left_side() {
    // Circle to start rounded outer corner
    translate([round_r, round_r])
        circle(r = round_r);

    // Leftside (until the rounded corner on the outside)
    translate([round_r, 0])
        square([u_height, u_thickness]);
    // Leftside (half round_r corner on the outside + fill to inside)
    translate([round_r + u_height, round_r]) {
        circle(r = round_r);
        square([round_r, u_thickness - round_r]);
    }
    // Little grip for resistance on the left inside
    translate([u_height + 1.5 * round_r, u_thickness]) {
        circle(r = round_r / 2);
    }
}

module u_base() {
    // Just the base of the clamp (in between the left and right side)
    translate([0, round_r])
        square([u_thickness, u_width - round_r]);
}

module u_right_side() {
    // Rightside (No rounded corner because of the grip)
    translate([round_r, u_width - u_thickness])
        square([u_height, u_thickness]);
    // Rightside (half round_r corner on the outside)
    translate([u_height+round_r, u_width - round_r]) {
        circle(r = round_r);
    }
    // Rightside (fill to half round_r corner on the outside)
    translate([u_height + round_r, u_width - u_thickness]) {
        square([round_r, u_thickness - round_r]);
    }
    // Little grip for resistance on the right inside
    translate([u_height + round_r * 1.5, u_width - u_thickness]) {
        circle(r = round_r / 2);
    }
}

module grip() {
    // Grip (half rounded corner on the outside at the beginning of the grp)
    translate([0, u_width])
        square([u_thickness, grip_length - round_r]);
    // Afronding (grip rechteronderhoek)
    translate([round_r, u_width + grip_length - round_r]) {
        circle(r = round_r);
    }
    translate([round_r, u_width + grip_length - round_r]) {
        square([u_thickness - round_r, round_r]);
    }
    // Grip weerstand
    translate([u_thickness, u_width + grip_length - round_r * 0.5]) {
        circle(r = round_r / 2);
    }
}

module clamp_profile_2D() {
    u_left_side();
    u_base();
    u_right_side();
    grip();
}

module clamp_3D() {
    linear_extrude(height = depth)
        clamp_profile_2D();
}

clamp_3D();