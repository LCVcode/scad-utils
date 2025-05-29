$fn=120;

// Material parameters
T_FOAM = 2;         // Thickness of foam insulation board
T_BOARD = 0.418;    // Thickness of plywood boards
T_SUPP = 1.35;      // Square thickness of support boards

// Box parameters
BOX_WIDTH = 21;
BOX_HEIGHT = 24;
BOX_LENGTH = 31.5;

// Door parameters
DOOR_WIDTH = 6;
DOOR_HEIGHT = 6;
DOOR_SIDE_OFFSET = 2;
DOOR_HEIGHT_OFF_GROUND = DOOR_SIDE_OFFSET;

// Shelf parameters
SHELF_LENGTH = 20;
SHELF_HEIGHT_OFFSET = 2;  // This is the vertical distance from the mid horizontal plane of the box

// Shelf constants (do not modify)
shelf_width = BOX_WIDTH - 2 * (T_BOARD + max(T_FOAM, T_SUPP));
shelf_height = BOX_HEIGHT / 2 - T_FOAM - T_BOARD + SHELF_HEIGHT_OFFSET;

// Floor constants (do not modify)
floor_board_width = BOX_WIDTH - 2 * T_BOARD;
floor_board_length = BOX_LENGTH - 2 * T_BOARD;
floor_foam_width = floor_board_width - 2 * T_SUPP;
floor_foam_length = floor_board_length - 2 * T_SUPP;
floor_support_y_offset = -(floor_foam_width + T_SUPP) / 2;
floor_support_z_offset = (T_SUPP - BOX_HEIGHT) / 2  + T_BOARD;
floor_support_x_offset = -(floor_foam_length + T_SUPP) / 2;

// Side wall constants (do not modify)
side_board_height = BOX_HEIGHT - T_BOARD;
side_wall_y_offset = (BOX_WIDTH - T_BOARD) / 2;
side_support_x_offset = (BOX_LENGTH - T_SUPP) / 2 - T_BOARD;
side_support_y_offset = (BOX_WIDTH - T_SUPP) / 2 - T_BOARD;
side_support_length = BOX_HEIGHT - 2 * (T_BOARD + T_SUPP);
side_foam_y_offset = (BOX_WIDTH - T_FOAM) / 2 - T_BOARD;

// Front/back wall constants (do not modify)
back_foam_x_offset = (T_FOAM - BOX_LENGTH) / 2 + T_BOARD;
back_board_height = BOX_HEIGHT - T_BOARD;
back_board_x_offset = (T_BOARD - BOX_LENGTH)/ 2;
back_board_z_offset = -T_BOARD / 2;

module genericBoard(width, height, thickness) {
    // Units are inches
    linear_extrude(thickness, center=true)
    square([height, width], center=true);
}

module foamBoard(width, height) {
    echo("Foam board");
    echo(width=width, height=height);
    color("#b8bb26") {
        genericBoard(width, height, T_FOAM);
    }
}

module plywoodBoard(width, height) {
    echo("Plywood");
    echo(width=width, height=height);
    color("#7c6f64") {
        //genericBoard(width, height, T_BOARD);
    }
}

module supportBeam(length) {
    echo("Support beam");
    echo(length=length);
    color("#d79921") {
        genericBoard(T_SUPP, T_SUPP, length);
    }
}

module catBoxFrame() {
     // Floor side supports
    translate([0, floor_support_y_offset, floor_support_z_offset])
    rotate([0, 90, 0])
    supportBeam(floor_foam_length);
    translate([0, -floor_support_y_offset, floor_support_z_offset])
    rotate([0, 90, 0])
    supportBeam(floor_foam_length);
    
    // Floor front & back supports
    translate([floor_support_x_offset, 0, floor_support_z_offset])
    rotate([90, 0, 0])
    supportBeam(floor_foam_width + 2 * T_SUPP);
    translate([-floor_support_x_offset, 0, floor_support_z_offset])
    rotate([90, 0, 0])
    supportBeam(floor_foam_width + 2 * T_SUPP);
    
