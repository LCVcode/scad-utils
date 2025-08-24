use <../scad-utils/round-poly.scad>


$fn = $preview ? 16 : 256;


// ADJUSTABLE PARAMETERS
CAP_HEIGHT = 25;
CAP_WALL_THICKNESS = 5;
CAP_GRIP_THICKNESS = 9;
CAP_TOLERANCE = 1;


// REAL-WORLD PARAMETERS (do not modify)
PIPE_OD = 26.9;
PIPE_ID = 20;


module cap() {
  x1 = 0;
  x2 = PIPE_OD/2 + CAP_TOLERANCE;
  x3 = PIPE_OD/2 + CAP_WALL_THICKNESS;
  x4 = PIPE_OD/2 + CAP_GRIP_THICKNESS;

  y1 = 0;
  y2 = CAP_HEIGHT - CAP_WALL_THICKNESS;
  y3 = CAP_HEIGHT;
  y4 = 5;
  y5 = 3;
  y6 = -CAP_GRIP_THICKNESS;

  r1 = CAP_WALL_THICKNESS;
  r2 = r1/4;
  r3 = CAP_GRIP_THICKNESS/2;

  translate([0, 0, CAP_GRIP_THICKNESS])
  rotate_extrude(angle=360, convexity=2)
  round_poly([
      [x1, y1,  0],
      [x2, y1,  0],
      [x2, y2, r1],
      [x3, y3, r2],
      [x3, y4, r2],
      [x4, y5, r2],
      [x4, y6, r3],
      [x1, y6,  0],
  ]);
}
cap();
