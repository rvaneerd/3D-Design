// Bolle kap voor parasol-/luifelmechanisme
// Gebaseerd op je foto + 30 mm vierkant + 71 mm ronding
// Pas de variabelen hieronder aan als je wilt!

$fn = 120;  // hoge resolutie voor mooie ronde vormen

// === PARAMETERS (verander deze!) ===
outer_d = 125;      // buitendiameter kap (71.5 inner + 4 mm wand)
inner_d = 71.5;      // binnendiameter = iets ruimer dan 71 mm (past soepel over ronding)
plug_side = 29.8;    // vierkant plug = iets kleiner dan 30 mm (perfecte pasvorm)
skirt_h = 15;        // hoogte van de cilinder-rand die over de ronding glijdt
dome_h = 25;         // hoogte van de bolle kap (20-30 mm ziet er mooi uit)
plug_h = 40;         // totale lengte van de vierkante pen (past diep genoeg)

// Schroefgaten
screw_dia         = 4.0;
countersink_dia   = 7.0;
countersink_depth = 2.5;
screw_height      = skirt_h * 0.55;  // ~8.25 mm hoogte

// Berekening voor mooie bolle vorm
outer_r = outer_d / 2;
r_sphere = (outer_r*outer_r + dome_h*dome_h) / (2 * dome_h);

translate([0, 0, 4]) {
// === HET MODEL ===
union() {
    // 1. Buitenste vorm (cilinder + bolle kap)
    difference() {
        union() {
            // Cilindrische rand
            cylinder(h = skirt_h, d = outer_d);
            
            // Bolle kap erop
            translate([0, 0, skirt_h]) {
                intersection() {
                    translate([0, 0, -(r_sphere - dome_h)]) 
                        sphere(r = r_sphere);
                    cylinder(h = dome_h + 2, r = outer_r + 1);
                }
            }
        }
        
        // Holte voor de 71 mm ronding (annulaire ruimte)
        cylinder(h = skirt_h + 0.2, d = inner_d);

        // Holte voor de grijze ronding
        translate([0, 0, -0.1])
            cylinder(h = skirt_h + 0.2, d = inner_d);

        // Schroefgat links (-X)
        translate([-outer_d/2 + 5, 0, screw_height]) {
            rotate([0, 90, 0])
                cylinder(h = outer_d, d = screw_dia, $fn=32);
        }
        translate([-outer_d/2 + countersink_depth + 0.5, 0, screw_height]) {
            rotate([0, 90, 0])
                cylinder(h = 10, d = countersink_dia, $fn=40);
        }

        // Schroefgat rechts (+X)
        translate([outer_d/2 - 5, 0, screw_height]) {
            rotate([0, -90, 0])
                cylinder(h = outer_d, d = screw_dia, $fn=32);
        }
        translate([outer_d/2 - countersink_depth - 0.5, 0, screw_height]) {
            rotate([0, -90, 0])
                cylinder(h = 10, d = countersink_dia, $fn=40);
        }
    }

    // 2. Vierkante pen (steekt uit onder de holte)
    translate([0, 0, skirt_h ]) {
        // cube([plug_side, plug_side, plug_h], center = true);
        // === TIP: nog mooier maken (optioneel) ===
        // Wil je afgeronde hoeken op de plug of een lichte chamfer?
        // Vervang de cube-regel hierboven door:
        minkowski() {
            cube([plug_side-2, plug_side-2, plug_h-2], center=true);
            cylinder(h=2, r=1, $fn=20);
        }
    }
}
}

