use <round-poly.scad>
use <scale.scad>

// NOTE: ALL DISTANCES ARE IN INCHES

/*
  A standard piece of lumber with given dimensions, in inches.
*/
module lumber(width, height, length, radius, center=true) {
  x = width/2;
  y = height/2;
  scale_inches()
  linear_extrude(length, center=center)
  round_poly(
  [
    [-x, -y, radius],
    [x, -y, radius],
    [x, y, radius],
    [-x, y, radius],
  ]
  );
};

module 2x4_lumber(length, center=true) {
  lumber(width=3.5, height=1.5, length=length, radius=1/8, center=center);
}

module 2x6_lumber(length, center=true) {
  lumber(width=5.5, height=1.5, length=length, radius=1/8, center=center);
}

module 4x4_lumber(length, center=true) {
  lumber(width=3.5, height=3.5, length=length, radius=1/8, center=center);
}