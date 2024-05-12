use <list.scad>;

// Translate a 2D point
function translate_point(translation, point) = [
  point[0] + translation[0],
  point[1] + translation[1]
];

// Translate a list of 2D points
function translate_points(translation, points) = [for (point = points) translate_point(translation, point)];
  
// Rotate a 2D point about the origin
function rotate_point(angle, point) = [point[0]*cos(angle) - point[1]*sin(angle), point[0]*sin(angle) + point[1]*cos(angle)];

// Rotate a list of 2D points by some angle around the origin
function rotate_points(angle, points) = [for (point = points) rotate_point(angle, point)];
  
// Scale the distance between a 2D point and the origin
function scale_point(factor, point) = [point[0] * factor, point[1] * factor];

// Scales a list of 2D points by some value relative to the origin
function scale_points(factor, points) = [for (point = points) scale_point(factor, point)];

// Transformation of a list of 2D points, including scaling, rotation, and translation
function transform_2D(scale_factor = 1, rotation = 0, translation = [0, 0], points) = [
  for (point = points)
    translate_point(translation, rotate_point(rotation, scale_point(scale_factor, point)))
];


// Generates points approximating an arc over a given angle
function arc(angle, res=5) = let(step=res*(angle)/ceil(angle)) [
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