$fn=90;

module ring(outer_radius, inner_radius, center=true) {
    difference() {
        circle(r=outer_radius, center=center);
        circle(r=inner_radius, center=center);
    }
}

module torus(large_radius, small_radius, center=true) {
    rotate_extrude()
    translate([large_radius, 0, 0])
    circle(r=small_radius, center=center);
}