use <../scad-utils/modifiers.scad>
use <../scad-utils/round-poly.scad>
$fn = $preview ? 16 : 120;

// Socket parameters
BALL_RADIUS = 20;
SOCKET_THICKNESS = 6;
CHOKE_DOWN = 0.75;
ESCAPE_RADIUS = 8;

// Mister parameters
MISTER_HEIGHT = 35;
MISTER_DIAMETER = 46.5;

// Cup parameters
DEPTH_BELOW_WATER_SURFACE = 30;
CUP_THICKNESS = 7;
HOLE_COUNT = 3;
HOLE_RATIO = 0.3;

// A round socket to hold a ping pong ball
//  inner_radius: should be slightly larger than the radius of the ping pong ball
//  outer_radius: determines the socket wall thickness
//  choke_radius: is the radius of the hole at the bottom of the socket, which the ball is pushed through
//  escape_radius: is the radius of the hole at the top of the socket, to push the ball out
module ball_socket(inner_radius, outer_radius, choke_radius, escape_radius) {

  ir = min(inner_radius, outer_radius);
  or = max(inner_radius, outer_radius);
  mr = (or + ir) / 2;
  theta_lo = acos(choke_radius / ir);
  theta_hi = acos(escape_radius / ir);
  
  rotate_extrude() {
  difference() {
    // Main socket shell
    circle(r=or);
    circle(r=ir);
    polygon([
      [  0,  or],
      [-or,  or],
      [-or, -or],
      [  0, -or],
    ]);
    
    // Choke opening
    polygon([
      [0, 0],
      [ or * cos(theta_lo), -or * sin(theta_lo)],
      [ or, -or],
      [-or, -or],
      [-or * cos(theta_lo), -or * sin(theta_lo)],
    ]);
    
    // Escape opening
    polygon([
      [0, 0],
      [ or * cos(theta_hi), or * sin(theta_hi)],
      [ or, or],
      [-or, or],
      [-or * cos(theta_hi), or * sin(theta_hi)],
    ]);
  }
  for (theta=[-theta_lo, theta_hi]) {
    translate([mr*cos(theta), mr*sin(theta), 0]) circle(d=or-ir);
  }
}
};

// The cup that holds the mister below the water
//  inner_radius: radius of the mister housing
//  thickness: thickness of the cup wall
//  height: internal height of the cup (not necessarily relative to water level)
//  ratio: the portion of the cup wall that should be open for water flow [0.1:0.9]
//  hole_count: the number of holes in the cup [2:inf)
module cup(inner_radius, thickness, height, ratio, hole_count) {
  theta = 360 * ratio / hole_count;
  r = 2*(inner_radius + thickness);
  echo(theta);
  
  difference() {
    // Outer shell
    translate([0, 0, -thickness])
    cylinder(h=height+thickness, r=inner_radius+2*thickness);
    
    // Inner volume
    cylinder(h=height+0.01, r=inner_radius);
    
    // Holes for water flow
    rotate([0, 0, 60])
    rotate_array(hole_count)
    translate([0, 0, -2*thickness])
    linear_extrude(height)
    polygon([
      [0, 0],
      [r, r * sin( theta/2)],
      [r, r * sin(-theta/2)],
    ]);
    
    // Hole in the center
    translate([0, 0, -2*thickness])
    cylinder(r=0.8*inner_radius, h=height);
  }
}

// The cup that holds the mister below the water
//  inner_radius: radius of the mister housing
//  thickness: thickness of the cup wall
//  height: internal height of the cup (not necessarily relative to water level)
//  ratio: the portion of the cup wall that should be open for water flow [0.1:0.9]
//  hole_count: the number of holes in the cup [2:inf)
module cup2(inner_radius, thickness, height, ratio, hole_count) {
  
  x1 = max(inner_radius - 5, inner_radius/2); // Radius of bottom hole
  x2 = inner_radius;                          // Radius of inner wall
  x3 = x2 + thickness;              // Radius of outer wall
  
  y1 = 0;                                     // Bottom of the profile
  y2 = thickness;                             // Height of the bottom lip
  y3 = y2 + height;                           // Height of the top of the cup
  
  theta = 360 * ratio / hole_count;
  r = 2*(inner_radius + thickness);
  
  difference() {
    // Cup profile
    rotate_extrude()
    round_poly([
    [x1, y1, thickness/2 - 0.1],
    [x1, y2, thickness/4 - 0.1],
    [x2, y2, 0],
    [x2, y3, thickness - 0.1],
    [x3, y3, 0],
    [x3, y1, thickness - 0.1],
    ]);
    
    // Holes for water flow
    rotate([0, 0, 60])
    rotate_array(hole_count)
    translate([0, 0, -2*thickness])
    linear_extrude(height)
    polygon([
      [0, 0],
      [r, r * sin( theta/2)],
      [r, r * sin(-theta/2)],
    ]);
    
    // Hole in the center
    translate([0, 0, -2*thickness])
    cylinder(r=0.8*inner_radius, h=height);
  }
}

// The full mister floater
module mister_floater() {
  cup2(MISTER_DIAMETER/2 + 1.1, CUP_THICKNESS, DEPTH_BELOW_WATER_SURFACE + MISTER_HEIGHT, HOLE_RATIO, HOLE_COUNT);
  
  rotate_array(3)
  translate([
    BALL_RADIUS + MISTER_DIAMETER/2 + CUP_THICKNESS/2 + SOCKET_THICKNESS,
    0,
    MISTER_HEIGHT + DEPTH_BELOW_WATER_SURFACE
  ])
  ball_socket(
    BALL_RADIUS + 0.5, 
    BALL_RADIUS + SOCKET_THICKNESS, 
    BALL_RADIUS + 0.5 - CHOKE_DOWN, 
    ESCAPE_RADIUS
  );
}
mister_floater();

// Insert to raise the mister
module riser() {
  x = 5;
  y = 19.5/2;
  r = min((x - 1) / 2, 2);
  rotate_extrude()
  translate([MISTER_DIAMETER/2, 0, 0])
  round_poly([
  [ 0,  y, r],
  [ 0, -y, r],
  [-x, -y, r],
  [-x,  y, r],
  ]);
}
!riser();