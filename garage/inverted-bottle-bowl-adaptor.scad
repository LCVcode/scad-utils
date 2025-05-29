use <../scad-utils/modifiers.scad>

$fn = $preview ? 64 : 256;

// === CONSTANTS ===
// Peg measurements
R_PEG = 31.48/2;  // Radius of the peg built into the bowl

// Bottle neck measurements
R_NECK = 28.8/2; // Radius of the bottle neck

// === PARAMETERS ===
// Neck holder
H_NECK = 45; // Height of the neck holder
T_NECK = 10; // Thickness of the neck holder walls

// Peg holder
T_PEG = 8; // Thickness of the peg holder walls

// Body
PEG_OFFSET = 48.5;  // Offset between the peg holder and neck holders
BODY_HEIGHT = 25; // Height of the main body that connects all three holes
N_DIFFERENCE = 7.5; // Difference in the heights of the two bottle necks

// Drains
D_DRAIN = 14; // Diameter of drain tubes
R_DRAIN = 20; // Radius of the turn in the drain

// === VARIABLES ===
BODY_WIDTH = 2 * (max(R_NECK, R_PEG) + T_PEG);

module bottle_neck_holder() {
  difference() {
    circle(r=R_NECK + T_NECK);
    circle(r=R_NECK + 1);
  }
}

module base_body() {
  linear_extrude(BODY_HEIGHT)
  difference() {
    hull() {
      circle(d=BODY_WIDTH);
      copy_mirror_x()
      translate([PEG_OFFSET, 0, 0])
      circle(r=R_NECK + T_NECK);
    }    
    circle(r=R_PEG + 3);
  }
}


module drain_hole() {
  translate([-PEG_OFFSET - R_DRAIN, 0, R_DRAIN]) {
    rotate([-90, 0, 0])
    rotate_extrude(angle=90)
    translate([R_DRAIN, 0, 0])
    circle(d=D_DRAIN);
    
    translate([R_DRAIN, 0, 0])
    linear_extrude(100)
    circle(d=D_DRAIN);
    
    translate([0, 0, -R_DRAIN])
    rotate([0, -90, 0])
    linear_extrude(100)
    circle(d=D_DRAIN);
  }
}


module air_hole() {
  rotate([0, 90, 0])
  linear_extrude(R_NECK + T_NECK + 10)
  scale([1.5, 1, 1])
  circle(d=D_DRAIN);
}


module bowl_bottle_holder() {
  difference() {
  union() {
  base_body();
  
  translate([PEG_OFFSET, 0, BODY_HEIGHT + N_DIFFERENCE - 0.1]) {
    linear_extrude(H_NECK)
    bottle_neck_holder();
    
    translate([0, 0, -N_DIFFERENCE - 0.25])
    linear_extrude(N_DIFFERENCE + 0.5)
    circle(r=R_NECK + T_NECK);
  }
  
  translate([-PEG_OFFSET, 0, BODY_HEIGHT - 0.1])
  linear_extrude(H_NECK)
  bottle_neck_holder();
  }
  
  copy_mirror_x()
  drain_hole();
  
  translate([PEG_OFFSET, 0, BODY_HEIGHT + N_DIFFERENCE])
  air_hole();
  
  rotate([0, 0, 180])
  translate([PEG_OFFSET, 0, BODY_HEIGHT])
  air_hole();
  }  
}
bowl_bottle_holder();