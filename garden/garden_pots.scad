use <../scad-utils/scale.scad>
use <../scad-utils/round-poly.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 128 : 512;

// Global pot parameters
POT_HEIGHT = inches(3);
POT_UNIT_WIDTH = inches(1.2);
POT_BASE_WIDTH = inches(0.65);
THICKNESS = 1.75;
HOLE_DIAMETER = 13;

// Global clip parameters
CLIP_WIDTH = POT_UNIT_WIDTH - inches(0.5);

// Limits
MIN_CURVE_RADIUS = 2;
MAX_CURVE_RADIUS = (POT_UNIT_WIDTH - CLIP_WIDTH) / 2;
MIN_COLLAR_HEIGHT = 5;
MAX_COLLAR_HEIGHT = POT_HEIGHT - inches(1);

function clamp(value, low, high) = max(min(value, high), low);

module drain_hole() {
  % cylinder(h=2*POT_HEIGHT, d=HOLE_DIAMETER, center=true);
}

module pot_profile(size, radius) {
  x1 = size * POT_UNIT_WIDTH;
  x2 = x1 - 2* THICKNESS;
  
  difference() {
    round_poly([
      [ x1/2,  x1/2, radius],
      [-x1/2,  x1/2, radius],
      [-x1/2, -x1/2, radius],
      [ x1/2, -x1/2, radius],
    ]);
    round_poly([
      [ x2/2,  x2/2, radius - THICKNESS],
      [-x2/2,  x2/2, radius - THICKNESS],
      [-x2/2, -x2/2, radius - THICKNESS],
      [ x2/2, -x2/2, radius - THICKNESS],
    ]);
  }
}

module pot_collar(size, radius, height) {
  linear_extrude(height)
  pot_profile(size=size, radius=radius);
}

module pot_funnel(size, radius, height) {
  ratio = min(POT_UNIT_WIDTH, POT_BASE_WIDTH) / max(POT_UNIT_WIDTH, POT_BASE_WIDTH);
  rotate([180, 0, 0])
  linear_extrude(height, scale=ratio)
  pot_profile(size=size, radius=radius);
}

module base_pot(size, collar_height, curve_radius) {
  // Main pot walls
  curve_radius = clamp(value=curve_radius, low=MIN_CURVE_RADIUS, high=MAX_CURVE_RADIUS);
  collar_height = clamp(value=collar_height, low=MIN_COLLAR_HEIGHT, high=MAX_COLLAR_HEIGHT);
  translate([0, 0, POT_HEIGHT - collar_height]) {
    pot_collar(size=size, radius=curve_radius, height=collar_height);
    pot_funnel(size=size, radius=curve_radius, height=POT_HEIGHT-collar_height);
  }
  
  // Pot floor
  
  // Hole grid
  translate([-(size-1) * POT_UNIT_WIDTH * 0.5, -(size-1) * POT_UNIT_WIDTH * 0.5, 0])
  array([0, POT_UNIT_WIDTH, 0], size)
  array([POT_UNIT_WIDTH, 0, 0], size)
  drain_hole();
}
translate([-2*POT_UNIT_WIDTH, 0, 0])
base_pot(size=1, collar_height=inches(0.75), curve_radius=10);
base_pot(size=2, collar_height=inches(0.75), curve_radius=10);
translate([3*POT_UNIT_WIDTH, 0, 0])
base_pot(size=3, collar_height=inches(0.75), curve_radius=10);