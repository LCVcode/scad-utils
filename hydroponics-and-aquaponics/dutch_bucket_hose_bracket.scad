use <../scad-utils/scale.scad>
use <../scad-utils/round-poly.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 16 : 64;

// Bucket parameters
bucket_diameter = 302;
bucket_thickness = 9;

// Hose parameters
hose_diameter = 7.4;

// Bracket parameters
bracket_height = inches(2.5);
bracket_width = inches(1.5);
bracket_thickness = inches(1);
hose_height_above_bucket = 5;
support_thickness = 5.5;

module bucket_lip(diameter, thickness) {
    color("DarkOrange")
    translate([0, (diameter-thickness)/2, 0])
    rotate([180, 0, 0]) linear_extrude(inches(24))
    difference() {
        circle(d=diameter);
        circle(d=diameter-2*thickness);
    }
}

/* 
The front profile of the clip (in the direction of the hose)
Arguments:
    bh: bracket height (mm)
    bw: bracket width (mm)
    hd: diameter of hose (mm)
    hy: height of hose above bucket lip (mm)
    st: support thickness (mm)
*/
module bracket_front_profile(bh, bw, hd, hy, st) {
    difference() {
        copy_mirror_x()
        round_poly([
            [        0,                0,                      0],
            [        0,               bh,                      0],
            [hd/2 + st,               bh,      st + hd/2 - 0.001],
            [hd/2 + st,     bh - hd - st,                   hd/2],
            [     bw/2,     bh - hd - st, bw/2 - hd - st - 0.001],
            [     bw/2, (bh - hd - st)/2,                   2*st],
            [     bw/6,                0,           bw/6 - 0.001],
        ]);

        translate([0, bh - st - hd/2, 0]) circle(d=hd);
    }
}

/*
The top profile of the clip
Arguments:
    bw: bracket width (mm)
    bt: bracket thickness (mm)
    r:  curvature (mm)
*/
module bracket_top_profile(bw, bt, r) {
    round_poly([
        [-bw/2,  bt/2, r],
        [ bw/2,  bt/2, r],
        [ bw/2, -bt/2, r],
        [-bw/2, -bt/2, r],
    ]);
}

module bracket() {
    translate([0, 0, -bracket_height/2])
    render(convexity=4)
    difference() {
        intersection() {
            // Top profile extrusion
            linear_extrude(bracket_height)
            bracket_top_profile(bracket_width, bracket_thickness, 10);

            // Front profile extrusion
            rotate([90, 0, 0])
            linear_extrude(bracket_thickness, center=true)
            bracket_front_profile(bracket_height, bracket_width, hose_diameter, hose_height_above_bucket, support_thickness);
        }

        // Bucket slot
        translate([0, -bucket_thickness/4, bracket_height - hose_diameter - support_thickness - hose_height_above_bucket])
        bucket_lip(bucket_diameter, bucket_thickness);
    }
}
bracket();