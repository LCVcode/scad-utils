use <../../utils/circles.scad>
use <../../utils/pvc.scad>

$fn=60;

INCH_TO_MM = 25.4;

ball_radius = 24;
pillar_radius = 3;
pillar_spacing = 9;

module bioBallPillars() {
    
    union() {
    for (j=[-ball_radius:pillar_spacing:ball_radius]) {
    for (i=[-ball_radius:pillar_spacing:ball_radius]) {
        translate([i, j, 0])
        cylinder(r=pillar_radius, h=ball_radius * 2, center=true);
    }}}
}

module bioBallDisk() {
    cylinder(r=ball_radius, h=3, center=true);
}

module bioBall() {
    intersection() {
        sphere(r=ball_radius);
        union() {
            bioBallPillars();
            bioBallDisk();
    }}
}

*bioBall();

module pastaFilter() {
    wall_thickness = 2;
    inner_diameter = 17;
    height = 17;
    finger_length = 3;
    finger_width = 2;
    finger_count = 12;
    
    inner_radius = inner_diameter / 2;
    angle = 360 / finger_count;
    
    linear_extrude(height, center=true)
    union() {
    ring(outer_radius=inner_radius + wall_thickness, inner_radius=inner_radius);
    square([wall_thickness, inner_diameter], center=true);
    square([inner_diameter, wall_thickness], center=true);
    circle(wall_thickness * 1.5, center=true);
    for (i = [0:finger_count - 1]) {
        rotate(a=i * angle, v=[0, 0, 1])
        translate([inner_radius + wall_thickness + finger_length / 2 - 1, 0, 0])
        square([finger_length, finger_width], center=true);
    }}
}

module crimpedCircle(resolution, amplitude, frequency) {
    step = 360 / resolution;
    y_offset = 1 - (amplitude / 2);
    
    points = [
        for (a = [0:step:360]) 
            [cos(a) * (amplitude * cos(frequency*a) + y_offset), 
             sin(a) * (amplitude * cos(frequency*a) + y_offset)]
    ];
    polygon(points);
}

module wavyPastaFilter() {
    wall_thickness = 2;
    outer_scale = 20;
    inner_scale = 15.5;
    height = 17;
    resolution = 540;

    linear_extrude(height, center=true)
    difference() {
        scale(outer_scale)
        crimpedCircle(resolution, 0.2, 12);
        scale(inner_scale)
        crimpedCircle(resolution, 0.15, 12);
    }
    
    linear_extrude(height, center=true)
    difference() {
        scale(inner_scale * 0.8)
        rotate([0, 0, 15])
        crimpedCircle(resolution, 0.25, 6);
        scale(inner_scale * 0.6)
        rotate([0, 0, 15])
        crimpedCircle(resolution, 0.25, 6);
    }
    
    linear_extrude(height, center=true)
    difference() {
        scale(inner_scale * 0.4)
        rotate([0, 0, -15])
        crimpedCircle(resolution, 0.25, 3);
        scale(inner_scale * 0.275)
        rotate([0, 0, -15])
        crimpedCircle(resolution, 0.25, 3);
    }}

*wavyPastaFilter();
*pastaFilter();
    
module puzzlePieceFilter() {
    resolution = 360;
    amplitude = 0.4;
    frequency = 12;
    outer_diameter = 23;
    height = 17;
    limbs = 7;
    
    step = 360 / resolution;
    y_offset = 1 - (amplitude / 2);
    
    polar_points = [
        for (a = [0:step:360]) [
            y_offset + amplitude * (cos(limbs * a)),
            a + (1.5 * limbs) * sin(2 * limbs * a)
    ]];
    points = [
        for (i = [0:resolution - 1]) 
            [polar_points[i][0] * cos(polar_points[i][1]),
             polar_points[i][0] * sin(polar_points[i][1])]
    ];

    linear_extrude(height, center=true)
    scale(outer_diameter / 2)
    polygon(points);
}
*puzzlePieceFilter();

module meshBell(radius, height, thickness) {    
    difference() {
    union() {
        sphere(radius);
        cylinder(h=height-radius, r=radius);
    }
    union() {
        sphere(radius-thickness);
        cylinder(h=height-radius+thickness, r=radius-thickness);
    }}
}

module meshHoles(height, radius, holeCount, layerCount) {
    // Constants
    angle = 360 / holeCount;
    step = height / (layerCount - 1);
    
    for (j=[0:1:layerCount]) {
        translate([0, 0, j * step])
        rotate([0, 0, j*angle/2])
        for (i=[0:angle:360]) {
            rotate([90, 0, i])
            cylinder(h=100, r=radius);
        }
    }
}

module biofilterUpliftPipeMesh() {
    // Parameters
    stemLength=25;
    wallThickness=5;
    meshRadius=25;
    meshHeight=100;
    meshThickness=6;
    
    // Constants
    
    // Stem
    translate([0, 0, -stemLength/2])
    3_4_connector_outer(length=stemLength/INCH_TO_MM, thickness=wallThickness/INCH_TO_MM);
    
    // Mesh
    difference() {
        translate([0, 0, meshRadius])
        meshBell(radius=meshRadius, height=meshHeight, thickness=meshThickness);
        
        translate([0, 0, meshRadius])
        meshHoles(height=50, radius=4, holeCount=12, layerCount=5);
    }
}
*biofilterUpliftPipeMesh();

module koiOuterWall(height, diameter, thickness, count, amplitude) {
    outerPoints = [
        for (a = [0:1:360]) 
            [cos(a) * (amplitude * cos(count*a) + diameter/2), 
             sin(a) * (amplitude * cos(count*a) + diameter/2)]
    ];
    innerPoints = [
        for (a = [0:1:360]) 
            [cos(a) * (amplitude * cos(count*a) + diameter/2 - thickness), 
             sin(a) * (amplitude * cos(count*a) + diameter/2 - thickness)]
    ];
        
    linear_extrude(height)
    difference() {
        polygon(outerPoints);
        polygon(innerPoints);
    }
}

module koiSpokes(height, diameter, count, thickness) {
    angle=360/count;
    for (i=[0:count-1]) {
        rotate([90, 0, i*angle])
        linear_extrude(thickness, center=true)
        square([diameter/2 - 0.25, height]);
    }
}

module koiBioMedia() {
    // Parameters
    height=16;
    diameter=20;
    holeDiameter=4;
    wallThickness=1;
    spokeCount=5;
    rippleCount=20;
    rippleAmplitude=0.5;
    
    // Variables
    radialHoleWidth=(diameter-holeDiameter)/2 - 2*wallThickness;
    
    difference() {
    union() {
    // Outer wall
    koiOuterWall(height, diameter, wallThickness, rippleCount, rippleAmplitude);
        
    // Spokes
    koiSpokes(height, diameter, spokeCount, wallThickness);
    
    // Central cylinder
    cylinder(h=height, r=holeDiameter/2 + wallThickness);
    }
    
    // Central cavity
    translate([0, 0, -1])
    cylinder(h=height+2, r=holeDiameter/2);
    }
}
koiBioMedia();