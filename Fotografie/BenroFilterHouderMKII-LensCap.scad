BenroLensAdapterDiameter = 94;
BenroLensAdapterThickness = 4.1;
lensCapThickness = 2;

module lensAdapter() {
cylinder(h = BenroLensAdapterThickness, d = BenroLensAdapterDiameter, center = true);
}

module lensCap() {
    difference () {
        cylinder(h = BenroLensAdapterThickness+lensCapThickness, d = BenroLensAdapterDiameter+2*lensCapThickness, center = true);
        translate([0,0,lensCapThickness])
            lensAdapter();
    }
}

//lensAdapter();
lensCap();