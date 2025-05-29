$fn=60;

SEPARATION = 25.4;
T_BOARD = 5.66;
D_HOLE = 6.35;
TOL = 0.25;
R_PEG = 0.75*(D_HOLE / 2) - TOL;

module pegboardHook() {
    // Parameters
    hookTurnRadius = 3;
    
    // Part offset
    translate([TOL, 0, 0]) {
    union() {
        
    // Round end
    translate([-(T_BOARD+R_PEG+hookTurnRadius), 0, R_PEG+hookTurnRadius])
    sphere(R_PEG);
        
    // Hook turn
    translate([-T_BOARD, 0, hookTurnRadius+R_PEG])
    rotate([0, 90, 90])
    rotate_extrude(angle=90)
    translate([hookTurnRadius + R_PEG, 0, 0])
    circle(R_PEG);
    
    // Straight segment
    rotate([0, -90, 0])
    linear_extrude(T_BOARD + TOL)
    circle(R_PEG);
    }}
}

module pegboardHookInverted() {
    // A flipped version of the pegboard hook
    rotate([180, 0, 0])
    pegboardHook();
}

module pegboardDualHookMount() {    
    translate([0, SEPARATION / 2, 0])
    pegboardHook();
    
    translate([0, -SEPARATION / 2, 0])
    pegboardHook();
    
    translate([R_PEG, 0, 0])
    rotate([90, 0, 0])
    linear_extrude(SEPARATION+2*R_PEG, center=true)
    square(2*R_PEG, 2*R_PEG, center=true);
}
pegboardDualHookMount();