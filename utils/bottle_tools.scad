use <../utils/circles.scad>;

$fn=90;

TOL=0.1;

// Coffee mate measurements
CM_ID=27.4; // Inner diameter
CM_OD=44.5; // Outer diameter
CM_S_H=31;  // Sleeve height
CM_I_H=15;  // Insert height
CM_T=2.5;   // Thickness
CM_L_H=20;  // Lip height
CM_L_W=CM_OD*1.5;
CM_N_H=5;   // Water drain hole count

module neck_insert(r, h) {
    // Portion that goes inside the neck of the bottle
    translate([0, 0, -h/2])
    cylinder(h=h, r=r, center=true);
}

module neck_sleeve(r, h, t) {
    // Portion around the outside of the neck of the bottle
    mirror([0, 0, 1])
    linear_extrude(h)
    ring(outer_radius=r+t, inner_radius=r);
}

module neck_cap(r, h) {
    // Portion at the top, joining the insert and sleeve
    cylinder(r=r, h=h);
}

module full_bottle_cap(insert_r, insert_h, sleeve_r, sleeve_h, sleeve_t, cap_h) {
    union() {
        neck_insert(r=insert_r, h=insert_h);
        neck_sleeve(r=sleeve_r, h=sleeve_h, t=sleeve_t);
        translate([0, 0, -TOL])
        neck_cap(r=sleeve_r+sleeve_t, h=cap_h);
    }
}

module coffee_mate_bottle_cap_base() {
    full_bottle_cap(
        insert_r=CM_ID/2-TOL,
        insert_h=CM_I_H,
        sleeve_r=CM_OD/2+TOL,
        sleeve_h=CM_S_H,
        sleeve_t=CM_T,
        cap_h=CM_T
    );
}

module coffee_mate_bottle_cap_with_hole() {
    // local variables
    hole_radius = (CM_ID)/2-CM_T;
    
    difference() {
        coffee_mate_bottle_cap_base();
        cylinder(h=100, r=hole_radius, center=true);
    }
}

module coffee_mate_bottle_cap_with_nozzle() {
    // local variables
    nozzle_height = CM_S_H - CM_I_H;

    union() {
        coffee_mate_bottle_cap_with_hole();
        translate([0, 0, -CM_I_H+TOL])
        mirror([0, 0, 1])
        difference() {
            cylinder(h=nozzle_height, r1=CM_ID/2-TOL, r2=10);
            translate([0, 0, -TOL])
            cylinder(h=nozzle_height+2*TOL, r1=CM_ID/2-TOL-CM_T, r2=10-CM_T);
        }
    }
}

module coffee_mat_bottle_cap_with_water_control() {
    coffee_mate_bottle_cap_with_nozzle();
    
}

coffee_mat_bottle_cap_with_water_control();