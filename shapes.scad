use <sketch.scad>

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