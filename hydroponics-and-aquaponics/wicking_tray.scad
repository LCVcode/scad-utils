$fn = $preview ? 16 : 360;

use <../scad-utils/scale.scad>
use <../scad-utils/modifiers.scad>


/*
 This wicking tray fits into those cheap to-go food containers.  
*/
module wicking_tray() { 
  food_tray_width = inches(3); 
  food_tray_length = inches(6); 
  food_tray_depth = inches(0.75); 
  food_tray_corner_radius = inches(0.5);

  wicking_tray_thickness = 6; 
  leg_diameter = 8;
  slot_width = 10;
  slot_length = food_tray_width - inches(1);

  leg_x_stride = food_tray_length/2.6; 
  leg_y_stride = food_tray_width/2;

  difference() {
    rotate([180, 0, 0]) 
      union()
      { 
        // Tray body
        linear_extrude(wicking_tray_thickness) 
          hull()
          copy_mirror_x() 
          copy_mirror_y() 
          translate([ 
              food_tray_length/2 - food_tray_corner_radius, 
              food_tray_width/2  - food_tray_corner_radius, 
              0 ])
          circle(r=food_tray_corner_radius);

        // Tray legs
        translate([ -leg_x_stride, -leg_y_stride/2, 0.01]) 
          array(vector=[leg_x_stride, 0, 0], n=3) 
          array(vector=[0, leg_y_stride, 0], n=2)
          linear_extrude(food_tray_depth) 
          circle(d=leg_diameter); 
      }

    copy_mirror_x()
      translate([leg_x_stride/2, 0, -wicking_tray_thickness - 1])
      linear_extrude(wicking_tray_thickness + 2)
      hull()
      copy_mirror_y()
      translate([
          0,
          (slot_length - slot_width)/2,
          0
      ])
      circle(d=slot_width);
  }
} 
wicking_tray();
