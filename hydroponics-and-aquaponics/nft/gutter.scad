use <../../scad-utils/round-poly.scad>

$fn=60;

// Constants
CAP_HEIGHT = 59.4;
CAP_WIDTH = 80.5;
INLET_DIAMETER = 4.65;
CAP_RADIUS = 14.86;
CAP_LENGTH = 50;

// Parameters
WALL_THICKNESS = 2.25;
SPREADER_ANGLE = 6;

module _profile(height, width, radius) {
    union() {
    square([width-2*radius, height], center=true);
    square([width, height-2*radius], center=true);
    left = width/2 - radius;
    up = height/2 - radius;
    translate([left, up, 0])
        circle(radius);
    translate([left, -up, 0])
        circle(radius);
    translate([-left, up, 0])
        circle(radius);
    translate([-left, -up, 0])
        circle(radius);
    }
}

module gutter(length) {
    INNER_HEIGHT = 55.9;
    INNER_WIDTH = 77;
    OUTER_HEIGHT = 58.9;
    OUTER_WIDTH = 80;
    RADIUS = 13.36;
    
    radius_diff = (OUTER_WIDTH - INNER_WIDTH + OUTER_HEIGHT - INNER_HEIGHT) / 4;
    
    linear_extrude(length, center=true) 
    difference() {
        _profile(height=OUTER_HEIGHT, width=OUTER_WIDTH, radius=RADIUS);
        _profile(height=INNER_HEIGHT, width=INNER_WIDTH, radius=RADIUS - radius_diff);
    }
}

module gutterCapCavity(height, width, radius, length, thickness) {
  translate([-CAP_LENGTH/2 + thickness, 0, 0])
  rotate([90, 0, 90])
  translate([0, 0, -thickness/2])
  linear_extrude(length, center=true)
      _profile(height=height, width=width, radius=radius);
}

module gutterCap(thickness) {    
    difference() {
    translate([-CAP_LENGTH/2 + thickness, 0, 0])
    rotate([90, 0, 90])
    linear_extrude(CAP_LENGTH, center=true)
    _profile(height=CAP_HEIGHT + 2 * thickness, width=CAP_WIDTH + 2 * thickness, radius=CAP_RADIUS + thickness);
    gutterCapCavity(CAP_HEIGHT, CAP_WIDTH, CAP_RADIUS, CAP_LENGTH, thickness);
    }    
}

module spreaderBlade(width, length) {
    r = (length ^ 2 + width ^ 2) / (4 * width);
    x = (length ^ 2 - width ^ 2) / (4 * width);
    
    intersection() {
        translate([0, x, 0])
        circle(r);
        translate([0, -x, 0])
        circle(r);
    }
}

module flowSpreader(tierCount) {
    // Parameters
    MIN_BLADE_WIDTH = 2;
    MIN_BLADE_LENGTH = 7.5;
    BLADE_HEIGHT = 5;
    BLADE_WIDTH_SCALING = 15;
    BLADE_LENGTH_SCALING = 50;
    TIER_STRIDE = 15;
    FLOOR_THICKNESS = 2.5;
    
    // Constants
    width = CAP_WIDTH - 10;
    floorWidth = CAP_WIDTH - 5;
    floorLength = (tierCount+2) * TIER_STRIDE + BLADE_LENGTH_SCALING / 1.5;
    
    // Global translation
    translate([-BLADE_LENGTH_SCALING/1.75, 0, 0]) {
    
    linear_extrude(BLADE_HEIGHT) {
    // Fractal portion
    for (i = [0:tierCount]) {
        bladeWidth = max(MIN_BLADE_WIDTH, BLADE_WIDTH_SCALING/(i+1));
        bladeLength = max(MIN_BLADE_LENGTH, BLADE_LENGTH_SCALING/(i+1));
        
        translate([-i*TIER_STRIDE, width/2 - width/(2^(i+1)), 0])
        for (j = [0:2^i-1]) {
            translate([0, -j * width/(2^(i)), 0])
            spreaderBlade(width=bladeWidth, length=bladeLength);
        }
    }
    
    // Rake portion
    bladeWidth = max(MIN_BLADE_WIDTH, BLADE_WIDTH_SCALING/(tierCount+1));
    bladeLength = max(MIN_BLADE_LENGTH, BLADE_LENGTH_SCALING/(tierCount+1));
    for (j = [0:2^tierCount-2]) {
        translate([-(tierCount+1) * TIER_STRIDE, width/2 - (j+1) * width/(2^(tierCount)), 0])
        spreaderBlade(width=bladeWidth, length=bladeLength);
    }
    for (j = [0:2^tierCount-1]) {
        translate([-(tierCount+2) * TIER_STRIDE, width/2 - (j+0.5) * width/(2^(tierCount)), 0])
        spreaderBlade(width=bladeWidth, length=bladeLength);
    }}}
    
