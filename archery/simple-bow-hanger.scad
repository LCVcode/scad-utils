use <../scad-utils/round-poly.scad>

$fn = $preview ? 16 : 360;

// Real-world measurements
SCREW_SHAFT_DIAMETER = 4.4;
SCREW_HEAD_DIAMETER = 8.2;
SHELF_DIAMETER = 33;
SHELF_WIDTH = 47;
LIP_HEIGHT = 7;
LIP_THICKNESS = 5;

x1 = SCREW_SHAFT_DIAMETER / 2;
x2 = SCREW_HEAD_DIAMETER / 2;
x3 = SHELF_DIAMETER / 2 + LIP_HEIGHT;
x4 = SHELF_DIAMETER / 2;

y1 = 7;
y2 = SHELF_WIDTH + LIP_THICKNESS;
y3 = SHELF_WIDTH;

rotate_extrude(angle=360, convexity=2)
round_poly([
    [x1, 0, 0],
    [x1,y1, 0.5],
    [x2,y1, 0.5],
    [x2,y2, 2],
    [x3,y2, 2],
    [x3,y3, 2],
    [x4,y3, 4],
    [x4, 0, 0],
]);
