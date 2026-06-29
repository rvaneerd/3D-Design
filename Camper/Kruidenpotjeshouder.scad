 $fn = $preview ? 48 : 96;
 
 side = 2;
 overlap = 1;
 cylinderWidth = 18.5;
 storageCubeWidth = cylinderWidth + 2* side;
 storageCubeHeight = 25;
 storageCubeBottom = 15;
 
 rows = 5;
 columns = 2;
 
 module rounded_cube(d,r) {
    hull() for(p = [[r,r,r], [r,r,d[2]-r], [r,d[1]-r,r], [r,d[1]-r,d[2]-r],
                  [d[0]-r,r,r], [d[0]-r,r,d[2]-r], [d[0]-r,d[1]-r,r], [d[0]-r,d[1]-r,d[2]-r]])
        translate(p) sphere(r);
}

 
module storageCube() {
    difference() {
        intersection() {  
            translate([-storageCubeWidth/2,-storageCubeWidth/2,0]) {
                rounded_cube([storageCubeWidth,storageCubeWidth,storageCubeHeight], 1);
            }
        }
        translate([0,0,storageCubeBottom]) {
            cylinder(h = storageCubeHeight,d = cylinderWidth,center = true);
        }
    }
}

for ( column  =  [0 : columns-1] ){
    for ( row  =  [0 : rows-1] ){
        storageCube();
        translate([row*(storageCubeWidth-overlap),column*(storageCubeWidth-overlap),0]) storageCube();
    }
}