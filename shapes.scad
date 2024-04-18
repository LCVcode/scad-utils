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
module roundedRect(width, height, radius) {
  radius = min(radius, min(width, height) / 2);
  polygon(
    copyMirrorPointsX(
    copyMirrorPointsY(
    translatePoints(
      scalePoints(
        arc(angle=90, res=3), radius),
      [width/2-radius, height/2-radius])
  )));
}