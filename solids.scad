$fn = $preview ? 16 : 64;

/*
* A standard torus
* big_radius is the radius of the profile's center line
* small_radius is the radius of the profile
*/
module torus(big_radius, small_radius) {
  rotate_extrude()
  translate([big_radius, 0, 0])
  circle(small_radius);
}