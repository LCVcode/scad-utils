use <../scad-utils/modifiers.scad>
use <../scad-utils/shapes.scad>

$fn = $preview ? 16 : 128;

// Parameters
contact_surface_curvature = 25;
lip_curvature = 7;
separation_from_wall = 8;
profile_width = 7;
profile_height = 15;

// Real-world measurements
limb_width = 55;

module profile() {
    h = max(profile_height, profile_width);
    w = min(profile_height, profile_width);

    copy_mirror_x()
    translate([(h-w)/2, 0, 0])
    circle(d=w);

    square([h-w, w], center=true);
}

module recurve_bow_wall_mount() {
    // Contact surface, extending back to wall
    rotate([0, 90, 0])
    linear_extrude(separation_from_wall + limb_width + lip_curvature + profile_width/2)
    profile();

    // Tip upward curve
    translate([separation_from_wall + limb_width, 0, lip_curvature + profile_height/2]) rotate([-90, 0 , 0])
    difference() {
    linear_extrude(profile_width, center=true) square(lip_curvature + profile_width/2);
    rotate_extrude(angle=90) difference() {
        translate([0, -profile_width/2, 0]) square([lip_curvature + profile_width/2, profile_width]);
        translate([profile_height/2 + lip_curvature, 0, 0]) profile();
    }}

    // Hemisphere lip tip
    translate([separation_from_wall + limb_width + lip_curvature + profile_width/2, 0, lip_curvature + profile_height/2])
    rotate([90, 0, 0]) hemisphere(d=profile_width);

    // Outer lip surface
    translate([separation_from_wall + limb_width + lip_curvature + profile_width/2, 0, -(profile_height - profile_width) / 2])
    cylinder(h=profile_height - profile_width/2 + lip_curvature, d=profile_width);

    // Bottom lip corner
    translate([separation_from_wall + limb_width + lip_curvature + profile_width/2, 0, -(profile_height - profile_width) / 2])
    sphere(d=profile_width);
}
recurve_bow_wall_mount();