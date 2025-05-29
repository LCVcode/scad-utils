$fn=100;

module circular_fillet(fillet_radius, pipe_radius) {
    rotate_extrude()
    translate([pipe_radius, 0, 0])
    scale(fillet_radius) {
        union() {
        difference() {
            square(1);
            translate([1, 1, 0]) circle(1);
        }
        translate([0, -0.25, 0]) square([1, 0.25]);
        translate([-0.25, -0.25, 0]) square([0.25, 1.25]);
        }
    };
}

circular_fillet(12, -25.5*5);
