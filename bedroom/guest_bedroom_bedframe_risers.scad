use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>
use <../scad-utils/round-poly.scad>

$fn = $preview ? 128 : 1024;

// Side length of the profile of a slat's foot
// Assumes profile is square
FOOT_SIZE = 29; 

// The distance that the riser raises the foot off the floor
RISER_HEIGHT = inches(3.5);

// The height of the neck of the riser
// The neck extends up the slat's foot
NECK_HEIGHT = inches(2.25);

// Thickness of the walls of the neck
NECK_THICKNESS = 6;

// Thickness of the base at the bottom of the riser
BASE_HEIGHT = 8;

// This is the extra length added to the profile at the bottom of the riser (touching the floor)
// Does nothing if less than or equal to zero
EXTRA_BASE_SIZE = 22;


module riser_profile() {
  y1 = -RISER_HEIGHT + BASE_HEIGHT;
  y2 = -RISER_HEIGHT;
  
  x1 = (FOOT_SIZE / 2) + NECK_THICKNESS;
  x2 = x1 + EXTRA_BASE_SIZE / 2;
  
  bevel = BASE_HEIGHT * 0.25;
  
  a = sqrt((EXTRA_BASE_SIZE / 2)^2 + y1^2);
  
  theta = abs(asin(y1 / a));
  phi = 180 - 2 * theta;
  
  r = (sin(theta) / sin(phi)) * a;
  
  difference() {
    polygon([
      [  0,  0],
      [ x1,  0],
      [ x2, y1],
      [ x2, y2 + bevel],
      [ x2 - bevel, y2],
      [  0, y2],
    ]);
    translate([r + x1, 0, 0])
    circle(r=r);
  }
}

module riser_base() {
  rotate([90, 0, 0])
  intersection() {
    rotate([0, 90, 0])
    linear_extrude(2*(FOOT_SIZE + EXTRA_BASE_SIZE), center=true)
    copy_mirror_x()
    riser_profile();
    
    linear_extrude(2*(FOOT_SIZE + EXTRA_BASE_SIZE), center=true)
    copy_mirror_x()
    riser_profile();
  }
}

module _riser_neck_positive() {
  x = NECK_THICKNESS + FOOT_SIZE / 2;
  y = NECK_HEIGHT;
  r = NECK_THICKNESS / 2;
  
  rotate([90, 0, 0])
  linear_extrude(FOOT_SIZE + 2 * NECK_THICKNESS, center=true)
  round_poly([
    [  x,  y,  r],
    [  x,  0,  0],
    [ -x,  0,  0],
    [ -x,  y,  r],
  ]);
}

module _riser_neck_negative() {
  x1 = FOOT_SIZE / 2;
  x2 = x1 + NECK_THICKNESS / 2;
  
  y1 = NECK_HEIGHT - NECK_THICKNESS / 2;
  y2 = NECK_HEIGHT;
  
  rotate([90, 0, 0])
  linear_extrude(FOOT_SIZE + 2 * NECK_THICKNESS, center=true)
  polygon([
    [-x1, -1],
    [-x1, y1],
    [-x2, y2],
    [-x2, y2 + 10],
    [ x2, y2 + 10],
    [ x2, y2],
    [ x1, y1],
    [ x1, -1],
  ]);
}

module riser_neck() {
  difference() {
    intersection() {
      rotate([0, 0, 90])
      _riser_neck_positive();
      _riser_neck_positive();
    }
    
    intersection() {
      rotate([0, 0, 90])
      _riser_neck_negative();
      _riser_neck_negative();
    }
}
}

module bed_frame_riser() {
    translate([0, 0, RISER_HEIGHT]) {
      riser_base();
      riser_neck();
    }
}
bed_frame_riser();

module neck_tester() {
  difference() {
    translate([0, 0, -NECK_HEIGHT + inches(1)])
    riser_neck();
    
    rotate([0, 180, 0])
    linear_extrude(NECK_HEIGHT)
    square(size=FOOT_SIZE + 2*NECK_THICKNESS + 1, center=true);
  }
}
// neck_tester();