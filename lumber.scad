use <round-poly.scad>
use <scale.scad>

// NOTE: ALL DISTANCES ARE IN INCHES

/*
  A standard piece of lumber with given dimensions, in inches.
*/
module lumber(width, height, length, radius, center=true) {
  x = inches(width/2);
  y = inches(height/2);
  radius = inches(radius);
  length = feet(length);
  linear_extrude(length, center=center)
  round_poly(
  [
    [-x, -y, radius],
    [ x, -y, radius],
    [ x,  y, radius],
    [-x,  y, radius],
  ],
  resolution = $preview ? 30 : 5);
};

module dimensional_lumber(width, height, length, center=true) {
  /*
  
  Standard American dimensional lumber.  Width and height arguments are in inches, as used in dimensional lumber measurements.  Length is in feet.
  
  Examples:
  Get an 8 foot 2x4:
    dimensional_lumber(2, 4, 8);
  
  Get a 3 foot 4x4:
    dimensional_lumber(4, 4, 3);
  
  */
  lumber(width=width-0.5, height=height-0.5, radius=1/8, length=length, center=center);
}

module 2x4_lumber(length, center=true) {
  dimensional_lumber(width=4, height=2, length=length, center=center);
}

module 2x6_lumber(length, center=true) {
  lumber(width=5.5, height=1.5, length=length, radius=1/8, center=center);
}

module 4x4_lumber(length, center=true) {
  lumber(width=3.5, height=3.5, length=length, radius=1/8, center=center);
}