    // Ceiling side supports
    translate([0, floor_support_y_offset, -floor_support_z_offset])
    rotate([0, 90, 0])
    supportBeam(floor_foam_length);
    translate([0, -floor_support_y_offset, -floor_support_z_offset])
    rotate([0, 90, 0])
    supportBeam(floor_foam_length);
    
    // Ceiling front & back supports
    translate([floor_support_x_offset, 0, -floor_support_z_offset])
    rotate([90, 0, 0])
    supportBeam(floor_foam_width + 2 * T_SUPP);
    translate([-floor_support_x_offset, 0, -floor_support_z_offset])
    rotate([90, 0, 0])
    supportBeam(floor_foam_width + 2 * T_SUPP);

    // Wall supports
    translate([side_support_x_offset, side_support_y_offset, 0])
    supportBeam(side_support_length);
    translate([-side_support_x_offset, side_support_y_offset, 0])
    supportBeam(side_support_length);
    translate([side_support_x_offset, -side_support_y_offset, 0])
    supportBeam(side_support_length);
    translate([-side_support_x_offset, -side_support_y_offset, 0])
    supportBeam(side_support_length);
}

module catBoxFloor() {
    // Floor plywood
    translate([0, 0, (T_BOARD - BOX_HEIGHT) / 2])
    plywoodBoard(width=floor_board_width, height=floor_board_length);
    
    // Floor foam
    translate([0, 0, (T_FOAM - BOX_HEIGHT)/2 + T_BOARD])
    foamBoard(width=floor_foam_width, height=floor_foam_length);
}

module catBoxCeiling() {
    // Ceiling/roof parameters
    roof_overhang = 0.5;
    roof_width = floor_board_width + 2 * (T_BOARD + roof_overhang);
    roof_length = floor_board_length + 2 * (T_BOARD + roof_overhang);
    
    // Ceiling foam
    translate([0, 0, -(T_FOAM - BOX_HEIGHT)/2 - T_BOARD])
    foamBoard(width=floor_foam_width, height=floor_foam_length);
    
    // Ceiling plywood
    translate([0, 0, -(T_BOARD - BOX_HEIGHT) / 2])
    plywoodBoard(width=roof_width, height=roof_length);
}

module catBoxSideWallLeft() {
    // Plywood
    translate([0, -side_wall_y_offset, -T_BOARD / 2])
    rotate([90, 0, 0])
    plywoodBoard(side_board_height, floor_board_length);
    
    // Foam
    translate([0, -side_foam_y_offset, 0])
    rotate([90, 0, 0])
    foamBoard(side_support_length, floor_foam_length);
}

module catBoxSideWallRight() {
    mirror([0, 1, 0])
    catBoxSideWallLeft();
} 

module catBoxBackWall() {
    // Foam
    translate([back_foam_x_offset, 0, 0])
    rotate([0, 90, 0])
    foamBoard(floor_foam_width, side_support_length);
    
    // Plywood
    translate([back_board_x_offset, 0, back_board_z_offset])
    rotate([0, 90, 0])
    plywoodBoard(BOX_WIDTH, back_board_height);
}

module catBoxFrontWall() {
    offset = T_BOARD + max(T_FOAM, T_SUPP);
    
    difference() {
    mirror([1, 0, 0])
    catBoxBackWall();
    
    // Cat door
    translate([
        0, 
        (BOX_WIDTH - DOOR_WIDTH) / 2 - offset - DOOR_SIDE_OFFSET,
        (DOOR_HEIGHT - BOX_HEIGHT) / 2 + offset + DOOR_HEIGHT_OFF_GROUND
    ])
    rotate([0, 90, 0])
    linear_extrude(100, center=true)
    square([DOOR_WIDTH, DOOR_HEIGHT], center=true);
    }
}

module catShelf() {
    // Local offsets
    x_offset = (SHELF_LENGTH - T_SUPP) / 2;
    y_offset = (shelf_width - T_SUPP) / 2;
    z_offset = -(shelf_height) / 2;

    // Main platform
    plywoodBoard(shelf_width, SHELF_LENGTH);

    // Legs
    translate([x_offset, y_offset, z_offset])
    supportBeam(shelf_height - T_BOARD);
    translate([-x_offset, y_offset, z_offset])
    supportBeam(shelf_height - T_BOARD);
    translate([x_offset, -y_offset, z_offset])
    supportBeam(shelf_height - T_BOARD);
    translate([-x_offset, -y_offset, z_offset])
    supportBeam(shelf_height - T_BOARD);
}

