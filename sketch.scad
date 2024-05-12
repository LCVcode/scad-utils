use <list.scad>;

// Translate a list of 2D points
function translate_points(transform, points) = [
  for (point = points)
    [point[0] + transform[0], point[1] + transform[1]]
];

// Scales a list of 2D points by some value relative to the origin
function scale_points(factor, points) = [
  for (point = points)
    [point[0] * factor, point[1] * factor]
];

// Rotate a list of 2D points by some angle around the origin
function rotate_points(angle, points) = [
    for (point = points)
        let (x = point[0], y = point[1])
            [x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle)]
];

// Generates points approximating an arc over a given angle
function arc(angle, res=1) = let(step=res*(angle)/ceil(angle)) [
  for (a = [0:step:angle]) [cos(a), sin(a)]
];

// Mirror a list of 2D points over the X axis.
function mirror_over_x(points) = [for (point = points) [point[0], -point[1]]];

// Copy and mirror a list of 2D points over the X axis
function copy_mirror_points_x(points) =
    concat(points, reverse(mirrorOverX(points)));

// Mirror a list of 2D points over the Y axis.
function mirror_over_y(points) = [for (point = points) [-point[0], point[1]]];

// Copy and mirror a list of 2D points over the Y axis
function copy_mirror_points_y(points) =
    concat(points, reverse(mirrorOverY(points)));