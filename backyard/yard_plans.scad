use <../scad-utils/modifiers.scad>
use <../scad-utils/lumber.scad>
use <compost_bin.scad>

$fn=45;

// Ground
color("DarkOliveGreen")
translate([-79, -97, 0])
linear_extrude(0.01)
square([128, 98]);

module fence_wall(length) {
  color("peru")
    linear_extrude(6)
    square([length, 0.25], center=true);
}

module fence_gate(width) {
  color("peru") 
  linear_extrude(6)
  scale(width)
  intersection() {
    square([1, 1]);
    circle(1);
  };
}

module rv_fence() {
  translate([24, 0, 0])
  union() {
    fence_wall(48);
    translate([-20, 0, 0])
    rotate([0, 0, -90])
    fence_gate(6);
    translate([-8, 0, 0])
    rotate([0, 0, 180])
    fence_gate(6);
  }
}

module pleasant_fence() {
  translate([48, -48, 0])
  rotate([0, 0, 90])
  fence_wall(96);
}

module back_fence() {
  translate([-15, -96, 0])
  fence_wall(126);
  translate([-28, -96, 0])
  rotate([0, 0, 90])
  fence_gate(4);
}

module frontier_fence() {
  translate([-78, -48, 0])
  rotate([0, 0, 90])
  fence_wall(96);
}

module office_fence() {
  translate([-62, 0, 0]) {
    fence_wall(32);
    translate([-4, 0, 0])
    rotate([0, 0, -90])
    fence_gate(4);
  }
}

module full_fence() {
  rv_fence();
  pleasant_fence();
  back_fence();
  frontier_fence();
  office_fence();
}

module house() {
  color("ghostwhite")
  linear_extrude(13)
  polygon([
  [0, -30],
  [-46, -30],
  [-46, 0],
  [0, 0]
  ]);
}

module back_deck() {
  color("dimgray")
  linear_extrude(4)
  translate([-31, -40, 0])
  square([15, 10]);
}

module side_stairs() {
  color("dimgray")
  linear_extrude(4)
  translate([-55, -15, 0])
  square([9, 4]);
}

module existing_yard() {
  full_fence();
  house();
  back_deck();
  side_stairs();
}
existing_yard();

/* 
 * A standard garden bade, made from 2x6 lumber.
 * Length is in feet.
*/
module garden_bed(length) {
  translate([2, -4, 0])
  rotate([0, 0, 90])
  scale(1 / (25.3 * 12))
  color("azure") {
    copy_mirror_y()
    rotate([0, 90, 0])
    translate([0, 25.3 * (24 - 0.75), 0])
    2x6_lumber(length);
    
    copy_mirror_x()
    translate([25.3 * (6 * length + 0.75), 0, 0])
    rotate([0, 90, 90])
    %2x6_lumber(4);
  }
}

module chicken_wire_fence(length) {
  rotate([0, -90, 0])
  %linear_extrude(0.1, center=true)
  square([4, length]);
}

module walled_garden() {
  aisle_width = 3;
  entrance_width = 6;
  edge_width = 1;
  
  fence_edge = edge_width + aisle_width;
  translate([48 - fence_edge, -fence_edge, 0]) {
  
  // Beds
  translate([-(4 + aisle_width/2), 0, 5.5/24]) {
  y_offset = aisle_width/2;
  copy_mirror_x() {
    // 1: long bed
    translate([y_offset, 0, 0])
    garden_bed(8);
    
    // 2: long bed
    translate([y_offset, -(8 + aisle_width), 0])
    garden_bed(8);
    
    // 3: short bed
    translate([y_offset, -(14 + 2*aisle_width), 0])
    garden_bed(4);
    
    // 4: short bed
    translate([y_offset, -(18 + 2*aisle_width + entrance_width), 0])
    garden_bed(4);
    
    // 5: long bed
    translate([y_offset, -(24 + 3*aisle_width + entrance_width), 0])
    garden_bed(8);
    
    // 6: long bed
    translate([y_offset, -(32 + 4*aisle_width + entrance_width), 0])
    garden_bed(8);
  }}}
  
  // Wire fence
  length = 6*aisle_width + 5*8 + entrance_width + edge_width;
  width = 3*aisle_width + 8 + edge_width;
  echo("length:", length, "width:", width);
  translate([48 - width, -length, 0]) {
    chicken_wire_fence(length);
    rotate([0, 0, -90])
    chicken_wire_fence(width);
  }
}
walled_garden();

// Compost bin
translate([28, -60, 0])
rotate([0, 0, 90])
scale(1/(25.4*12))
compost_bin(2);