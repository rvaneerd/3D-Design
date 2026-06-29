// Parameters
wall_thick = 2;
box_x = 108;
box_y = 98;
box_z = 88;
hole_dia = 8;
spacing = 10;
borderHeight = 4;
borderwidth = 10;


include <BOSL2/std.scad>
// The Belfry OpenSCAD Library V2
// Source: https://github.com/revarbat/BOSL2
// Documentation: https://github.com/revarbat/BOSL2/wiki
// BOSL2 is licensed under BSD 2-Clause License
//    https://github.com/revarbat/BOSL2/blob/master/LICENSE

////////////////////////////////////////////////////////////////////
// cell: takes three parameters and returns a single hexagonal cell
//
//   SW_hole: scalar value that specifies the width across the flats
//     of the interior hexagon
//   height: scalar value that specifies the height/depth of the 
//     cell (i.e. distance from from front to back
//   wall: scalar vale that specifies the thickness of the wall 
//     surrounding the interior hex (hole). e.g. if SW_hole is 8 
//     and wall is 2 then the total width across the flats of the
//     cell is 8 + 2(2) = 12.
////////////////////////////////////////////////////////////////////
module cell(SW_hole, height, wall) {
  tol = 0.001; // used to clean up difference artifacts
  difference() {
    cyl(d=SW_hole+2*wall,h=height,$fn=6,circum=true);
    cyl(d=SW_hole,h=height+tol,$fn=6,circum=true);
  }
}

////////////////////////////////////////////////////////////////////
// grid: takes three parameters and returns the initial grid of 
//    hexagons
//
//    size: 3-vector (x,y,z) that specifies the  size of the cube 
//      that contains the hex grid
//    cell_hole: scalar value specifying width across flats of the 
//      interior hexagon (hole)
//    cell_wall: scalar value that specifies wall thickness of the
//      hexagon
////////////////////////////////////////////////////////////////////
module grid(size,cell_hole,cell_wall) {
  dx=cell_hole*sqrt(3)+cell_wall*sqrt(3);
  dy=cell_hole+cell_wall;

  ycopies(spacing=dy,l=size[1])    
    xcopies(spacing=dx,l=size[0]) {
      cell(SW_hole=cell_hole,
           height=size[2],
           wall=cell_wall);
      right(dx/2)fwd(dy/2)
      cell(SW_hole=cell_hole,
          height=size[2],
          wall=cell_wall);
    }
 }

////////////////////////////////////////////////////////////////////
// mask: creates a mask that is used by the module create_grid()
//   The mask is used to remove extra cells that are outside the 
//   cube that holds the final grid
////////////////////////////////////////////////////////////////////
module mask(size) {
  difference() {
    cuboid(size=2*size);
    cuboid(size=size);
  }
}

////////////////////////////////////////////////////////////////////
// create_grid: creates a rectangular grid of hexagons with an
//   independently configurable frame wall thickness.
//
//   size: 3-vector (x,y,z) that specifies the length, width, and
//     depth of the final grid
//   SW: scalar value that specifies the width across the flats of
//     the interior hexagon (the hole)
//   cell_wall: scalar value that specifies the wall thickness of
//     each individual hexagon cell
//   frame_wall: scalar value that specifies the thickness of the
//     surrounding rectangular frame
////////////////////////////////////////////////////////////////////
module create_grid(size, SW, cell_wall, frame_wall) {
  union() {
    difference() {
      cuboid(size=size);
      cuboid(size=[size[0]-2*frame_wall,
                  size[1]-2*frame_wall,
                  size[2]+frame_wall]);
    }
  }

  difference() {
    grid(size=size, cell_hole=SW, cell_wall=cell_wall);
    mask(size);
  }
}


////////////////////////////////////////////////////////////////////
// Examples
//
// Rectangular grid with separate cell and frame wall widths:
//   create_grid(size=[100,150,10], SW=20, cell_wall=2, frame_wall=4);
//
// Circular grid:
//   create_circular_grid(diameter=120, height=10, SW=20,
//                        cell_wall=2, frame_wall=4);
//
// Circular grid with smoother curves ($fn=128):
//   create_circular_grid(diameter=120, height=10, SW=20,
//                        cell_wall=2, frame_wall=4, $fn=128);
////////////////////////////////////////////////////////////////////
difference() {
    union() {
        translate([0,box_y/2,0])
            rotate([90,0,0])
                create_grid(size=[box_x-4,box_z,wall_thick], SW=10, cell_wall=2, frame_wall=wall_thick);
        
        translate([0,-box_y/2,0])
            rotate([90,0,0])
                create_grid(size=[box_x-4,box_z,wall_thick], SW=10, cell_wall=2, frame_wall=wall_thick);
        
        translate([box_x/2,0,0])
            rotate([0,90,0])
                create_grid(size=[box_z,box_y-4,wall_thick], SW=10, cell_wall=2, frame_wall=wall_thick);
        
        translate([-box_x/2,0,0])
            rotate([0,90,0])
                create_grid(size=[box_z,box_y-4,wall_thick], SW=10, cell_wall=2, frame_wall=wall_thick);
        
        translate([(box_x/2-wall_thick+0.5), (box_y/2-wall_thick+0.5),0])
            cylinder(h = box_z, d = 5, center = true, $fn=50);
        translate([-(box_x/2-wall_thick+0.5), (box_y/2-wall_thick+0.5),0])
            cylinder(h = box_z, d = 5, center = true, $fn=50);
        translate([-(box_x/2-wall_thick+0.5), -(box_y/2-wall_thick+0.5),0])
            cylinder(h = box_z, d = 5, center = true, $fn=50);
        translate([(box_x/2-wall_thick+0.5), -(box_y/2-wall_thick+0.5),0])
            cylinder(h = box_z, d = 5, center = true, $fn=50);
                    
        translate([0,0,box_z/2+borderHeight/2]) {
            cube([box_x+borderwidth*2,box_y+borderwidth*2,borderHeight], center = true);
                    }
    }
    translate([0,0,0]) {
        cube([box_x-wall_thick,box_y-wall_thick,box_z*2], center = true);
    }
}
        translate([0,0,-(box_z/2-wall_thick)])
            cube([box_x, box_y, wall_thick], center = true);
