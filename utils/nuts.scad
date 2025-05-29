use <../scad-utils/shapes.scad>

$fn=30;

module nut_8_32() {
    linear_extrude(3.2)
    hexagon(height=8.5);
}

module nut_8_32_cavity() {
    minkowski() {
        nut_8_32();
        sphere(r=0.15);
    }
}

module nut_8_32_slot(length) {
    hull() {
        nut_8_32_cavity();
        translate([length, 0, 0])
        nut_8_32_cavity();
    }
}