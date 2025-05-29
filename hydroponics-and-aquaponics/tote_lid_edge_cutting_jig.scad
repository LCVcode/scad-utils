use <../scad-utils/round-poly.scad>
use <../scad-utils/modifiers.scad>

// Global fixed parameters
T = 0.5;
iota = 0.1;

// Parameters
slit_width = 1.05;
slit_depth = 18;
border = 8.5;
lid_edge_thickness = 2.13;
tool_width = 80;

module slit_profile() {
  // Local parameters
  r = (slit_width + T) / 2 - iota;
  x1 = slit_width/2 + T;
  x2 = 2*slit_width + T;
  x3 = x2 + 2*r + T;
  y1 = -slit_depth - T;
  y2 = border;
  y3 = y2 + 2*r + T;
  
  copy_mirror_x()
  round_poly([
  [x1, y1, r],
  [x1,  0, r],
  [x2,  0, r],
  [x2, y2, r],
  [x3, y2, r],
  [x3, y3, 0],
  [ 0, y3, 0],
  [ 0, y1, 0]
  ]);
}

// The negative volume which is the slit that the tool will follow
module jig_slit() {
  rotate([90, 0, 0])
  linear_extrude(lid_edge_thickness + 2*border + 2*T, center=true, convexity=10)
  slit_profile();
}

module jig_front_profile() {
  x1 = tool_width/2;
  y1 = border;
  y2 = -slit_depth - border - T;
  r = min(tool_width / 4, border + slit_depth/2 - iota);
  
  copy_mirror_x()
  round_poly([
  [ 0, y1, 0],
  [x1, y1, r],
  [x1, y2, r],
  [ 0, y2, 0]
  ]);
}

module jig_side_profile() {
  x1 = lid_edge_thickness/2;
  x2 = border;
  y1 = -slit_depth - border - T;
  y2 = border;
  r1 = x1 - iota;  // Radius at end of slit
  r2 = border / 3 - iota;
  
  copy_mirror_x()
  round_poly([
  [ 0,  T,  0],
  [x1,  T, r1],
  [x1, y1, r2],
  [x2, y1, r2],
  [x2, y2, r2],
  [ 0, y2,  0],
  ]);
  
}

// The compelted jig, according to above parameters
module jig() {
  difference() {
    intersection() {
      rotate([90, 0, 0])
      linear_extrude(2*border + lid_edge_thickness + T, center=true, convexity=10)
      jig_front_profile();
      rotate([90, 0, 90])
      linear_extrude(tool_width, center=true, convexity=10)
      jig_side_profile();
    }
  
  jig_slit();
  }
}

jig();