module catBox() {
    catBoxFrame();
    
    catBoxFloor();
    catBoxCeiling();
    
    // catBoxSideWallLeft();
    catBoxSideWallRight();
    
    catBoxBackWall();
    catBoxFrontWall();
}

// Box Two Parameters (do change)
box2FloorSupportCount = 2;

// Box Two Constants (do not change)
internalLength = BOX_LENGTH - 2 * (T_BOARD + T_FOAM);
internalWidth = BOX_WIDTH - 2 * (T_BOARD + T_FOAM + T_SUPP);
internalHeight = BOX_HEIGHT - 2 * (T_BOARD + T_FOAM + T_SUPP);
box2FloorFoamLength = internalLength + 2 * T_FOAM;
box2FloorFoamWidth = internalWidth+ 2 * T_FOAM;
box2FloorSupportCrossLength = box2FloorFoamWidth;
box2SideFoamHeight = internalHeight;
box2SideFoamWidth = box2FloorFoamLength;
box2SideSupportLength = box2SideFoamHeight + 2 * T_FOAM;
box2SideBoardHeight = BOX_HEIGHT - T_BOARD;
box2SideBoardWidth = BOX_LENGTH - 2 * T_BOARD;
box2CeilingSupportLength = BOX_WIDTH - 2 * T_BOARD;
box2CeilingSupportCrossLength = BOX_LENGTH - 2 * (T_BOARD + T_SUPP);
box2CeilingBoardWidth = BOX_WIDTH + 2;
box2CeilingBoardLength = BOX_LENGTH + 2;

module catBox2Floor() {
    // Local variables
    supportYOffset = (box2FloorFoamWidth + T_SUPP) / 2;
    supportZOffset = -(T_FOAM + T_SUPP) / 2;
    
    // Floor translation offset
    translate([0, 0, -(internalHeight + T_FOAM) / 2]) {
    
    // Foam floor at origin
    foamBoard(box2FloorFoamWidth, box2FloorFoamLength);
    
    // Support beams under foam floor
    startOffset = (box2FloorFoamLength - T_SUPP) / 2;
    step = (box2FloorFoamLength - T_SUPP) / (box2FloorSupportCount + 1);
    translate([-startOffset, 0, supportZOffset])
    for (i = [0:box2FloorSupportCount + 1]) {
        translate([i * step, 0, 0])
        rotate([90, 0, 0])
        supportBeam(box2FloorSupportCrossLength);
    }
    
    // Support beams running the length
    translate([0, supportYOffset, supportZOffset])
    rotate([0, 90, 0])
    supportBeam(box2FloorFoamLength);
    translate([0, -supportYOffset, supportZOffset])
    rotate([0, 90, 0])
    supportBeam(box2FloorFoamLength);
    
    // Bottom plywood board
    translate([0, 0, supportZOffset - (T_SUPP + T_BOARD) / 2])
    plywoodBoard(BOX_WIDTH - 2 * T_BOARD, BOX_LENGTH - 2 * T_BOARD);
    } // This bracket closes the floor translation offset
}

module catBox2SideWallRight() {
    // Local variables
    supportXOffset = (BOX_LENGTH - T_SUPP) / 2 - T_BOARD;
    supportYOffset = -(T_FOAM + T_SUPP) / 2;
    supportZOffset = 0;
    boardYOffset = - (BOX_WIDTH - T_BOARD) / 2;
    boardZOffset = -T_BOARD/2;
    
    // Side wall offset
    translate([0, -(internalWidth + T_FOAM) / 2, 0]) {
        
    // Foam board
    rotate([90, 90, 0])
    foamBoard(box2SideFoamWidth, box2SideFoamHeight);
        
    // Support beams
    translate([supportXOffset, supportYOffset, supportZOffset])
    supportBeam(box2SideSupportLength);
    translate([-supportXOffset, supportYOffset, supportZOffset])
    supportBeam(box2SideSupportLength);
    }
    
