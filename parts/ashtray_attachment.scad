use <../utils/circles.scad>;

$fn = 90;

ID = 102.31;
OD = 116.16;
MID = (ID + OD) / 2;

HOLDER_WIDTH = 25;
HOLDER_THICKNESS = 15;
HOLDER_FOOT_LENGTH = 18;
HOLDER_FINGER_LENGTH = 8;
HODLER_FINGER_SPACING = 8;
LIP_THICKNESS = 2.5;
LIP_LENGTH = 12;

TOL = 0.1;

module baseHolder() {
    translate([MID / 2, 0, 0])
    intersection() {
        translate([0, 0, -HOLDER_FOOT_LENGTH])
        linear_extrude(HOLDER_FOOT_LENGTH + HOLDER_FINGER_LENGTH)
        ring(MID / 2 + HOLDER_THICKNESS / 2, MID / 2 - HOLDER_THICKNESS / 2);
        
        translate([-MID / 2, 0, -HOLDER_FOOT_LENGTH])
        linear_extrude(2 * (HOLDER_FOOT_LENGTH + HOLDER_FINGER_LENGTH)) 
        square([HOLDER_WIDTH, HOLDER_WIDTH], center=true);
    }
}

module holderLip() {
    translate([0, 0, (HOLDER_FINGER_LENGTH - LIP_THICKNESS)/ 2])
    rotate([0, 90, 0])
    linear_extrude(HOLDER_THICKNESS + 2 * LIP_LENGTH, center=true)
    square([HOLDER_FINGER_LENGTH + LIP_THICKNESS, HODLER_FINGER_SPACING + 2 * LIP_THICKNESS], center=true);
}

module cavities() {
    translate([MID / 2, 0, 0])
    rotate([180, 0, 0])
    linear_extrude(100)
    ring(outer_radius=OD / 2 + TOL, inner_radius=ID / 2 - TOL);
    
    translate([0, 0, HOLDER_FINGER_LENGTH / 2])
    rotate([0, 90, 0])
    linear_extrude(2 * HOLDER_THICKNESS + 2 * LIP_LENGTH, center=true)
    square([HOLDER_FINGER_LENGTH, HODLER_FINGER_SPACING], center=true);
}

module fullHolder() {
    difference() {
    union() {
        baseHolder();
        holderLip();
    }
    cavities();
}
}

fullHolder();