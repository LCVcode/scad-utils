use <circular_fillet.scad>

$fn = 120;

module through_hole(hole_length, hole_radius, fillet_radius, void=1) {
    // Variable cleanup
    fillet_radius = abs(fillet_radius);
    hole_radius = abs(hole_radius);
    hole_length = max(hole_length, 2 * fillet_radius);
    
    // Main cylinder
    cylinder(h=hole_length, r=hole_radius, center=true);
    
    // Both fillets
    translate([0, 0, -hole_length / 2])
        circular_fillet(fillet_radius, hole_radius);
    cylinder(h=hole_length, r=hole_radius, center=true);
    mirror([0, 0, 1])
    translate([0, 0, -hole_length / 2])
        circular_fillet(fillet_radius, hole_radius);
    
    // Void space above and below the hole
    translate([0, 0, hole_length / 2])
    cylinder(h=void, r=hole_radius + fillet_radius);
    translate([0, 0, -hole_length / 2 - void])
    cylinder(h=void, r=hole_radius + fillet_radius);
}

through_hole(hole_length=1, fillet_radius=3, hole_radius=14.5);