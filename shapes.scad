use <sketch.scad>
use <util.scad>

// A 2D sketch of a regular hexagon
module hexagon(height) {
    r = height * sqrt(3) / 3;
    
    points = [
        for (i = [0:60:360]) 
            [r*cos(i), r*sin(i)]
    ];
    polygon(points);
}

// A 2D sketch of a rounded rectangle
module rounded_rect(width, height, radius) {
  radius = min(radius, min(width, height) / 2);
  polygon(
    copyMirrorPointsX(
    copyMirrorPointsY(
    translatePoints(
      [width/2-radius, height/2-radius],
      scalePoints(
        radius,
        arc(angle=90, res=3)))
  )));
}

// A standard ellipse
module ellipse(semi_major, semi_minor, n=30) {
  a = max(semi_major, semi_minor);
  b = min(semi_major, semi_minor);
  
  assert (b > 0);
  
  d_theta = 360 / n;
  
  polygon([for (theta = [d_theta:d_theta:360]) let (x=(a*b)/sqrt((b*b + a*a*tan(theta)*tan(theta))), y=tan(theta) * x, sig=((theta > 90) && (theta <= 270)) ? -1 : 1) (x == 0) ? [0, sig*b] : [sig*x, sig*y]]);
}

// Semi-circle
module semi_circle(r = undef, d = undef) {
  // Check that exactly one argument, r or d, is given
  assert(xor_undef(r, d), "Error: arguments 'r' and 'd' are mutually exclusive.")

  if (d == undef) {
    d = 2*r;
  }

  intersection() {
    circle(d=d);
    translate([0, -d/2, 0])
    square([d, d]);
  }
}

module hemisphere(r = undef, d = undef) {
  rotate_extrude(angle=180) semi_circle(r=r, d=d);
}