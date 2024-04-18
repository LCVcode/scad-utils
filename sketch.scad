use <list.scad>;

// Translate a list of 2D points
function translatePoints(points, transform) = [
  for (point = points)
    [point[0] + transform[0], point[1] + transform[1]]
];

// Scales a list of 2D points by some value relative to the origin
function scalePoints(points, factor) = [
  for (point = points)
    [point[0] * factor, point[1] * factor]
];

// Rotate a list of 2D points by some angle around the origin
function rotatePoints(points, angle) = [
    for (point = points)
        let (x = point[0], y = point[1])
            [x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle)]
];

// Generates points approximating an arc over a given angle
function arc(angle, res=1) = let(step=res*(angle)/ceil(angle)) [
  for (a = [0:step:angle]) [cos(a), sin(a)]
];

// Mirror a list of 2D points over the X axis.
function mirrorOverX(points) = [for (point = points) [point[0], -point[1]]];

// Copy and mirror a list of 2D points over the X axis
function copyMirrorPointsX(points) =
    concat(points, reverse(mirrorOverX(points)));

// Mirror a list of 2D points over the Y axis.
function mirrorOverY(points) = [for (point = points) [-point[0], point[1]]];

// Copy and mirror a list of 2D points over the Y axis
function copyMirrorPointsY(points) =
    concat(points, reverse(mirrorOverY(points)));