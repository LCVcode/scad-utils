use <../scad-utils/scale.scad>
use <../scad-utils/round-poly.scad>

$fn = $preview ? 16 : 128;

// Material parameters
hole_diameter = 20;           // Diameter of holes in square
mat_thickness = inches(1/4);

// Guide parameters
T_guide = 0.0;                // Funnel guide tolerance
guide_thickness = 1.75;
guide_lip_width = 4;
guide_angle = 60;             // Also applies to funnels
guide_spade_length = inches(0.075);
guide_height_above_mat = 3;

// Funnel parameters
T_funnel = 0.3;               // Funnel tolerance
funnel_thickness = 2;
funnel_length = inches(1);
funnel_lip_width = 2;

// Plunger parameters
T_plunger = 0.3;
plunger_length = inches(3);

module base_square() {
  color("MediumSeaGreen")
  mirror([0, 0, 1]) linear_extrude(mat_thickness)
  square([feet(1), feet(1)], center=true);
}

module mat_hole() {  
  color("gold")
  translate([0, 0, -mat_thickness - 0.5])
  cylinder(d=hole_diameter, h=mat_thickness + 1);
}

module square_foot_seed_guide(count) {
  spacing = inches(12) / count;
  
  difference() {
    base_square();
    
    translate([-inches(6) + spacing/2, -inches(6) + spacing/2, 0])
    for (j=[0:count-1]) {
    for (i=[0:count-1]) {
      translate([i * spacing, j * spacing, 0])
      mat_hole();
    }}
  }
}
//square_foot_seed_guide(3);

module funnel_guide() {
  x2 = hole_diameter/2 - T_guide;
  x1 = x2 - guide_thickness;
  x3 = hole_diameter/2 + guide_lip_width;
  
  y2 = -mat_thickness;
  y1 = y2 - guide_spade_length;
  y3 = guide_height_above_mat;
  y4 = y3 + tan(guide_angle) * (guide_thickness + guide_lip_width);
  
  rotate_extrude()
  round_poly([
    [x1, y1, 0.5],
    [x2, y2, 0  ],
    [x2,  0, 1  ],
    [x3,  0, 1  ],
    [x3, y4, 1.5],
    [x1, y3, 4  ],
  ]);
}

module funnel(depth) {
  x3 = hole_diameter/2 - T_guide - guide_thickness - T_funnel;
  x2 = x3 - funnel_thickness;
  x1 = x2 - funnel_lip_width;
  x4 = x2 + cos(guide_angle) * funnel_length;
  x5 = x4 + sin(guide_angle) * funnel_thickness;
  
  y1 = -mat_thickness - depth;
  y2 = y1 + funnel_thickness;
  y3 = guide_height_above_mat;
  y4 = y3 + funnel_thickness * ((1/cos(guide_angle)) - tan(guide_angle));
  y6 = y4 + sin(guide_angle) * funnel_length;
  y5 = y6 - cos(guide_angle) * funnel_thickness;
  
  r1 = funnel_thickness / 2 - 0.1;
  r2 = funnel_thickness;
  r3 = funnel_lip_width - r1 - 0.1;

  rotate_extrude()
  round_poly([
    [x1, y1, r1/3],
    [x2, y2, r3],
    [x2, y4, r2],
    [x4, y6, r1],
    [x5, y5, r1],
    [x3, y3, r2],
    [x3, y1, r2],
  ]);
}

module plunger() {
  y1 = funnel_thickness;
  y2 = plunger_length;
  
  x2 = hole_diameter/2 - T_guide - guide_thickness - T_funnel - funnel_thickness - T_plunger;
  x1 = x2 - funnel_lip_width;
  
  rotate_extrude()
  round_poly([
    [ 0,  0,  0],
    [x1,  0, x1/2],
    [x2, y1, x1/2],
    [x2, y2, x2/2],
    [ 0, y2, 0],
  ]);
}

module funnel_guide_assembly(depth) {
  funnel_guide();
  funnel(depth);
  translate([0, 0, -depth - mat_thickness])
  plunger();
}
funnel_guide_assembly(inches(1));
base_square();