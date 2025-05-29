use <../scad-utils/scale.scad>
use <../scad-utils/round-poly.scad>

$fn = $preview ? 16 : 128;

TOL = 0.2;  // Global tolerance

// Pump chamber & taper parameters

CHAMBER_H = inches(0.5);
CHAMBER_D = inches(1.25);
CHAMBER_T = 6;
TAPER_H = inches(1);

// PVC adaptor parameters

PVC_INTERNAL_NECK_LENGTH = inches(0.25);
PVC_EXTERNAL_NECK_LENGTH = inches(1.2);
PVC_NECK_T = 5;
PVC_PIPE_INNER_D = 20.1;
PVC_PIPE_OUTER_D = 26.25;
AIR_STONE_DIAMETER = 15.6;

// Port parameters

PORT_INNER_D = 5;
PORT_OUTER_D_MIN = 7.25;
PORT_OUTER_D_MAX = 12.5;
PORT_LENGTH = 30;

module air_lift_pump_neck_profile() {
  x2 = PVC_PIPE_INNER_D / 2 - TOL;  // Neck touching inside of inner PVC pipe
  x3 = PVC_PIPE_OUTER_D / 2 + TOL;    // Neck touching outside of wider PVC pipe
  x1 = max(x2 - PVC_NECK_T, AIR_STONE_DIAMETER / 2 + TOL);  // Inner-most part of the neck, where the bubbles are
  x4 = x3 + PVC_NECK_T;  // Outer-most part of the neck
  
  assert (x1 < x2);
  
  y1 = PVC_INTERNAL_NECK_LENGTH;
  y2 = PVC_EXTERNAL_NECK_LENGTH;
  y3 = - PVC_NECK_T;
  
  r1 = (x2 - x1) * 0.67;
  r2 = PVC_NECK_T * 0.67;
  
  round_poly([
  [ x1, y3,  0],
  [ x1, y1,  0],
  [ x2, y1, r1],
  [ x2,  0,  0],
  [ x3,  0,  0],
  [ x3, y2, r2],
  [ x4, y2,  0],
  [ x4, y3,  0],
  ]);
}


module air_lift_pump_neck() {
  rotate_extrude()
  translate([0, PVC_NECK_T, 0])
  air_lift_pump_neck_profile();
}
// air_lift_pump_neck();

module air_lift_pump_body_profile() {
  x1 = max(PVC_PIPE_INNER_D / 2 - TOL - PVC_NECK_T, AIR_STONE_DIAMETER / 2 + TOL);
  x2 = PVC_PIPE_OUTER_D / 2 + TOL + PVC_NECK_T;
  x3 = CHAMBER_D / 2;
  x4 = x3 + CHAMBER_T;
  
  y1 = -CHAMBER_T;
  y2 = CHAMBER_H;
  y3 = y2 + TAPER_H;
  
  r = CHAMBER_H / 3;
  
  round_poly([
  [  0, y1, 0],
  [  0,  0, 0],
  [ x3,  0, r],
  [ x3, y2, r],
  [ x1, y3, 0],
  [ x2, y3, 0],
  [ x4, y2, r],
  [ x4, y1, 0],
  ]);
}

module air_lift_pump_body() {
  rotate_extrude()
  air_lift_pump_body_profile();
}

module port_profile() {
  cylinder(h=PORT_LENGTH, r1=PORT_OUTER_D_MAX/2, r2=PORT_OUTER_D_MIN/2);
}

module port_hole() {
  cylinder(h=CHAMBER_T + PORT_LENGTH + 2*TOL, d=PORT_INNER_D);
}

module air_lift_pump() {
  difference() {
  union() {
    translate([0, 0, CHAMBER_H + TAPER_H - TOL])
    air_lift_pump_neck();
    air_lift_pump_body();
    translate([CHAMBER_D/2, 0, CHAMBER_H/2])
    rotate([0, 90, 0])
    port_profile();
  }
  translate([CHAMBER_D/2 - 2*TOL, 0, CHAMBER_H/2])
  rotate([0, 90, 0])
  port_hole();
  }
}

module port_tester() {
  intersection() {
  air_lift_pump();
  translate([(CHAMBER_D + PORT_LENGTH)/2, 0, CHAMBER_H/2])
  linear_extrude(PORT_OUTER_D_MAX + TOL, center=true)
  square([30, PORT_OUTER_D_MAX + TOL], center=true);
  }
}

air_lift_pump();