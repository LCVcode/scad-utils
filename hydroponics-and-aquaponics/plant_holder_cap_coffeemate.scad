use <../utils/rounded_throughhole.scad>
use <../utils/circular_fillet.scad>

$fn=180;

module _drain_holes (radius, spacing, fillet, length, n=4) {
    // Variable cleanup
    n = round(n);
    step = 360 / n;
    
    // Create holes
    for (r =[0:n])
        translate([0, 0, -length/2])
        rotate([0, 0, r * step])
        translate([spacing, 0, 0])
        through_hole(hole_length=length, hole_radius=radius, fillet_radius=fillet);
}

module _cap_body (w_out, w_in, h_out, h_in, h_lip, w_lip) {
    difference() {
        // Base cap
        rotate_extrude()
        polygon([
            [0, 0], 
            [w_out - w_lip, 0], 
            [w_out - w_lip, h_lip],
            [w_out, h_lip],
            [w_out, h_lip - h_out],
            [w_in, h_lip - h_out],
            [w_in, -h_in],
            [0, -h_in]]);
        
        // Lip fillets
        translate([0, 0, h_lip])
            circular_fillet(fillet_radius=-w_lip/2, pipe_radius=w_out);
        translate([0, 0, h_lip]) rotate([180, 0, 0])
            circular_fillet(fillet_radius=w_lip/2, pipe_radius=w_out - w_lip);
        
        // Under-edge fillet
        translate([0, 0, h_lip - h_out])
        rotate([180, 0, 0])
            circular_fillet(fillet_radius=-w_lip, pipe_radius=w_out);
            
        // Insert fillet
        translate([0, 0, -h_in])
        rotate([180, 0, 0])
            circular_fillet(fillet_radius=-w_lip, pipe_radius=w_in);
    }
}

difference() {
    _cap_body(w_out=34.95/2, w_in=27/2, h_out=7.6, h_in=18.21, h_lip=5, w_lip=3);
    _drain_holes(radius=2.77, spacing=10, fillet=1, length=18.21, n=3);
}