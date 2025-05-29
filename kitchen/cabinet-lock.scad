use <../scad-utils/modifiers.scad>
use <../scad-utils/round-poly.scad>

$fn = $preview ? 24 : 128;

// Real-world parameters
HANDLE_DIAMETER = 10.2;  // Diameter of the rods that the lock will snap to
HANDLE_SEPARATION = 65;  // 

// Subjective parameters
OVERSWEEP_ANGLE = 12;
UNDERSWEEP_ANGLE = 12;
PROFILE_WIDTH = 9.2;
LOCK_THICKNESS = 7.25;
FLARE_ANGLE = 45;
FLARE_RADIUS = 8;

module profile(width, height) {
  intersection() {
    circle(d=max(width, height));
    square([height, width], center=true);
  }
}

module cabinet_lock() {
  // Cabinet handles to lock around
  handle_x = (HANDLE_SEPARATION-HANDLE_DIAMETER)/2;
  %copy_mirror_x()
  translate([handle_x, 0, 0])
  circle(d=HANDLE_DIAMETER);

  copy_mirror_x()
  translate([(HANDLE_SEPARATION - HANDLE_DIAMETER)/2, 0, 0])
  rotate([0, 0, UNDERSWEEP_ANGLE]) {
  translate([-HANDLE_DIAMETER/2-PROFILE_WIDTH - 0.5, 0, 0])
  rotate_extrude(angle=-90-UNDERSWEEP_ANGLE)
  translate([PROFILE_WIDTH/2+0.5, 0, 0])
  profile(LOCK_THICKNESS, PROFILE_WIDTH);
  
  rotate([0, 0, -OVERSWEEP_ANGLE - UNDERSWEEP_ANGLE]) {
  rotate_extrude(angle=180 + OVERSWEEP_ANGLE + UNDERSWEEP_ANGLE)
  translate([(HANDLE_DIAMETER + PROFILE_WIDTH)/2, 0, 0])
  profile(LOCK_THICKNESS, PROFILE_WIDTH);
  
  translate([FLARE_RADIUS + (HANDLE_DIAMETER + PROFILE_WIDTH)/2, 0, 0]) {
    rotate_extrude(angle=FLARE_ANGLE)
    translate([-FLARE_RADIUS, 0, 0])
    profile(LOCK_THICKNESS, PROFILE_WIDTH);
    
    translate([-FLARE_RADIUS * cos(FLARE_ANGLE), -FLARE_RADIUS * sin(FLARE_ANGLE), 0])
    rotate_extrude(angle=360)
    take_x()
    profile(LOCK_THICKNESS, PROFILE_WIDTH);
  }}}
  
  translate([0, (HANDLE_DIAMETER+PROFILE_WIDTH)/2, 0])
  rotate([90, 0, 90])
  linear_extrude(HANDLE_SEPARATION - HANDLE_DIAMETER, center=true)
  profile(LOCK_THICKNESS, PROFILE_WIDTH);
  
  r1 = (HANDLE_DIAMETER + PROFILE_WIDTH) / 2;
  r2 = PROFILE_WIDTH / 2 + 0.5;
  translate([0, -(r1+r2)*sin(UNDERSWEEP_ANGLE) - r2, 0])
  rotate([90, 0, 90])
  linear_extrude(HANDLE_SEPARATION - HANDLE_DIAMETER - (2*(r1 + r2) * cos(UNDERSWEEP_ANGLE)), center=true)
  profile(LOCK_THICKNESS, PROFILE_WIDTH);
  
  /*
  translate([handle_x, 0, 0])
  rotate([0, 0, -OVERSWEEP_ANGLE])
  !rotate_extrude(angle=180 + OVERSWEEP_ANGLE + UNDERSWEEP_ANGLE)
  translate([(HANDLE_DIAMETER + PROFILE_WIDTH)/2, 0, 0])
  profile(LOCK_THICKNESS, PROFILE_WIDTH);
  */
}

module cabinet_lock_with_text(msg) {
  cabinet_lock();
}
cabinet_lock_with_text();