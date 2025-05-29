use <../scad-utils/round-poly.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 16 : 64;

// Parameters
hose_diameter = 19.5;
bracket_thickness = 3;
bracket_width = 12;
screw_diameter = 3.8;
leg_length = 18;
tolerance = 0.2;

module top_profile() {
    difference() {
    union() {
    square([hose_diameter + 2*leg_length - bracket_width, bracket_width], center=true);

    copy_mirror_x()
    translate([leg_length + (hose_diameter - bracket_width)/2, 0, 0]) circle(d=bracket_width);
    }
    copy_mirror_x()
    translate([leg_length + (hose_diameter - bracket_width)/2, 0, 0]) circle(d=screw_diameter);
    }  
}

module side_profile() {
    x1 = hose_diameter/2 + bracket_thickness;
    y1 = hose_diameter + bracket_thickness;
    r1 = hose_diameter/2 - tolerance;
    r2 = bracket_thickness - tolerance;

    copy_mirror_x()
    round_poly([
        [              0,                y1,                      0],
        [             x1,                y1, r1 + bracket_thickness],
        [             x1, bracket_thickness,                     r2],
        [x1 + leg_length, bracket_thickness,                      0],
        [x1 + leg_length,                 0,                      0],
        [hose_diameter/2,                 0, r2 + bracket_thickness],
        [hose_diameter/2,     hose_diameter,                     r1],
        [              0,     hose_diameter,                      0],
    ]);
}

module hanger_tie() {
    intersection() {
        linear_extrude(hose_diameter + bracket_thickness + tolerance)
        top_profile();

        rotate([90, 0, 0])
        linear_extrude(bracket_width + tolerance, center=true)
        side_profile();
    }
}
hanger_tie();