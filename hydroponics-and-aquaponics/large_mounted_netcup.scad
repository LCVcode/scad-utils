use <../scad-utils/round-poly.scad>
use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 12 : 64;

// Cup Parameters
CUP_OD = inches(2.35);
CUP_THICKNESS = 5;
ABOVE_LID_HEIGHT = inches(4);
BELOW_LID_DEPTH = inches(2.5);
TAPER_DIAMETER = inches(1.4);

// Hole Parameters
// Bottom holes
HOLE_ID = 6.5;
// Side holes
DIAMOND_WIDTH = 12;
DIAMOND_RADIUS = 2;

// Support parameters
SUP_HEIGHT = ABOVE_LID_HEIGHT - inches(1);
SUP_WIDTH = ABOVE_LID_HEIGHT/2.5;
SUP_THICKNESS = inches(0.5);
SUP_RADIUS = inches(0.2);

// Constants
TOL = 0.2;
CUP_ID = CUP_OD - 2*CUP_THICKNESS;
CUP_RADIUS = CUP_ID/2;
TAPER_RADIUS = TAPER_DIAMETER/2;

// Asserts
assert(SUP_RADIUS < SUP_THICKNESS/2 - TOL);

module main_cup() {
    rotate_extrude()
    round_poly([
        [0, -BELOW_LID_DEPTH, 0],
        [TAPER_RADIUS, -BELOW_LID_DEPTH, TAPER_RADIUS],
        [CUP_RADIUS, -CUP_THICKNESS, CUP_RADIUS],
        [CUP_RADIUS, ABOVE_LID_HEIGHT, CUP_THICKNESS/2 - 0.01],
        [CUP_RADIUS + CUP_THICKNESS, ABOVE_LID_HEIGHT, CUP_THICKNESS/2 - 0.01],
        [CUP_RADIUS + CUP_THICKNESS, -CUP_THICKNESS, CUP_RADIUS + CUP_THICKNESS],
        [TAPER_RADIUS + CUP_THICKNESS, -BELOW_LID_DEPTH - CUP_THICKNESS, TAPER_RADIUS + CUP_THICKNESS],
        [0, -BELOW_LID_DEPTH - CUP_THICKNESS, 0],
    ], resolution=$preview ? 30 : 8);
}

module bottom_holes() {
    for (v=[[1, 0], [6, HOLE_ID + 2], [12, 2*(HOLE_ID + 2)]]) {
        rotate_array(v[0]) translate([v[1], 0, 0]) rotate([180, 0, 0]) cylinder(h=inches(10), r=HOLE_ID/2);
    }
}

module side_holes(hole_count, layer_count) {
    x = DIAMOND_WIDTH/2;

    for (j=[0:layer_count-1]) { translate([0, 0, -1.8*j*DIAMOND_WIDTH])
    for (i=[0, 1]) {
        rotate([0, 0, 360/(2*hole_count) * i]) translate([0, 0, -(i+0.5)*0.9*DIAMOND_WIDTH]) rotate_array(hole_count) rotate([90, 0, 0]) linear_extrude(CUP_ID)
        round_poly([
            [0,  x, DIAMOND_RADIUS],
            [ x, 0, DIAMOND_RADIUS],
            [0, -x, DIAMOND_RADIUS],
            [-x, 0, DIAMOND_RADIUS],
        ], $preview ? 24 : 8);
    }}
}

module screw_negative() {
    shaft_diameter = 4.1;
    head_diameter = 7.65;

    color("palegreen", 0.252) scale(1.075) union() {
        cylinder(r=head_diameter/2 + TOL, h=inches(24));
        cylinder(r=shaft_diameter/2 + TOL, h=inches(48), center=true);
    }
}

module support() {
    theta = atan2(SUP_WIDTH, SUP_HEIGHT);
    r = sqrt(SUP_HEIGHT^2 + SUP_WIDTH^2) / (2 * sin(theta));
    
    difference() {
    rotate([0, 90, 0]) translate([-SUP_HEIGHT, 0, 0])
    difference() {
    linear_extrude(SUP_THICKNESS, center=true)
    square([SUP_HEIGHT, SUP_WIDTH]);
    translate([0, r, 0]) rotate_extrude() copy_mirror_y()
    round_poly([
        [-r, 0, 0],
        [-r, SUP_THICKNESS/2, SUP_RADIUS],
        [-r - SUP_RADIUS - TOL, SUP_THICKNESS/2, 0],
        [-r -SUP_RADIUS - TOL, SUP_THICKNESS/2 + TOL, 0],
        [0, SUP_THICKNESS/2 + TOL, 0],
        [0, 0, 0],
    ], resolution=$preview ? 24 : 8);
    }
    
    translate([0, SUP_WIDTH - SUP_RADIUS - 10, 5])
    screw_negative();
    }
}

module net_cup() {
  difference() {
      main_cup();
      bottom_holes();
      side_holes(hole_count=12, layer_count=2);
  }

  copy_mirror_y() copy_mirror_x() rotate([0, 0, 20])
  translate([0, CUP_RADIUS + CUP_THICKNESS/2, 0]) support();
}

// This is an insert to the net cup, which effectively reduces the size of the holes.
// Useful when using a fine grow medium, which would pass through the normal holes.
module fine_mesh_insert() {
  t = 0.5;        // tolerance
  thickness = 4;  // insert thickness
  d = 3.5;        // hole diameter
  // Fine mesh insert profile
  path = [
    [CUP_RADIUS - t - thickness, - CUP_RADIUS + thickness, (CUP_RADIUS - thickness) / 2 - t],
    [0, - CUP_RADIUS + thickness, 0],
    [0, - CUP_RADIUS, 0],
    [CUP_RADIUS - t, - CUP_RADIUS, CUP_RADIUS / 2 - t],
    [CUP_RADIUS - t, ABOVE_LID_HEIGHT, 0],
    [CUP_RADIUS - t, 0.9 * ABOVE_LID_HEIGHT, 0],
    [CUP_RADIUS - thickness - t, 0.9 * ABOVE_LID_HEIGHT, thickness / 2 - t],
  ];
  
  difference() {
    rotate_extrude() round_poly(path);
    
    for (ring = [[0, 1, 0], [1.3*d, 5, 0], [2.5*d, 10, 18], [3.7*d, 15, 0], [CUP_RADIUS - d - thickness, 20, 0]]) {
      step = 360 / ring[1];
      for (i = [0:ring[1]-1]) {
        rotate([0, 0, ring[2]]) rotate_array(ring[1]) translate([ring[0], 0, 0])
        cylinder(d=d, h=100, center=true);
      }
    }
  };
}
fine_mesh_insert();