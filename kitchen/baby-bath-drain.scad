use <scad-utils/round-poly.scad>
use <scad-utils/modifiers.scad>
use <scad-utils/scale.scad>

$fn = $preview ? 16 : 128;

// Parameters
THICKNESS = 3;
DIAMETER = inches(11/16);
LENGTH = inches(3);
FLANGE_LENGTH = inches(0.5);

// Constants
R = DIAMETER/2;
CURVE = THICKNESS/2 - 0.01;

rotate_extrude()
translate([-R+THICKNESS, 0, 0])
rotate([0, 0, 90])
round_poly([
  [0, THICKNESS, 0],
  [0, THICKNESS + FLANGE_LENGTH, CURVE],
  [THICKNESS, THICKNESS + FLANGE_LENGTH, CURVE],
  [THICKNESS, 2*THICKNESS, THICKNESS],
  [2*THICKNESS, 0, THICKNESS],
  [-LENGTH, 0, CURVE],
  [-LENGTH, THICKNESS, CURVE],
], resolution=360/$fn);