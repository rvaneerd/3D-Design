$fn = 64;

// Parameters
u_thickness = 10;       // Dikte van zijkanten en basis
u_width     = 30;       // Binnenbreedte van de U (afstand tussen zijkanten)
u_height    = 60;       // Hoogte van de zijkanten
bulge_radius = 3;        // Straal van de bollingen
bulge_height_pos = 0.81; // 0..1: relatieve positie langs de hoogte (0=onder, 1=boven)

grip_thickness = 10;    // Dikte van de greep
grip_length = 20;        // Lengte van de greep
grip_bulge_radius = 3;   // Straal bolling op de greep
grip_bulge_offset = 0.8;         // Positie bolling op greep (0=begin, 1=einde)

// Module: U-vorm met afgeronde hoeken en bollingen
module u_shape(thickness, width, height, bulge_r, bulge_pos) {
    half_width = width / 2;
    half_thickness = thickness / 2;
    corner_r = min(thickness, height) / 2;

    // Linker zijkant
    translate([-half_width - half_thickness, height / 2])
        square([thickness, height], center = true);
    translate([-half_width - half_thickness, height / 2])
        circle(r = corner_r);
    translate([-half_width - half_thickness + corner_r, height / 2 + corner_r])
        square([0, height - 2 * corner_r], center = false);

    // Rechter zijkant
    translate([half_width + half_thickness, height / 2])
        square([thickness, height], center = true);
    translate([half_width + half_thickness, height / 2])
        circle(r = corner_r);
    translate([half_width + half_thickness + corner_r, height / 2 + corner_r])
        square([0, height - 2 * corner_r], center = false);

    // Basis
    translate([0, half_thickness])
        square([width, thickness], center = true);
    translate([0, half_thickness])
        circle(r = corner_r);
    translate([corner_r, half_thickness + corner_r])
        square([width - 2 * corner_r, 0], center = false);

    // Bollingen aan binnenzijde staanders
    h_pos = thickness + bulge_r + bulge_pos * (height - 2 * bulge_r);
    translate([-half_width, h_pos]) circle(r = bulge_r);
    translate([half_width, h_pos]) circle(r = bulge_r);
}

// Module: Greep met bolling bovenop, bijna aan het einde
module grip(thickness, length, bulge_r, grip_bulge_offset) {
    corner_r = min(thickness, length) / 2;

    // Greep
    translate([u_width / 2 + u_thickness + length / 2, thickness / 2])
        square([length, thickness], center = true);
    translate([u_width / 2 + u_thickness + length / 2, thickness / 2])
        circle(r = corner_r);
    translate([u_width / 2 + u_thickness + length / 2 + corner_r, thickness / 2 + corner_r])
        square([length - 2 * corner_r, 0], center = false);

    // Bolling bovenop de greep, verschoven naar het einde
    // bulge_offset: 0 = begin, 1 = einde van de greep
    x_pos = u_width / 2 + u_thickness + length * grip_bulge_offset;
    translate([x_pos, thickness])
        circle(r = bulge_r);
}



// Aanroep modules
u_shape(u_thickness, u_width, u_height, bulge_radius, bulge_height_pos);
grip(grip_thickness, grip_length, grip_bulge_radius, grip_bulge_offset);
