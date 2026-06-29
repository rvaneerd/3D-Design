use <threadlib/threadlib.scad>;
include <threadlib/THREAD_TABLE.scad>;
include <BOSL2/std.scad>;

base        = 25;
corner      = 2;
hook_width  = 3.5;
hook_length = 25;
resolution  = 64;    // detail voor cirkels

$fn = resolution;


difference() {
    cuboid([5, base, base], rounding=corner, anchor=BOTTOM);
    // binnendraad uitsnijden
    translate([-5,0,base/2])
        rotate([0,90,0])
            tap("M8", turns = 10);  // turns ~ effectieve oorhoogte / spoed
}
translate([0,0,1+hook_width/2]) {
    rotate([0,45,0]) {
        cylinder(h=hook_length, d1=hook_width, d2=hook_width, center=false);
        translate([00,0,hook_length])
            sphere(d = hook_width);
    }
}