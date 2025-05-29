use <scad-utils/round-poly.scad>

$fn=180;

TOL = 0.2;

module desk_cup(screw_shaft_diameter, screw_head_diameter, screw_head_height, cup_inner_diameter, cup_thickness, cup_height) {
  
  r_shaft = screw_shaft_diameter/2 + TOL;
  r_head = screw_head_diameter/2 + TOL;
  r_in = cup_inner_diameter/2 + TOL;
  r_out = r_in + cup_thickness + TOL;
  h_shaft = 5;
  h_head = h_shaft + screw_head_height + TOL;
  h_cup = cup_height;
  
  rotate_extrude()
  round_poly([
    [r_shaft, 0, 0],
    [r_shaft, h_shaft, 0],
    [r_head, h_shaft, 0],
    [r_head, h_head, screw_head_height],
    [r_in, h_head, 3],
    [r_in, h_cup, cup_thickness/2],
    [r_out, h_cup, cup_thickness/2],
    [r_out, 0, 0]
  ]);
}
desk_cup(screw_shaft_diameter=4.16, screw_head_diameter=8, screw_head_height=2.8, cup_inner_diameter=62, cup_thickness=5.5, cup_height=25);