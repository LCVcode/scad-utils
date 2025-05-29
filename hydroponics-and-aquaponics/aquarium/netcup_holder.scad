$fn=180;

TOE_SPACING = 10;
TOE_THICKNESS = 7;
TOE_LENGTH = 50;
FOOT_HEIGHT = 10;
FOOT_WIDTH = 50;
FOOT_DEPTH = TOE_SPACING + 2*TOE_THICKNESS;
RING_ID = 50.72;
RING_OD = 57;

module baseHolder() {
    linear_extrude(FOOT_HEIGHT)
    difference() {
        union() {
            circle(r=RING_OD/2);
            translate([-(RING_OD + FOOT_DEPTH)/2, 0, 0])
            square([FOOT_DEPTH, FOOT_WIDTH], center=true);
            translate([-RING_ID/2, 0, 0])
            square([30, FOOT_WIDTH], center=true);
        }
        circle(r=RING_ID/2);
    }
}
%baseHolder();

module cupRiser() {
    // Parameters
    slantLength = 5;
    
    // Constant
    IR = RING_ID / 2;
    OR = RING_OD / 2;
    
    translate([0, 0, FOOT_HEIGHT + slantLength * 0.707])
    rotate_extrude()
    polygon([
    [IR, 0],
    [IR, FOOT_HEIGHT],
    [OR, FOOT_HEIGHT],
    [OR, -2],
    [OR - slantLength, -slantLength - 2],
    [OR - slantLength, -(slantLength + FOOT_HEIGHT)],
    [IR - slantLength, -(slantLength + FOOT_HEIGHT)],
    [IR - slantLength, -slantLength],
    ]);
}
cupRiser();