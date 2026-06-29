//////////////////////////////////////////////////////
// Parametrische U-klem met zij-grip
//////////////////////////////////////////////////////

// Algemene resolutie
$fn = 64;

// Hoofdparameters
thickness   = 4;    // Dikte materiaal
inner_width = 20;   // Binnenbreedte tussen poten (X-richting)
inner_height= 25;   // Binnenhoogte U (Y-richting)
depth       = 15;   // Lengte in Z-richting (extrusie)

round_r     = 2;    // Algemene afrondingsradius randen
bulge_r     = 1.5;  // Bolling (binnenkant & grip)

grip_len    = 10;   // Lengte grip die uitsteekt (X-richting)
grip_height = 6;    // Dikte/hoogte grip (Y-richting)

// Afgeleide maten
outer_width  = inner_width  + 2*thickness;
outer_height = inner_height + thickness;     // bovenzijde is dikte
total_height = outer_height + grip_height;   // incl. grip naar beneden

//////////////////////////////////////////////////////
// Hulpmodule: afgeronde rechthoek (2D)
//////////////////////////////////////////////////////
module rounded_rect(w, h, r) {
    r2 = min(r, min(w, h)/2);
    minkowski() {
        square([w - 2*r2, h - 2*r2], center = true);
        circle(r = r2);
    }
}

//////////////////////////////////////////////////////
// Hulpmodule: kleine bolling (2D) aan rand
//////////////////////////////////////////////////////
module bulge(r) {
    circle(r = r);
}

//////////////////////////////////////////////////////
// 2D-profiel van de U + grip
//////////////////////////////////////////////////////
module clamp_profile_2d() {
    difference() {
        union() {
            // Buitencontour U (rechthoek met afgeronde hoeken)
            translate([0, (grip_height)/2])
                rounded_rect(outer_width, total_height, round_r);

            // Grip die alleen aan één zijde uitsteekt (bijv. rechts)
            translate([ (outer_width/2) + grip_len/2, -grip_height/2 ])
                rounded_rect(grip_len, grip_height, round_r);
        }

        // Binnenruimte U uitsnijden
        translate([0, (thickness + inner_height/2)])
            rounded_rect(inner_width, inner_height, round_r * 0.8);
    }

    // Bollingen aan binnenzijde poten (onder)
    // Links en rechts onderin de binnenkant
    translate([inner_width/2, thickness + bulge_r])
        bulge(bulge_r);
    translate([-inner_width/2, thickness + bulge_r])
        bulge(bulge_r);

    // Bolling op de grip (bovenop grip)
    translate([ (outer_width/2) + grip_len/2, 0 ])
        bulge(bulge_r);
}

//////////////////////////////////////////////////////
// 3D model: profiel extruderen
//////////////////////////////////////////////////////
module u_clamp() {
    linear_extrude(height = depth)
        clamp_profile_2d();
}

//////////////////////////////////////////////////////
// Aanroep
//////////////////////////////////////////////////////
u_clamp();
