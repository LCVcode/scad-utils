use <scale.scad>
use <round-poly.scad>
use <modifiers.scad>

$fn = $preview ? 16 : 64;

PEG_DIAMETER = inches(0.228);
SPACING = inches(1);
THICKNESS = inches(0.215);
HOOK_RADIUS = inches(0.17);
BACKING_PADDING = inches(0.1);

PEG_RADIUS = PEG_DIAMETER/2;

module hook() {
  translate([0, THICKNESS, 0]) {
  rotate([90, 0, 0]) linear_extrude(THICKNESS) circle(d=PEG_DIAMETER);
  translate([0, 0, PEG_RADIUS + HOOK_RADIUS]) rotate([0, 90, 0]) rotate_extrude(angle=90) translate([PEG_RADIUS + HOOK_RADIUS, 0, 0]) circle(d=PEG_DIAMETER);
  translate([0, PEG_RADIUS + HOOK_RADIUS, PEG_RADIUS + HOOK_RADIUS]) rotate([90, 0, 0]) rotate_extrude(angle=180) intersection() {
    circle(d=PEG_DIAMETER);
    translate([0, -PEG_RADIUS, 0]) square(size=PEG_DIAMETER);
  }}
}

module peg() {
  translate([0, THICKNESS, 0]) {
  rotate([90, 0, 0]) linear_extrude(THICKNESS) circle(d=PEG_DIAMETER);
  rotate_extrude(angle=180) intersection() {
    circle(d=PEG_DIAMETER);
    translate([0, -PEG_RADIUS, 0]) square(size=PEG_DIAMETER);  
  }}
}

module hanger_backing(width, height=2) {
  backing_thickness = inches(0.35);
  // Full frame translation
  translate([-(width-1)/2 * SPACING, backing_thickness, -PEG_RADIUS]) {
  width = max(1, abs(width));
  height = max(1, abs(height));
  
  // Hooks & pegs
  for (i=[0:width-1]) translate([i*SPACING, 0, 0]) hook();
  if (height > 1) {for (i=[0:width-1]) translate([i*SPACING, 0, -(height-1) * SPACING]) peg();}
  
  // Frame
  x = (width-1) * SPACING + PEG_DIAMETER;
  y = (height-1) * SPACING + PEG_DIAMETER;

  translate([-PEG_RADIUS, 0, -(height-1) * SPACING -PEG_RADIUS])
  rotate([90, 0, 0])
  linear_extrude(backing_thickness)
  difference() {
    round_poly([
      [0, 0, PEG_RADIUS],
      [x, 0, PEG_RADIUS],
      [x, y, PEG_RADIUS],
      [0, y, PEG_RADIUS]
    ], resolution=$preview ? 30 : 3);
    round_poly([
      [    2*PEG_DIAMETER,     2*PEG_DIAMETER, PEG_RADIUS],
      [x - 2*PEG_DIAMETER,     2*PEG_DIAMETER, PEG_RADIUS],
      [x - 2*PEG_DIAMETER, y - 2*PEG_DIAMETER, PEG_RADIUS],
      [    2*PEG_DIAMETER, y - 2*PEG_DIAMETER, PEG_RADIUS]
    ], resolution=$preview ? 30 : 3);
  }}
}

module hammer_holder() {
  // Parameters
  separation = inches(1.06);
  length = inches(1);
  x = (3/2*SPACING + PEG_RADIUS - separation)/2;
  y = inches(0.5)/2;
  
  hanger_backing(width=3);
  
  // Prongs for holding hammer
  copy_mirror_x()
  translate([-x + SPACING + PEG_RADIUS, 0, -y])
  rotate([90, 0, 0])
  linear_extrude(length)
  round_poly([
    [ x,  y, PEG_RADIUS],
    [-x,  y, 2*min(x, y) - PEG_RADIUS - 0.1],
    [-x, -y, PEG_RADIUS],
    [ x, -y, PEG_RADIUS],
  ]);
  
  // Prong lips to prevent hammer slipping off prongs
  copy_mirror_x()
  translate([-x + SPACING + PEG_RADIUS, -length, -y])
  rotate([90, 0, 0])
  linear_extrude(3)
  round_poly([
    [ x,  y + 6, PEG_RADIUS],
    [-x,  y + 6, 2*min(x, y) - PEG_RADIUS - 0.1],
    [-x, -y, PEG_RADIUS],
    [ x, -y, PEG_RADIUS],
  ]);
}
// hammer_holder();

module large_level_holder() {
  // Parameters
  triangle_height = inches(0.8);
  triangle_width = inches(1.2);
  radius = inches(0.1);
  hanger_depth = inches(0.5);
  lip_size = 5;
  lip_thickness = 3;
  
  hanger_backing(width=2);
  
  translate([0, 0, -radius]) {
  // Main hanger
  rotate([90, -90, 0])
  linear_extrude(hanger_depth)
  round_poly([
    [0, 0, radius],
    [-triangle_height,  triangle_width/2, radius],
    [-triangle_height, -triangle_width/2, radius]
  ]);
  
  // Lip
  translate([0, -hanger_depth, 0])
  rotate([90, -90, 0])
  linear_extrude(lip_thickness)
  round_poly([
    [lip_size, 0, radius],
    [-triangle_height,  triangle_width/2, radius],
    [-triangle_height, -triangle_width/2, radius]
  ]);
  }
}
// large_level_holder();

module small_level_holder() {
  hole_diameter = inches(0.389);
  hanger_backing(width=2);
  level_thickness = inches(0.72);
  
  translate([0, 0, -hole_diameter/2]) {
    rotate([90, 0, 0])
    cylinder(level_thickness, d=hole_diameter * 0.75);
    translate([0, -level_thickness, 0])
    sphere(d=hole_diameter * 0.9);
  }
}
// small_level_holder();

module large_measuring_tape_holder_profile(handle_width, holder_thickness, handle_thickness) {

  tolerance = 1;

  copy_mirror_x()
  round_poly([
    [0, holder_thickness, 0],
    [handle_width/2 + tolerance, holder_thickness, handle_thickness/4],
    [handle_width/2 + tolerance, holder_thickness + handle_thickness/2, holder_thickness/2 - tolerance],
    [handle_width/2 + tolerance + holder_thickness, holder_thickness + handle_thickness/2, holder_thickness/2 - tolerance],
    [handle_width/2 + tolerance + holder_thickness, 0, holder_thickness/2],
    [0, 0, 0],
  ], resolution=$preview ? 30 : 3);
}

module large_measuring_tape_holder() {
  // Parameters
  holder_thickness = 10;
  holder_width = inches(4);
  handle_thickness = 34.7;
  handle_width = 32.5;

  hanger_backing(width=3);

  translate([0, -handle_width/2 - handle_thickness/8, -handle_thickness/2 - holder_thickness]) {
  rotate([90, 0, 90])
  linear_extrude(holder_width - 2*(holder_thickness + handle_thickness/2), center=true)
  large_measuring_tape_holder_profile(handle_width, holder_thickness, handle_thickness);

  copy_mirror_x()
  translate([-holder_width/2 + holder_thickness + handle_thickness/2, 0, 0]) rotate([-90, 0, 0]) 
  rotate_extrude(angle=90) rotate([0, 0, 90])
  large_measuring_tape_holder_profile(handle_width, holder_thickness, handle_thickness);
  }
}
// large_measuring_tape_holder();

module convenience_cup() {
  tolerance = 1;

  // Parameters
  width = inches(2) - 2*tolerance;
  height = inches(2) - 2*tolerance;

  hanger_backing(width=2);
}
convenience_cup();