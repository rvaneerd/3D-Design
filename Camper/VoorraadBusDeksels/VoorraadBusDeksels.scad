include <./Dop.scad>

/* [BusMaat] */
busMaat = "Kleinst";  // [Groot, Middel, Klein, Kleinst]

busMaten = [
    ["Groot",   85.75,  144.5,  46.5],
    ["Middel",  75.00,  131.0,  39.5],
    ["Klein",   57.25,  105.0,  25.0],
    ["Kleinst", 49.30,   93.0,  20.5]
];

gekozenBusMaat = [
    for (maat = busMaten)
        if (maat[0] == busMaat)
            maat
][0];

busBreedte              = gekozenBusMaat[1];
busLengte               = gekozenBusMaat[2];
busOpeningVerschuiving  = gekozenBusMaat[3];

echo(str("busBreedte = ", busBreedte));
echo(str("busLengte = ", busLengte));
// ====== PARAMETERS ======
// Afmetingen van de binnenkant (past op de bus)
inner_radius = busBreedte/2;        // radius van elke cilinder-lobe [mm]
inner_separation = busLengte-inner_radius*2;    // afstand tussen de middelpunten van de twee cilinders [mm]
inner_height = 10;        // hoogte van het deksel (diepte van de bus) [mm]

// Wanddikte en buitenkant
wall_thickness = 2;       // dikte van de wand [mm]
outer_radius = inner_radius + wall_thickness;
outer_separation = inner_separation; // zelfde scheiding, alleen radius groter

// Optionele bovenrand (lip/rib)
add_rim = true;
rim_height = 5;           // hoogte van de rand boven het deksel [mm]
rim_thickness = 1.5;      // extra dikte van de rand naar buiten toe [mm]

// Resolutie
$fn = 100;

// ====== HULPMODULE: tweelobbige cilinder ======
module two_lobe_cylinder(radius, separation, height) {
    // Twee cilinders + een verbindende balk (hull zorgt voor gladde overgang)
	hull() {
        translate([-separation/2, 0, 0])
            cylinder(r = radius, h = height + wall_thickness/2, center = false);
        translate([separation/2, 0, 0])
            cylinder(r = radius, h = height + wall_thickness/2, center = false);
    }
}

module deksel() {
// ====== BASIS DEKSEL (holle tweelobbige vorm) ======
difference() {
    // Buitenmantel
    color("blue",0.5)
    two_lobe_cylinder(outer_radius, outer_separation, inner_height);

    // Binnenkant uitsparen (zodat het over de bus past)
    color("red",0.5)
//    translate([0, 0, 0.1]) // iets omhoog om z-fighting te voorkomen
        two_lobe_cylinder(inner_radius, inner_separation, inner_height + 0.2);
}
}


module rim() {
// ====== OPTIONELE RAND / LIP ======
if (add_rim) {
    // Maak een grotere tweelobbige ring als rand bovenop
    difference() {
        // Buitenrand
        hull() {
            translate([-outer_separation/2, 0, inner_height-wall_thickness])
                cylinder(r = outer_radius + rim_thickness, h = rim_height + wall_thickness, center = false);
            translate([outer_separation/2, 0, inner_height-wall_thickness])
                cylinder(r = outer_radius + rim_thickness, h = rim_height + wall_thickness, center = false);
        }

        // Binnenrand uitsparen (zodat het een ring blijft)
        translate([0, 0, inner_height + wall_thickness/2])
            two_lobe_cylinder(outer_radius, outer_separation, rim_height + wall_thickness);
    }
}
}

//module kleineBus() {
difference() {
	union() {
		deksel();
		rim();
		translate([busOpeningVerschuiving,0,9.5]) {
			body();
//			main();
		}
	}
	translate([busOpeningVerschuiving,0,0])
		color("green", 0.5)
			cylinder(h = 100, r= inner_min_dia / 2, center = true);
    /* Verwijdering bovenzijde voor test-doeleinden */
    // translate([-100,-100,8]) cube([200, 200, 200], center=false);
}
translate([0,(busBreedte + inner_min_dia)/1.5 ,0])
	lid();
