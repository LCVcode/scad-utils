$fn=15;

// 8-32 x 2in machine screw
// Phillips oval head
module 8_32_2_machine_screw() {
  shaftDiameter = 4.93;
  screwLength = 50;
  headLength = 4;
  headWidth = 7.89;
  
  union() {
  cylinder(h=screwLength, r=shaftDiameter/2);
  rotate_extrude()
  polygon([
    [0, 0],
    [headWidth/2, 0],
    [shaftDiameter/2, headLength],
    [0, headLength]
  ]);
  }
}
