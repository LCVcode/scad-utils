use <round-poly.scad>

$fn = $preview ? 15 : 180; 

support_thickness = 4;

module support_nub() {
    rotate_extrude()
    round_poly([
        [0, 0, 0],
        [support_thickness/2, 0, 0],
        [0, support_thickness, 0]
    ]);
}

module triangle_support(width, height) {
    rotate([90, 0, 0]) {
        // Main triangle
        linear_extrude(support_thickness, center=true)
        round_poly([
            [    0,      0, 1],
            [width, height, 1],
            [width,      0, 9],
        ]);

        // CaLculations for nubs
        length = sqrt(width^2 + height^2);
        count = floor((length-support_thickness) / support_thickness);
        
        theta = atan2(height, width);
        x_step = cos(theta) * support_thickness;
        y_step = sin(theta) * support_thickness;

        // The nubs
        translate([x_step * cos(theta), y_step * sin(theta), 0])
        for (i=[0:count-1]) {
            translate([i*x_step, i*y_step, 0])
            rotate([-90, 0, theta])
            support_nub();
        }
    }
}

module support_tester() {
    theta = 20;
    length = 45;
    height = 10;
    width = 25;

    rotate([0, -theta, 0]) 
    linear_extrude(height)
    translate([0, -width/2, 0])
    square([length, width]);

    s_width = cos(theta) * length;
    s_height = sin(theta) * length;

    triangle_support(height=s_height, width=s_width);
}
support_tester();