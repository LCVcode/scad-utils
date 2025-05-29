$fn=180;

PIPE_OD = 26.67;
THICKNESS=2.75;
TOL = 0.175;
LENGTH = 50;

GUARD_HOLE_HEIGHT = 12;
GUARD_HOLE_WIDTH = 8;
GUARD_HOLE_COUNT_PER_RING = 6;
GUARD_RING_COUNT = 3;
GUARD_HOLE_OFFSET = -5;

module pipe_length(id, od, length) {
    difference() {
        cylinder(h=length, r1=od/2, r2=od/2, center=true);
        cylinder(h=length+1, r1=id/2, r2=id/2, center=true);
    }
}

module interference_fit_pipe_sleeve(length, thickness) {
    difference() {
        pipe_length(id=PIPE_OD + 2*TOL, od=PIPE_OD + 2*TOL + 2*thickness, length=length);
        translate([0, 0, -length/2-TOL])
        cylinder(h=3, r2=PIPE_OD/2 + TOL, r1=PIPE_OD/2 + TOL + thickness/2);
    }
}

module guard_holes() {
    angle = 360 / GUARD_HOLE_COUNT_PER_RING;
    translate([0, 0, GUARD_HOLE_OFFSET])
    for (j = [0:GUARD_RING_COUNT-1]) {
    for (i = [0:GUARD_HOLE_COUNT_PER_RING-1]) {
        translate([0, 0, j * (THICKNESS*0.8 + GUARD_HOLE_HEIGHT/2)])
        rotate([90, 0, (i + 0.5*j)*angle])
        linear_extrude(PIPE_OD)
        polygon([[0, 0], 
                 [GUARD_HOLE_WIDTH/2, GUARD_HOLE_HEIGHT/2],
                 [0, GUARD_HOLE_HEIGHT],
                 [-GUARD_HOLE_WIDTH/2, GUARD_HOLE_HEIGHT/2]]);
    }}
}

module guard() {
    difference() {
        // Base guard cone
        difference() {
            cylinder(h=LENGTH/2, r1=PIPE_OD/2+THICKNESS+TOL, r2=PIPE_OD/2-THICKNESS);
            translate([0, 0, -TOL/2])
            cylinder(h=LENGTH/2+2*TOL, r1=PIPE_OD/2+TOL, r2=PIPE_OD/2-2*THICKNESS);
        }
        
        guard_holes();
    }
}

union() {
translate([0, 0, -LENGTH/4+TOL])
interference_fit_pipe_sleeve(length=LENGTH/2, thickness=THICKNESS);

guard();
}