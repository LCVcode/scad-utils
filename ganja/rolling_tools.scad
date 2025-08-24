use <../scad-utils/round-poly.scad>
use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>

$fn = $preview ? 16 : 360;

// Parameters
FunnelThickness = 1.5;
FunnelWideOD = 30;
FunnelMiddleOD = 10;
FunnelNarrowOD = 6.5;
FunnelTopHeight = 20;
FunnelBottomHeight = 15;
PokerLength = inches(3.5);
TrayThickness = 6;
TrayHolderHeight = inches(1.25);
TrayHolderDepth = inches(0.6);
TrayHolderInternalRadius = inches(0.05);
TrayHolderExternalRadius = inches(0.15);
TrayRadius = inches(1.75);
TrayCurvature = inches(0.4);
TrayOffset = 25;


// Funnel to help fill joints
module funnel() {
    x1 = (FunnelNarrowOD - FunnelThickness)/2;
    x2 = (FunnelMiddleOD - FunnelThickness)/2;
    x3 = (FunnelWideOD - FunnelThickness)/2;
    x4 = x1 + FunnelThickness;
    x5 = x2 + FunnelThickness;
    x6 = x3 + FunnelThickness;

    y1 = -FunnelBottomHeight;
    y2 = 0;
    y3 = FunnelTopHeight;

    r1 = FunnelThickness / 4;
    r2 = min(FunnelTopHeight, FunnelBottomHeight);

    rotate_extrude()
    round_poly([
            [x1, y1, 2*r1],
            [x2, y2, r2],
            [x3, y3, r1],
            [x6, y3, 2*r1],
            [x5, y2, r2],
            [x4, y1, r1],
    ]);
}
translate([0, 0, 30])
funnel();

// Poker stick to push material through the funnel
module poker() {
    tolerance = 0.6;

    x = (FunnelNarrowOD - FunnelThickness)/2 - tolerance;
    y = PokerLength;

    translate([0, 0, -30])
    rotate_extrude()
    round_poly([
            [0, 0, 0],
            [0, y, 0],
            [x, y, x/2],
            [x, 0, x/2],
    ]);
}
translate([0, 0, 50])
poker();

// Profile used to generate the bottom tray
module tray_profile() {
    tolerance = 0.1;
    x1 = TrayRadius - TrayThickness;
    x2 = TrayRadius;
    y1 = TrayCurvature + TrayThickness/2;
    y2 = -TrayThickness;
    r1 = TrayCurvature;
    r2 = TrayThickness/2 - tolerance;
    r3 = r1 + TrayThickness;

    round_poly([
        [  0,  0,  0],
        [ x1,  0, r1],
        [ x1, y1, r2],
        [ x2, y1, r2],
        [ x2, y2, r3],
        [  0, y2,  0],
    ]);
}

// Tray to catch debris and hold up the butt
module tray() {
    tolerance = 0.2;

    // Bottom tray
    //  round section
    rotate_extrude(angle=180)
    tray_profile();

    // pointed section
    copy_mirror_x()
    difference() {
        rotate([0, 0, -90])
            translate([0, -TrayOffset, 0])
            rotate_extrude(angle=90)
            translate([TrayOffset, 0, 0])
            tray_profile();
        linear_extrude(3*(TrayThickness + TrayCurvature), center=true)
            translate([-100, -100, 0])
            square(100);
    }

    // Butt holder
    x1 = TrayHolderInternalRadius;
    x2 = TrayHolderExternalRadius;
    x3 = x2 + TrayCurvature;
    y1 = TrayHolderHeight - TrayHolderDepth;
    y2 = TrayHolderHeight;
    y3 = TrayCurvature;
    r1 = x1 - tolerance;
    r2 = 0.5;
    r3 = TrayCurvature - tolerance;

    rotate_extrude()
    round_poly([
            [  0, y1,  0],
            [ x1, y1, r1],
            [ x2, y2, r2],
            [ x2,  0, r3],
            [ x3,  0,  0],
            [  0,  0,  0],
    ]);
}
!tray();
