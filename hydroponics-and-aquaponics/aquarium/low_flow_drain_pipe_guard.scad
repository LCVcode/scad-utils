use <../../utils/pvc.scad>
$fn=360;

C_L=1.1; // PVC pipe connector length (inches)
C_T=0.1; // PVC pipe connector thickness (inches)
P_T=2;   // Peg thickness (millimeters)
P_H=12;  // Peg height (millimeters)
F_T=1.5; // Fin thickness (millimeters)
F_H=17;  // Fin height (millimeters)
F_R=5;   // Fin radius (millimeters)
F_N=15;  // Fin count
G_H=45;  // Flow guard height (millimeters)
G_T=3;   // Flow guard thickness (millimeters)

IN_MM=25.4; // Millimeters per inch

module limit_pegs() {
    // The pegs/spokes that control the height of the drain
    for (i=[0:120:240]) {
        rotate([0, 0, i])
        translate([0, 0, C_L/2 * IN_MM + P_H/2])
        rotate([90, 0, 0])
        linear_extrude(31)
        square([P_T, P_H], center=true);
    }
}

module fin() {
    // local variables
    l = sqrt(pow(F_H, 2) - 2 * F_H * F_R);
    alpha = atan(l / F_R);
    x = F_R * sin(alpha);
    y = F_R * cos(alpha);
    
    rotate([-90, 90-alpha, 0])
    linear_extrude(F_T, center=true)
    union() {
        circle(F_R);
        polygon([[x, y], [0, 0], [-x, y], [0, F_H - F_R]]);
    }
}

module flow_guard() {
    translate([0, 0, 15])
    rotate([180, 0, 0])
    difference() {
        cylinder(h=G_H, r=32);
        translate([0, 0, -1])
        cylinder(h=G_H + 2, r=32-G_T);
    }
}

module low_flow_pipe_drain() {
    // Pipe connector and pegs
    translate([0, 0, -C_L/2 * IN_MM])
    union() {
    3_4_connector_outer(length=C_L, thickness=0.1);
    limit_pegs();}
    
    // Fins
    angle=360/F_N;
    rotate([0, 0, angle/4])
    for (i=[0:angle:360]) {
        rotate([0, 0, i])
        translate([18.5, 0, 0])
        fin();
    }
    
    // Flow guard
    flow_guard();
}
low_flow_pipe_drain();