/*
Designs for the built-in shelving units to be installed in the living room.

Authon: Connor Chamberlain
Date:   2024 July 7
*/

use <../scad-utils/scale.scad>
use <../scad-utils/lumber.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 16 : 64;

// ----- Fixed Values -----
CABINET_WIDTH = inches(36);
CABINET_DEPTH = inches(12);
CABINET_HEIGHT = inches(30);
CEILING_HEIGHT = feet(9);

// ----- Derrived Values -----
SHELF_THICKNESS = inches(1.5) + 2*inches(0.5);
COUNTERTOP_HEIGHT = CABINET_HEIGHT + inches(5.5) + inches(0.5);
CLEARANCE_ABOVE_COUNTERTOP = CEILING_HEIGHT - (COUNTERTOP_HEIGHT + inches(1.5));

// Helper function to report required lumber components
module report(count, dim1, dim2, dim3) {echo("MATERIAL REPORT: Quantity:", count, "Dimensions: ", dim1, dim2, dim3);}

// The third-party pre-made cabinets
module cabinet() {
    color("tan")
    translate([0, 0, inches(5.5)])
    linear_extrude(CABINET_HEIGHT)
    square([CABINET_WIDTH, CABINET_DEPTH], center=true);
}

// The base support built from 2x6 lumber
module base_support(cross_count=4) {
    // Local variables
    depth_wise_length = mm_to_feet(CABINET_DEPTH - inches(3));
    width_wise_length = mm_to_feet(CABINET_WIDTH);
    width_wise_stride = (CABINET_WIDTH - inches(1.5)) / (cross_count-1);

    // Width-wise support
    report(2, 2, 6, width_wise_length);
    color("DarkTurquoise")
    copy_mirror_y()
    translate([
        0,
        CABINET_DEPTH/2 - inches(1.5/2),
        inches(5.5/2)
    ])
    rotate([90, 0, 90])
    dimensional_lumber(2, 6, width_wise_length);

    // Depth-wise support
    report(cross_count, 2, 6, depth_wise_length);
    color("steelblue")
    for (i=[0:cross_count-1]) {
        translate([
            -(CABINET_WIDTH - inches(1.5))/2 + width_wise_stride*i, 
            0,
            inches(5.5/2)
        ])
        rotate([90, 0, 0])
        dimensional_lumber(2, 6, depth_wise_length);
    }
}

// The two 2x12 vertical supports
module vertical_supports() {
    // The 1x12s
    report(2, 2, 12, mm_to_feet(CEILING_HEIGHT));
    color("indianred")
    copy_mirror_x()
    translate([
        (CABINET_WIDTH + inches(1.5))/2,
        (CABINET_DEPTH - inches(11.5))/2,
        CEILING_HEIGHT/2
    ])
    dimensional_lumber(2, 12, mm_to_feet(CEILING_HEIGHT));

    // Two horizontal 2x2 supports across ceiling
    report(2, 2, 2, mm_to_feet(CABINET_WIDTH));
    color("tomato")
    translate([0, inches(0.25), 0]) copy_mirror_y()
    translate([0, inches(5), CEILING_HEIGHT - inches(1.5)/2])
    rotate([0, 90, 0]) dimensional_lumber(2, 2, mm_to_feet(CABINET_WIDTH));
}

// The counter top, made of a 1x12 and a 1x2
module countertop() {
    translate([0, (CABINET_DEPTH - inches(1.5))/2, CABINET_HEIGHT + inches(5.5)]) {
        // Backing 1x2 to give the countertop a lip
        report(1, 1, 2, mm_to_feet(CABINET_WIDTH));
        color("limegreen")
        translate([0, 0, inches(0.5)/2]) rotate([90, 90, 90])
        dimensional_lumber(1, 2, mm_to_feet(CABINET_WIDTH));

        // 1x12 countertop
        report(1, 1, 12, mm_to_feet(CABINET_WIDTH));
        color("palegreen")
        translate([0, -inches(13)/2, inches(0.5)/2]) rotate([90, 90, 90])
        dimensional_lumber(1, 12, mm_to_feet(CABINET_WIDTH));
    }
}

// A single shelf
module shelf() {
    // 1x2 shelf support in rear
    report(1, 1, 2, mm_to_feet(CABINET_WIDTH));
    color("sandybrown")
    translate([0, CABINET_DEPTH/2 - inches(0.5), 0])
    rotate([90, 0, 90]) dimensional_lumber(1, 2, mm_to_feet(CABINET_WIDTH));

    // 1x2 shelf supports on sides
    report(1, 1, 2, mm_to_feet(CABINET_DEPTH - inches(1)));
    color("tan")
    copy_mirror_x()
    translate([(CABINET_WIDTH - inches(0.5))/2, -inches(0.25), 0])
    rotate([90, 0, 0]) dimensional_lumber(1, 2, mm_to_feet(CABINET_DEPTH - inches(1)));

    // 1x12 shelf top
    color("beige")
    translate([0, 0, inches(1)])
    rotate([0, 90, 0]) dimensional_lumber(1, 12, mm_to_feet(CABINET_WIDTH));

    // Shelf faecia
    color("khaki")
    translate([0, -CABINET_DEPTH/2, 0])
    rotate([90, 0, 90]) dimensional_lumber(1, 3, mm_to_feet(CABINET_WIDTH - inches(2)));
}

// All the shelves in a single built-in shelving unit
module shelves(count=3) {
    step = CLEARANCE_ABOVE_COUNTERTOP / (count+1);
    translate([0, inches(0.25), COUNTERTOP_HEIGHT - inches(1.25)]) {
        for (i=[1:count]) {
            translate([0, 0, i*step])
            shelf();
        }
    }
}

module support_faecia() {
    // Upper faecia
    color("orchid")
    copy_mirror_x()
    translate([CABINET_WIDTH/2 + inches(0.25), -inches(12)/2 + inches(0.25), (CEILING_HEIGHT + COUNTERTOP_HEIGHT)/2])
    rotate([0, 0, 90]) dimensional_lumber(1, 3, mm_to_feet(CEILING_HEIGHT - COUNTERTOP_HEIGHT));

    // Lower faecia
    color("plum")
    copy_mirror_x()
    translate([CABINET_WIDTH/2 + inches(0.75), -inches(12)/2 + inches(0.25), COUNTERTOP_HEIGHT/2])
    rotate([0, 0, 90]) dimensional_lumber(1, 2, mm_to_feet(COUNTERTOP_HEIGHT));
}

module top_header() {
    color("darkorange")
    translate([0, -CABINET_DEPTH/2 + inches(0.25), CEILING_HEIGHT - inches(7.5)/2])
    rotate([90, 0, 90]) dimensional_lumber(1, 8, mm_to_feet(CABINET_WIDTH - inches(2)));
}

// Fully assembled built-in shelving unit
module built_in_shelving_unit() {
    cabinet();

    base_support();
    vertical_supports();

    countertop();

    shelves(3);
    support_faecia();

    top_header();
}
// copy_mirror_x()
// translate([feet(10), 0, 0])
built_in_shelving_unit();
