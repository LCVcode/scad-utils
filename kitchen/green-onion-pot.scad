use <../scad-utils/round-poly.scad>
use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 16 : 128;

TOL = 0.25;

// Parameters
stem_diameter = inches(0.85);
tray_diameter = inches(3.3); 
tray_curvature = 13;
tray_thickness = 5.5;
cavity_height = 12;
pot_height = inches(3);
pot_thickness = 5.5;
drain_diameter = 4;
drain_curvature = 2;
drain_length = pot_thickness + cavity_height/2;

module pot_profile() {
    points = [
        [0, 0, 0],
        [tray_diameter/2, 0, tray_curvature - TOL],
        [tray_diameter/2, tray_curvature + tray_thickness/2, tray_thickness/2],
        [tray_diameter/2 - tray_thickness, tray_curvature + tray_thickness/2, tray_thickness/2 - TOL],
        [tray_diameter/2 - tray_thickness, tray_thickness, tray_curvature - tray_thickness],
        [stem_diameter/2, tray_thickness, cavity_height/2 - TOL],
        [stem_diameter/2, tray_thickness + cavity_height, cavity_height/2 - TOL],
        [tray_diameter/2, tray_thickness + cavity_height, cavity_height/2 - TOL],
        [tray_diameter/2, pot_height - pot_thickness/2, pot_thickness/2 - TOL],
        [tray_diameter/2 - pot_thickness, pot_height - pot_thickness/2, pot_thickness/2 - TOL],
        [tray_diameter/2 - pot_thickness, tray_thickness + cavity_height + pot_thickness, (tray_diameter/2 - pot_thickness) / 1.8 - TOL],
        [0, tray_thickness + cavity_height + pot_thickness, 0],
    ];
    round_poly(points);
}

module drain_hole() {
    points = [
        [0, TOL, 0],
        [drain_diameter/2 + drain_curvature, TOL, 0],
        [drain_diameter/2 + drain_curvature, 0, 0],
        [drain_diameter/2, 0, drain_curvature - TOL],
        [drain_diameter/2, -drain_length, 0],
        [0, -drain_length, 0],
    ];
    rotate_extrude()
    round_poly(points);
}

difference() {
    rotate_extrude(convexity=4)
    pot_profile();

    rotate_array(6)
    translate([0, (stem_diameter + drain_diameter)/2, cavity_height + tray_thickness + pot_thickness])
    drain_hole();
}