$fn=180;

// Parameters
LIFT = 21; // Lift distance
T_WALL = 4; // Wall thickness
R_EDGE = 1.5; // Edge rounding radius
H_CHANNEL = 13.5; // Channel depth
L_CHANNEL = 30; // Channel straight length
R_CHANNEL = 22.34; // Channel curve radius
W_CHANNEL = 2.9;  // Channel width


module roundedSquare(width, height, radius) {
    translate([-width/2, -height/2, 0])
    union() {
    polygon([
        [0, radius],
        [radius, 0],
        [width - radius, 0],
        [width, radius],
        [width, height - radius],
        [width - radius, height],
        [radius, height],
        [0, height - radius]
    ]);
    translate([radius, radius, 0])
    circle(r=radius);
    translate([width - radius, radius, 0])
    circle(r=radius);
    translate([radius, height - radius, 0])
    circle(r=radius);
    translate([width - radius, height - radius, 0])
    circle(r=radius);
    }
}


module channelProfile() {
    width = W_CHANNEL + 2 * T_WALL;
    height = LIFT + H_CHANNEL;
    radius = R_EDGE;
    channel_left = (width - W_CHANNEL) / 2;
    channel_right = channel_left + W_CHANNEL;
    channel_bottom = height - H_CHANNEL;
    
    translate([-width/2, -height/2, 0])
    difference() {
    union() {
    // Base polygon
    polygon([
        [0, radius],
        [radius, 0],
        [width - radius, 0],
        [width, radius],
        [width, height - radius],
        [width - radius, height],
        [channel_right + radius, height],
        [channel_right, height - radius],
        [channel_right, channel_bottom + radius],
        [channel_right - radius, channel_bottom],
        [channel_left + radius, channel_bottom],
        [channel_left, channel_bottom + radius],
        [channel_left, height - radius],
        [channel_left - radius, height],
        [radius, height],
        [0, height - radius]
    ]);
    
    // Six convex edges
    translate([radius, radius, 0])
    circle(r=radius);
    translate([width - radius, radius, 0])
    circle(r=radius);
    translate([radius, height - radius, 0])
    circle(r=radius);
    translate([width - radius, height - radius, 0])
    circle(r=radius);
    translate([channel_left - radius, height - radius, 0])
    circle(r=radius);
    translate([channel_right + radius, height - radius, 0])
    circle(r=radius);
    }
    
    // Two concave edges
    translate([channel_left + radius, channel_bottom + radius, 0])
    circle(r=radius);
    translate([channel_right - radius, channel_bottom + radius, 0])
    circle(r=radius);
    }
}


module riserCurvedChannel() {
    rotate_extrude(angle=90)
    translate([R_CHANNEL, 0, 0])
    channelProfile();
}


module riserStraightChannels() {
    rotate([90, 0, 0])
    translate([R_CHANNEL, 0, 0])
    linear_extrude(L_CHANNEL)
    channelProfile();
    
    rotate([90, 0, -90])
    translate([-R_CHANNEL, 0, 0])
    linear_extrude(L_CHANNEL)
    channelProfile();
}


module riserCaps() {
    width = W_CHANNEL + 2 * T_WALL + 10;
    height = LIFT + H_CHANNEL + 10;
    
    translate([-L_CHANNEL, R_CHANNEL, 0])
    rotate([0, 0, 90])
    rotate_extrude(angle=180)
    intersection() {
    channelProfile();
    translate([0, -height/2, 0])
    square([width, height]);
    }
    
    translate([R_CHANNEL, -L_CHANNEL, 0])
    rotate([0, 0, 180])
    rotate_extrude(angle=180)
    intersection() {
    channelProfile();
    translate([0, -height/2, 0])
    square([width, height]);
    }
}


module riser() {
    riserCurvedChannel();
    riserStraightChannels();
    riserCaps();
}
riser();