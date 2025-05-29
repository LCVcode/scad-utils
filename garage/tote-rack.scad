use <../scad-utils/round-poly.scad>
use <../scad-utils/scale.scad>
use <../scad-utils/lumber.scad>

LID_WIDTH=inches(20);
LID_LENGTH=inches(30.5);
LID_DEPTH=inches(1.11);
TOTE_WIDTH=inches(17.5);
TOTE_LENGTH=inches(27);
TOTE_HEIGHT=inches(13.125);
TOTE_WIDTH_BOTTOM=inches(15.125);
RADIUS=inches(2.7);

LID_LIP = min(
  (LID_WIDTH-TOTE_WIDTH)/2,
  (LID_LENGTH-TOTE_LENGTH)/2
);

module lid() {

  
  color("gold")
  translate([0, 0, -LID_DEPTH+0.05])
  linear_extrude(LID_DEPTH)
  round_poly([
    [-LID_WIDTH/2,  LID_LENGTH/2, RADIUS],
    [-LID_WIDTH/2, -LID_LENGTH/2, RADIUS],
    [ LID_WIDTH/2, -LID_LENGTH/2, RADIUS],
    [ LID_WIDTH/2,  LID_LENGTH/2, RADIUS],
  ]);
}

module tote() {

  radius=inches(1);
  
  color("gray")
  rotate([180, 0, 0])
  linear_extrude(TOTE_HEIGHT, scale=TOTE_WIDTH_BOTTOM/TOTE_WIDTH)
  round_poly([
    [-TOTE_WIDTH/2,  TOTE_LENGTH/2, RADIUS],
    [-TOTE_WIDTH/2, -TOTE_LENGTH/2, RADIUS],
    [ TOTE_WIDTH/2, -TOTE_LENGTH/2, RADIUS],
    [ TOTE_WIDTH/2,  TOTE_LENGTH/2, RADIUS],
  ]);
}

module tote_with_lid() {
  translate([0, 0, TOTE_HEIGHT]) {
    tote();
    lid();
  }
}

module tote_rack(vertical_count, horizontal_count=1) {
  dimensional_lumber(4, 4, 8);
}
tote_rack(2);