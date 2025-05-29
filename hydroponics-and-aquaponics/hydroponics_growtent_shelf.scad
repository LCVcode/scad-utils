use <../scad-utils/lumber.scad>
use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>

module vertical_supports() {
  color("gold")
  copy_mirror_x() copy_mirror_y()
  translate([inches(23.25), inches(4.25), feet(3)])
  dimensional_lumber(2, 4, 6);
}

module shelf(suppress_lights=false) {
  // Forward & rear supports
  color("palegreen")
  copy_mirror_y()
  translate([0, inches(5.25), inches(1.25)])
  rotate([90, 0, 90])
  dimensional_lumber(2, 3, 45 / 12);
  
  // Side and middle supports
  color("royalblue")
  for (i=[-1:1]) {
    translate([i*inches(21.75), 0, inches(1.25)])
    rotate([90, 0, 0])
    dimensional_lumber(2, 3, 9 / 12);
  }
  
  x = inches(22.5);
  y = inches(6);
  
  color("orangered")
  translate([0, 0, inches(2.5)])
  linear_extrude(inches(1/4))
  polygon([
    [ x,  y],
    [ x, -y],
    [-x, -y],
    [-x,  y],
  ]);
  
  if (!suppress_lights) {
    for (i=[-1:1]) {translate([0, i * inches(1.8), 0]) barrina_light();}
  }
}

module barrina_light() {
  // Taken from: https://www.amazon.com/Barrina-Integrated-Fixture-Utility-Electric/dp/B08B4M8253?sr=8-5&linkId=070529ffc07380c07fe205d6f2bf9e7f&language=en_US&ref_=as_li_ss_tl
  color("lightblue")
  translate([0, 0, -inches(1.4)])
  linear_extrude(inches(1.4))
  square([inches(46.1), inches(0.9)], center=true);
}

module cloning_dome() {
  color("gray")
  linear_extrude(inches(7))
  square([inches(14.5), inches(11)], center=true);
}

module shelf_with_cloning_dome(suppress=false) {
  shelf(suppress_lights=suppress);
  
  for (i=[-1:1]) {
    translate([i*inches(15), 0, 0])
    cloning_dome();
  }
}

module BI_microgreen_tray() {
  // Botanical Interests microgreen tray, sold by Epic Gardening
  // https://www.botanicalinterests.com/products/growing-trays
  
  color("gray")
  linear_extrude(inches(4.75))
  square([inches(21.25), inches(11)], center=true);
}

module shelf_with_BI_tray(suppress=false) {
  shelf(suppress_lights=suppress);
  
  for (i = [-1, 1]) {
    translate([i*inches(11.25), 0, inches(2.75)])
    BI_microgreen_tray();
  }
}

module hydro_rack() {
  // Parameters
  cloning_shelf_heights = [12, 24];
  microgreen_shelf_heights = [36, 47, 58, 69.25];
  
  //%linear_extrude(feet(6.45))
  //square([inches(48), inches(12)], center=true);
  
  vertical_supports();
  
  
  shelf_with_cloning_dome(suppress=true);
  for (off=cloning_shelf_heights) {
    translate([0, 0, inches(off)])
    shelf_with_cloning_dome();
  }
  
  for (off=microgreen_shelf_heights) {
    translate([0, 0, inches(off)])
    shelf_with_BI_tray();
  }
}
hydro_rack();