    // Floor
    translate([0, 0, FLOOR_THICKNESS / 2])
    rotate([90, 0, -90])
    linear_extrude(floorLength) {
        difference() {
            square([floorWidth, FLOOR_THICKNESS + BLADE_HEIGHT], center=true);
            translate([0, FLOOR_THICKNESS / 2 + 0.01, 0])
            square([floorWidth - 5, BLADE_HEIGHT], center=true);
        }
    }
}

module inletHole() {
    translate([0, 0, INLET_DIAMETER])
    rotate([0, 90, 0])
    linear_extrude(4 * WALL_THICKNESS, center=true)
    circle(INLET_DIAMETER / 2);
}

module inletFunnelBend() {
    translate([WALL_THICKNESS, 0, 2 * WALL_THICKNESS + INLET_DIAMETER + 0.1])
    rotate([-90, 0, 0])
    rotate_extrude(angle=90)
    translate([WALL_THICKNESS + INLET_DIAMETER / 2, 0, 0])
    difference() {
        circle(INLET_DIAMETER / 2 + WALL_THICKNESS);
        circle(INLET_DIAMETER / 2);
    }
}

module inletFunnel() {
    
    translate([WALL_THICKNESS + INLET_DIAMETER, 0, 2 * WALL_THICKNESS + INLET_DIAMETER])
    rotate_extrude(angle=360)
    translate([-INLET_DIAMETER / 2 - WALL_THICKNESS, 0, 0])
    polygon([
        [0, 0],
        [-0.75*WALL_THICKNESS, CAP_HEIGHT / 2],
        [0, CAP_HEIGHT / 2],
        [WALL_THICKNESS, 0],
    ]);
}

module inflowCap(angle) {
    difference() {
        gutterCap(thickness=WALL_THICKNESS);
        inletHole();
    }
    inletFunnelBend();
    inletFunnel();
    translate([2, 0, 0])
    rotate([0, -SPREADER_ANGLE, 0])
    flowSpreader(tierCount=3);
}
// inflowCap(30);

module outflowFunnel() {
}

module outflowPin(diameter, length, cap_width, cap_depth, tolerance, curvature) {
  
  r = 2;  // Radius used for round_poly
  iota = 0.001; // A small value used to prevent radii overlaps in round_poly
  
  d = max(diameter, 2*r + iota);      // Pin diameter
  l = max(length, 2*r + iota);        // Pin length
  t = max(cap_depth, 2*r + iota);     // Cap thickness
  w = max(cap_width/2, d/2 + 2*r + iota); // Cap width
  
  rotate_extrude()
  round_poly([
    [  0,   0, 0],
    [d/2,   0, r],
    [d/2,   l, 1],
    [  w,   l, r],
    [  w, l+t, r],
    [  0, l+t, 0],
  ]);
}

module outflowDrain(inflow_od, outflow_od, length) {
  t = 2; // Thickness
  l = max(length, t);
  r = t/2 - 0.001;
  
  theta = atan2(length, inflow_od - outflow_od);
  x = outflow_od/2;
  dx = cos(theta);
  dy = sin(theta);

  rotate_extrude()
  round_poly([
    [x, 0, r],
    [x + t*dy, -t*dx, r],
    [x + t*dy + l*dx, -t*dx + l*dy, r],
    [x + l*dx, l*dy, r],
  ]);
}

module positionedDrain(inflow_od, outflow_od, length) {
  translate([length/2, 0, -CAP_HEIGHT/2 - length/2])
  rotate([0, -45, 0])
  outflowDrain(inflow_od=inflow_od, outflow_od=outflow_od, length=length);
}

module outflowCap() {
  // Local parameters
  pin_diameter = 12;
  pin_length = 25;
  pin_cap_width = 15;
  pin_cap_thickness = 8.5;
  pin_tolerance = 0.25;
  drain_length = 65;
  drain_in_od = 12;
  drain_out_od = 7.5;
  
  // Gutter cap with pin hole
  union() {
  difference() {
    gutterCap(thickness=WALL_THICKNESS);
    
    translate([-25, 0, 0])
    linear_extrude(CAP_HEIGHT)
    circle(d=pin_diameter + 2*pin_tolerance);
    
    hull()
    positionedDrain(inflow_od=drain_in_od, outflow_od=drain_out_od, length=drain_length);
  }
  
  // Pin
  translate([-25, 0, CAP_HEIGHT/2 - pin_length + 4])
  !outflowPin(pin_diameter, pin_length, pin_cap_width, pin_cap_thickness, pin_tolerance);
  
  
  // Drain
  difference() {
    positionedDrain(inflow_od=drain_in_od, outflow_od=drain_out_od, length=drain_length);
    gutterCapCavity(CAP_HEIGHT, CAP_WIDTH, CAP_RADIUS, CAP_LENGTH, WALL_THICKNESS);
  }
  }
}
outflowCap();