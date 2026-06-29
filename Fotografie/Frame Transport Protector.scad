// Protective corner to transport picture / photo frames
// Requires 4 which can be coupled by a rope.
// Configurable for size, thinkness of the frames and number of frames to be transported.

// === CONFIG ===
// The number of frames that should be transported and need protection
frames = 7;                     
// The thickness of the individal frames
frame_thickness = 18.5;           
// The size of the protector along the X-axis
protective_edge_length = 75;
// The size of the protector along the Y-axis
protective_edge_depth = 75;
// The outside thickness of the protective edges
protective_edge_thickness = 2;
// The thickness of each layer's separation
bottom_thickness = 1;

// The thickness of the rope used to keep all edges together (and carry the set)
rope_thickness = 6;
// Indicate whether the rope carrier is also required on the Y-Axis [true, false]. No (= false) is easier for printing (supports) and preparing for transport
rope_carrier_Y_axis = false;    // [true,false]

/* [Hidden] */ // Everything below this is hidden from the customizer
frame=0;
//tolerance = 0.3;


// Driehoekige bodem
module triangle_base() {
    linear_extrude(height = bottom_thickness)
        polygon([
            [0, 0],                    // Hoekpunt
            [protective_edge_length, 0],          // X-as einde (ligger)
            [0, protective_edge_depth]           // Y-as einde (rechte zijde)
        ]);
}

// Wand langs X-as (ligger)
module wall_x() {
    translate([0, 0, (frame) * (frame_thickness + protective_edge_thickness)]) {
        cube([protective_edge_length, protective_edge_thickness, (frame_thickness + bottom_thickness)]);
    }
}

// Wand langs Y-as (verticale zijde)
module wall_y() {
    translate([0, 0, (frame) * (frame_thickness + protective_edge_thickness)])
        cube([protective_edge_thickness, protective_edge_depth, (frame_thickness + bottom_thickness)]);
}

module protectiveEdge() {
    difference() {
        union() {
            triangle_base();
            wall_x();
            wall_y();
        }
        
        // Optioneel handvat
        translate([protective_edge_length/4, protective_edge_depth/4, bottom_thickness-2])
            rotate([0,0,90])
                cylinder(d=15, h=protective_edge_thickness+2, center=true);
    }
}

// top-cover triangle
module topCoverTriangle () {
    translate([0,0,frames*(frame_thickness + bottom_thickness)]) {
        union() {
            difference() {
                triangle_base();
                translate([protective_edge_length/4, protective_edge_depth/4, 0])
                    rotate([0,0,90])
                        cylinder(d=15, h=protective_edge_thickness+2, center=true);
            }
            cube([protective_edge_length, protective_edge_thickness, bottom_thickness]);
            cube([protective_edge_thickness, protective_edge_depth, bottom_thickness]);

        }
    }
}

// Carrier Rope Module
module carrierRopeCylinder() {
        difference() {
            cylinder(h = protective_edge_length*2/3, d = rope_thickness + 2* protective_edge_thickness, center=true);
            cylinder(h = protective_edge_length*2/3, d = rope_thickness + 1, center=true);
        }
}

// Carrier Rope Module along X-axis
module carrierRopeCylinderX() {
    rotate([0, 90,0]) 
        carrierRopeCylinder();
}

// Carrier Rope Module along Y-axis
module carrierRopeCylinderY() {
    rotate([90, 0,0]) 
        carrierRopeCylinder();
}

// Carrier Rope Module (across both axis)
module fullRopeCarrier () {
    rope_height = (frames*(frame_thickness+protective_edge_thickness)+protective_edge_thickness)/2;
    // Rope Carrier Cylinder X-Axis
    translate([protective_edge_length / 2, -rope_thickness+protective_edge_thickness,rope_height])
        carrierRopeCylinderX();
        
    // Rope Carrier Cylinder Y-Axis
    if (rope_carrier_Y_axis) {
        translate([-rope_thickness+protective_edge_thickness,protective_edge_depth / 2, rope_height])
            carrierRopeCylinderY();
    }
}

// Protector
module protector() {
    for (frame = [0: frames-1]){
        translate([0,0,frame*(frame_thickness + bottom_thickness)])
            protectiveEdge();
    }
    topCoverTriangle ();
    fullRopeCarrier ();
}

// Rotate the protector to have one side on the print plate.
// Reduces the amount of supports required.
rotate([-90,-90,0])
    protector();
