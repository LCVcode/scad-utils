$fn=45;

// Packet parameters
PACKET_WIDTH = 82;
PACKET_HEIGHT = 116;

// Holder box parameters
TOLERANCE = 0.25;
PACKET_HEIGHT_ABOVE_HOLDER = 25;
HOLDER_WALL_THICKNESS = 4.5;
HOLDER_LENGTH = 150;

// Holder hole parameters
FRONT_HOLE_HEIGHT = 100;
FRONT_HOLE_WIDTH = 7;
FRONT_HOLE_COUNT = 6;
FRONT_HOLE_SPACING = 6;
SIDE_HOLE_HEIGHT = 40;
SIDE_HOLE_WIDTH = 7;
SIDE_HOLE_COUNT = 11;
SIDE_HOLE_SPACING = 6;

// Divider parameters
NOTCH_COUNT = 10;
NOTCH_WIDTH = 4;
NOTCH_DEPTH = 25.3/2;

// Constrained parameters
HOLDER_HEIGHT = PACKET_HEIGHT - PACKET_HEIGHT_ABOVE_HOLDER + HOLDER_WALL_THICKNESS;

module padded_line(x, y, radius, center) {
    theta = atan2(y, x);
    dx = cos(theta) * radius;
    dy = sin(theta) * radius;
        
    center_x = center ? -x / 2 : 0;
    center_y = center ? -y / 2 : 0;
    
    x1 = -dy;
    y1 =  dx;
    x2 =  dy;
    y2 = -dx;
    x3 = -dy + x;
    y3 =  dx + y;
    x4 =  dy + x;
    y4 = -dx + y;
    
    translate([center_x, center_y, 0]) { union() {
        // Create a polygon representing the padded line
        polygon([[x1, y1], [x2, y2], [x4, y4], [x3, y3]]);
        
        // Create rounded ends with circles
        circle(abs(radius));
        translate([x, y]) circle(abs(radius));
    }}
}

module holder_base_shape() {
    // Calculate local parameters
    holder_width = PACKET_WIDTH + 2*(HOLDER_WALL_THICKNESS + TOLERANCE);
    holder_length = HOLDER_LENGTH + 2*(HOLDER_WALL_THICKNESS + TOLERANCE);
    cavity_height = PACKET_HEIGHT;
    cavity_width = PACKET_WIDTH + 2*TOLERANCE;
    cavity_length = HOLDER_LENGTH;
    
    difference() {
        translate([0, 0, -HOLDER_WALL_THICKNESS])
        linear_extrude(HOLDER_HEIGHT)
        square([holder_length, holder_width], center=true);
        linear_extrude(cavity_height)
        square([cavity_length, cavity_width], center=true);
    }
}

module holder_front_back_holes() {    
    // Local variables
    max_hole_height = HOLDER_HEIGHT - 25;
    height = min(FRONT_HOLE_HEIGHT, max_hole_height);
    step = FRONT_HOLE_WIDTH + FRONT_HOLE_SPACING;
    
    translate([0, -step*(FRONT_HOLE_COUNT-1)/2, 0])
    translate([0, 0, HOLDER_HEIGHT/2 - TOLERANCE-HOLDER_WALL_THICKNESS])
    for (i=[0:FRONT_HOLE_COUNT-1]) {
        translate([0, step*i, 0])
        rotate([90, 0, 90])
        linear_extrude(2*HOLDER_LENGTH, center=true)
        padded_line(0, height, FRONT_HOLE_WIDTH/2, true);
    }
}

module holder_side_holes() {
    // Local variables
    max_hole_height = HOLDER_HEIGHT - 25;
    height = min(SIDE_HOLE_HEIGHT, max_hole_height);
    step = SIDE_HOLE_WIDTH + SIDE_HOLE_SPACING; 
    
    rotate([0, 0, 90])
    translate([0, -step*(SIDE_HOLE_COUNT-1)/2, 0])
    translate([0, 0, HOLDER_HEIGHT/2 - TOLERANCE-HOLDER_WALL_THICKNESS])
    for (i=[0:SIDE_HOLE_COUNT-1]) {
        translate([0, step*i, 0])
        rotate([90, 0, 90])
        linear_extrude(2*HOLDER_LENGTH, center=true)
        padded_line(0, height, SIDE_HOLE_WIDTH/2, true);
    }
}

module truncated_prism(width, length, thickness) {
    rotate([90, 0, 0])
    linear_extrude(length, center=true)
    union() {
    polygon([
        [-1, 0],
        [width/2 - thickness, 0],
        [width/2, thickness],
        [-1, thickness],
    ]);
    mirror([1, 0, 0])
    polygon([
        [-1, 0],
        [width/2 - thickness, 0],
        [width/2, thickness],
        [-1, thickness],
    ]);}
}

module edge_chamfer() {
    // Calculate local parameters
    holder_width = PACKET_WIDTH + 2*(HOLDER_WALL_THICKNESS + TOLERANCE);
    holder_length = HOLDER_LENGTH + 2*(HOLDER_WALL_THICKNESS + TOLERANCE);

    translate([0, 0, HOLDER_HEIGHT - HOLDER_WALL_THICKNESS * 1.5])
    intersection() {
        truncated_prism(holder_length, holder_width, HOLDER_WALL_THICKNESS);
        rotate([0, 0, 90])
        truncated_prism(holder_width, holder_length, HOLDER_WALL_THICKNESS);
    }
}

module divider_notches() {
    // Local variables
    notch_step = HOLDER_LENGTH / (NOTCH_COUNT + 1);
    holder_width = PACKET_WIDTH + 2*(HOLDER_WALL_THICKNESS + TOLERANCE);
    
    translate([
        -notch_step*(NOTCH_COUNT-1)/2,
        0,
        HOLDER_HEIGHT - NOTCH_DEPTH + HOLDER_WALL_THICKNESS/2])
    rotate([90, 0, 0])
    union() {
    for (i=[0:NOTCH_COUNT-1]) {
        translate([i*notch_step, 0, 0])
        linear_extrude(holder_width - HOLDER_WALL_THICKNESS, center=true)
        padded_line(0, NOTCH_DEPTH, NOTCH_WIDTH/2, center=true);
    }}
}

difference() {
holder_base_shape();
holder_front_back_holes();
holder_side_holes();
edge_chamfer();
divider_notches();
}