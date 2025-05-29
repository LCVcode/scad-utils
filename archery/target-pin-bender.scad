use <../scad-utils/round-poly.scad>

$fn = $preview ? 16 : 128;

// Real-world measurements
pin_length = 50;
pin_diameter = 2.1;

// Parameters
tolerance = 0.75;
bend_height = 30;
wall_thickness = 6;
handle_length = 20;

module bottom_bender() {
    // Local variables
    x1 = pin_diameter/2 + tolerance;
    y1 = handle_length;
    x2 = x1 + wall_thickness;
    y2 = handle_length + bend_height + pin_diameter + wall_thickness;
    r1 = (pin_diameter - tolerance)/2;
    r2 = (wall_thickness - tolerance)/2;

    rotate_extrude()
    round_poly([
        [ 0,  0,  0],
        [ 0, y1,  0],
        [x1, y1, r1],
        [x1, y2, r2],
        [x2, y2, r2],
        [x2,  0, r2],
    ]);
}

module top_bender() {
        // Local variables
    x1 = pin_diameter/2 + tolerance;
    y  = handle_length + bend_height + pin_diameter + wall_thickness;
    x2 = x1 + wall_thickness;
    r  = (wall_thickness - tolerance)/2;

    rotate_extrude()
    round_poly([
        [x1, 0, r],
        [x1, y, r],
        [x2, y, r],
        [x2, 0, r],
    ]);
}

module pin_bender() {
    bottom_bender();

    !translate([0, 0, bend_height + handle_length + pin_diameter + wall_thickness])
    top_bender();
}
pin_bender();