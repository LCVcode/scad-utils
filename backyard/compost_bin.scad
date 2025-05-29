use <../scad-utils/modifiers.scad>
use <../scad-utils/lumber.scad>
use <../scad-utils/scale.scad>

// General parameters (feet)
HEIGHT = 3;
WIDTH = 3;
DEPTH = 2.5;

// Materials parameters
ply_thickness = 1;

module groove_assembly() {
  color("tan")
  copy_mirror_y()
  translate([0, inches(0.75) + inches(ply_thickness)/2, feet(HEIGHT/2)])
  2x4_lumber(length=HEIGHT);
  
  color("chocolate")
  translate([0, 0, feet(HEIGHT/2)])
  rotate([90, 90, 0])
  linear_extrude(inches(ply_thickness), center=true)
  square([feet(HEIGHT), inches(1.5)], center=true);
}

module bin_wall() {
  translate([0, feet(DEPTH/2), 0])
  groove_assembly();
  
  // Horizontal 4x4 lumber
  color("sienna")
  for (z=[0, feet(HEIGHT)-inches(3.5)]) {
    translate([0, -inches(1.5 + ply_thickness/2), inches(3.5/2)+z])
    rotate([90, 0, 0])
    4x4_lumber(DEPTH);
  }
  
  // Vertical 4x4
  color("saddlebrown")
  translate([0, -(feet(DEPTH/2)+inches(3.5)), feet(HEIGHT/2)])
  4x4_lumber(HEIGHT);
}

module compost_bin(count) {
  translate([-feet(WIDTH)*count/2, 0, 0])
  for (i=[0:count]) {
    translate([i * feet(WIDTH), 0, 0])
    bin_wall();
  }
  
  // Backing 4x4 lumber
  color("maroon")
  translate([-(feet(WIDTH/2)*(count-1)), -(feet(DEPTH/2) + inches(3.5)), inches(3.5/2)])
  for (z=[0:1]) for (x=[0:count-1])
    translate([x * feet(WIDTH), 0, z * (feet(HEIGHT) - inches(3.5))])
    rotate([90, 0, 90])
    4x4_lumber(WIDTH - 3.5/12);
}
compost_bin(2);