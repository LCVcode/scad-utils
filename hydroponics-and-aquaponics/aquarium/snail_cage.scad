$fn=270;

TOL=0.33;
ACRYLIC_THICKNESS=5.5;
HOOK_LENGTH=50;
HOOK_THICKNESS=7;
HOOK_WIDTH=15;
CAGE_RADIUS=65;
CAGE_HEIGHT=100;
CAGE_WALL_THICKNESS=6;
HOLE_WIDTH=12;
HOLE_COUNT=8;
LID_THICKNESS=6;
HANDLE_THICKNESS=6;
HANDLE_WIDTH=50;
HANDLE_HEIGHT=25;

module hookDrawing(length, thickness, stride) {
    union() {
        polygon([
            [0, 0],
            [stride, 0],
            [stride, thickness],
            [-thickness/2, thickness],
            [-thickness, thickness/2],
            [-thickness, -length],
            [0, -length]
        ]);
        translate([-thickness/2, thickness/2, 0])
        circle(thickness/2);
        translate([-thickness/2, -length, 0])
        circle(thickness/2);
    }
}
*hookDrawing(length=HOOK_LENGTH, thickness=HOOK_THICKNESS, stride=ACRYLIC_THICKNESS);

module hook(length, thickness, stride, width) {
    translate([-stride, 0, 0])
    rotate([90, 0, 0])
    linear_extrude(width, center=true)
    hookDrawing(length, thickness, stride);
}


module halfCylinder(r, h) {
    // A generic half cylinder for general use
    difference() {
        cylinder(h, r, r);
        translate([0, 0, h/2])
        rotate([180, 90, 0])
        linear_extrude(2*r)
        square(3*r, center=true);
    }
}

module cageHole(h) {    
    rotate([90, 0, 90])
    linear_extrude(100)
    union() {
        square([HOLE_WIDTH, h - HOLE_WIDTH], center=true);
        translate([0, -h/2 + HOLE_WIDTH/2, 0])
        circle(r=HOLE_WIDTH/2);
        translate([0, h/2 - HOLE_WIDTH/2, 0])
        circle(r=HOLE_WIDTH/2);
    }
}

module cageHoles() {
    // Local parameters
    angle = 180 / HOLE_COUNT;
    height = CAGE_HEIGHT - 4 * CAGE_WALL_THICKNESS;
    
    union() {
    for (i=[0:angle:180]) {
        translate([HOLE_WIDTH/2 + CAGE_WALL_THICKNESS + 0.25, 0, height/2 + 2*CAGE_WALL_THICKNESS])
        rotate([0, 0, -90+i])
        cageHole(height);
    }}
}

module cageWalls() {
    difference() {
        halfCylinder(r=CAGE_RADIUS, h=CAGE_HEIGHT);
        translate([CAGE_WALL_THICKNESS, 0, CAGE_WALL_THICKNESS])
        halfCylinder(r=CAGE_RADIUS - 2*CAGE_WALL_THICKNESS,h=CAGE_HEIGHT);
    }
}

module cage() {
    translate([0, 0, -CAGE_HEIGHT+HOOK_THICKNESS+10])
    difference() {
        cageWalls();
        cageHoles();
    }
}

module snailCage() {
    union() {
        cage();
        hook(length=HOOK_LENGTH, thickness=HOOK_THICKNESS, stride=ACRYLIC_THICKNESS, width=HOOK_WIDTH);
    }
}
*snailCage();

module lidHandle() {
    linear_extrude(HANDLE_THICKNESS, center=true)
    difference() {
    union() {
    square([HANDLE_WIDTH, HANDLE_HEIGHT/2], center=true);
    translate([0, HANDLE_HEIGHT/4, 0])
    circle(HANDLE_HEIGHT/2);
    }
    translate([HANDLE_HEIGHT, HANDLE_HEIGHT/4, 0])
    circle(HANDLE_HEIGHT/2);
    translate([-HANDLE_HEIGHT, HANDLE_HEIGHT/4, 0])
    circle(HANDLE_HEIGHT/2);
    }
}

module lid() {
    union() {
        // lid
        translate([0, 0, LID_THICKNESS/2])
        halfCylinder(r=CAGE_RADIUS, h=LID_THICKNESS);
        translate([CAGE_WALL_THICKNESS + 2, 0, 0])
        halfCylinder(r=CAGE_RADIUS - 2*CAGE_WALL_THICKNESS - 4, h=4);
        
        // handle
        translate([CAGE_RADIUS/2.5-HANDLE_THICKNESS/2, 0, (HANDLE_HEIGHT+LID_THICKNESS)/2])
        rotate([90, 0, 90])
        lidHandle();
    }
    
}
translate([0, 0, 20])
lid();