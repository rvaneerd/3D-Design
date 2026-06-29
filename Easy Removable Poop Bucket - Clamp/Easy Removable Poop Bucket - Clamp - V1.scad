difference() {
  // Outer Cube (Solid)
  cube([80,20,30],center = true);
  // Inner Cube (The part to be removed)
  // Scale it down and move it slightly inwards to create walls
  translate([-40, -10, -7.5]) // Position the inner cube
  cube([60, 20, 15]); // A slightly smaller 60x20x20 cube

}
translate([35,00,20 - 0.001])
  cube([10,20,20],center = true);