    // Plywood board
    translate([0, boardYOffset, boardZOffset])
    rotate([90, 0, 0])
    plywoodBoard(box2SideBoardHeight, box2SideBoardWidth);
}

module catBox2SideWallLeft()  {
    mirror([0, 1, 0])
    catBox2SideWallRight();
}

module catBox2Ceiling() {
    // Local parameters
    foamZOffset = (internalHeight + T_FOAM) / 2;
    supportXOffset = (BOX_LENGTH - T_SUPP) / 2 - T_BOARD;
    supportZOffset = (T_FOAM + T_SUPP) / 2;
    
    // Ceiling offset
    translate([0, 0, foamZOffset]) {
    
    // Foam board
    foamBoard(box2FloorFoamWidth, box2FloorFoamLength);
        
    // Supports
    translate([supportXOffset, 0, supportZOffset])
    rotate([90, 0, 0])
    supportBeam(box2CeilingSupportLength);
    translate([-supportXOffset, 0, supportZOffset])
    rotate([90, 0, 0])
    supportBeam(box2CeilingSupportLength);
    
    // Cross support
    translate([0, 0, supportZOffset])
    rotate([0, 90, 0])
    supportBeam(box2CeilingSupportCrossLength);
        
    // Plywood roof
    translate([0, 0, supportZOffset + (T_SUPP + T_BOARD) / 2])
    plywoodBoard(box2CeilingBoardWidth, box2CeilingBoardLength);
    }
}

module catBox2BackWall() {
    translate([-(internalLength + T_FOAM) / 2, 0, 0]) {
    // Foam board
    rotate([0, 90, 0])
    foamBoard(internalWidth, internalHeight);
    
    // Plywood
    translate([-(T_BOARD + T_FOAM) / 2, 0, -T_BOARD / 2])
    rotate([0, 90, 0])
    plywoodBoard(BOX_WIDTH, BOX_HEIGHT - T_BOARD);
    }
}

module catBox2FrontWall() {
    difference() {
    // Base wall
    mirror([1, 0, 0])
    catBox2BackWall();
    
    // Cat door
    translate([0, 0, -DOOR_HEIGHT/2])
    rotate([0, 90, 0])
    linear_extrude(BOX_LENGTH * 2, center=true)
    square([DOOR_WIDTH, DOOR_HEIGHT], center=true);
    }
}

module catBox2() {
    
    catBox2Floor();
    catBox2SideWallRight();
    catBox2SideWallLeft();
    catBox2Ceiling();
    catBox2BackWall();
    catBox2FrontWall();
}

module cordHolePlug() {
    tolerance = 0.5;
    od = 31.7 + 2 * tolerance;
    id = 13.3 + 2 * tolerance;
    depth = 25;
    
    rotate_extrude(angle=180)
    polygon([
        [id/2, 0],
        [id/2, depth - 3],
        [id/2 + 3, depth],
        [od/2 - 3, depth],
        [od/2, depth - 3],
        [od/2, 0]
    ]);
}

module boxFoot() {
    tolerance = 0.5;
    height = 15;
    diameter = 40;
    radius = 2;
    screw_head_diameter = 7 + 2 * tolerance;
    screw_thread_diameter = 3.85 + 2 * tolerance;
    
    rotate_extrude() {
    union() {
        polygon([
        [screw_thread_diameter / 2, 0],
        [screw_thread_diameter / 2, 3.5],
        [screw_head_diameter / 2, 3.5],
        [screw_head_diameter / 2, height - radius],
        [screw_head_diameter / 2 + radius, height],
        [diameter / 2 - radius, height],
        [diameter / 2, height - radius],
        [diameter / 2, 0],
        ]);
        translate([radius + screw_head_diameter / 2, height - radius, 0])
        circle(radius);
        translate([diameter/ 2 - radius, height - radius, 0])
        circle(radius);
    }}
}

// catBox2();
// translate([-(floor_foam_length - SHELF_LENGTH) / 2, 0, -T_BOARD/2 + SHELF_HEIGHT_OFFSET])
// catShelf();
// cordHolePlug();
boxFoot();

echo("Internal dimensions: (W: ", internalWidth, " H: ", internalHeight, " L: ", internalLength);
