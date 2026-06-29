apparaatHoogte = 14.6;
apparaatDiepte = 48.6;
apparaatBreedte = 86.5;
wandDikte = 3;
openingHoogte = 10;
openingBreedte = 65;
bevestigingBreedte = 40;
bevestigingDikte = 3;
schroefGatDikte = 4;

module kastVorm(hoogte, diepte, breedte) {
    translate([0,-(breedte-hoogte/2)/2,0])
        rotate([0,90,0])
            cylinder(h=diepte,d=hoogte, center=true);
    translate([-diepte/2,-(breedte-hoogte/2)/2,-hoogte/2])
        cube([diepte,breedte-hoogte/2,hoogte]);
    translate([0,(breedte-hoogte/2)/2,0])
        rotate([0,90,0])
            cylinder(h=diepte,d=hoogte, center=true);
}

module schroefgat(schroefmaat, schroeflengte) {
    cylinder(h = schroeflengte, d1 = schroefmaat*2, d2 = schroefmaat);
}

module bevestiging(hoogte, breedte, diepte, dikte, schroefmaat) {
    color("red",0.25)
    difference() {
        cube([hoogte, breedte, dikte], center=true);
        translate([0,schroefmaat*3-breedte/2,-dikte/2])
            schroefgat(schroefmaat, dikte);
    }
}

module opvulling() {
//    color("green",0.25)
    cube([apparaatDiepte+wandDikte, wandDikte, apparaatHoogte/2+wandDikte], center=true);
}
module montageKast() {
    union() {
        translate([0,apparaatBreedte/2+wandDikte*2,bevestigingDikte])
            opvulling();
        difference() {
            union() {
                translate([0,-1*((apparaatBreedte+apparaatHoogte)/2)-schroefGatDikte/1,apparaatHoogte/2])
                    bevestiging(apparaatDiepte+wandDikte,bevestigingBreedte,wandDikte, bevestigingDikte, schroefGatDikte);  
                difference() {
                    kastVorm(apparaatHoogte+wandDikte, apparaatDiepte+wandDikte, apparaatBreedte+2*wandDikte);
                    translate([0,0,wandDikte/2])
                        kastVorm(openingHoogte, apparaatDiepte+wandDikte, openingBreedte);
                }
                rotate([0,0,180])
                    translate([0,-1*((apparaatBreedte+apparaatHoogte)/2)-schroefGatDikte/2,apparaatHoogte/2])
                        bevestiging(apparaatDiepte+wandDikte,bevestigingBreedte,wandDikte, bevestigingDikte, schroefGatDikte);  
            }
            color("blue", 0.25)
            translate([wandDikte, 0, wandDikte/2])
                kastVorm(apparaatHoogte, apparaatDiepte+wandDikte, apparaatBreedte);
        }
        translate([0,-1*(apparaatBreedte/2+wandDikte*2),bevestigingDikte])
            opvulling();
    }
}

montageKast();
//bevestiging(apparaatDiepte,bevestigingBreedte,wandDikte, bevestigingDikte, schroefGatDikte);
//schroefgat(schroefGatDikte, bevestigingDikte);