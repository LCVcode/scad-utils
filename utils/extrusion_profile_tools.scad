TOL = 0.07;

module extrusionProfileGroovePressFit(length) { 
    gapWidth = 6.63;
    lipWidth = 2.87;
    lipHeight = 1.64;
    sideHeight = 1.21;
    floorWidth = 4.97;
    totalHeight = 6.84;
    
    // X coordinates
    A = gapWidth/2 - TOL;
    B = floorWidth/2 - TOL;
    C = gapWidth/2 + lipWidth - TOL;
    
    // Y coordinates
    D = TOL;
    E = -lipHeight - TOL;
    F = -(lipHeight + sideHeight) + TOL;
    G = -totalHeight + TOL;
    
    linear_extrude(length, center=true)
    polygon([
    [A, D],
    [A, E],
    [C, E],
    [B, G],
    [-B, G],
    [-C, E],
    [-A, E],
    [-A, D],
    ]);
}

extrusionProfileGroovePressFit(length=25.3);