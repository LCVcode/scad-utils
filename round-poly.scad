use <math.scad>

function norm_angle(angle) = (angle + 360) % 360;

// Flatten a nested list of 2D points
function flatten(points) = [
  for (sublist = points, point = sublist)
      point
];

/**
 * Extracts the local three points forming the corner of a polygon.
 * 
 * @param points List of points.
 * @param index Index around which to compute local angles.
 * @return List of local angles formed by the points around the specified index.
 */
function extract_local_points(points, index) = let(L=len(points)) [for (i=[0:2]) points[(index+i+L-1)%L]];

/**
 * Calculate the distance from the corner of an angle to the tangent point.
 *
 * @param points List of three points in (x, y, r) format
 * @return distance from the angle corner to the tangent point
 */
function tangent_point_dist(points) = (
  let(angle=angle_between_segments(points), theta=angle>180 ? abs(angle-360) : angle) points[1][2] / tan((180-theta)/2)
);

/*
 * Given a list of (x, y, r) points, amend angle between segments and tangent point distances to each point.
*/
function amend_point_list(points) = (
  [for (i=[0:len(points)-1]) let(local=extract_local_points(points, i)) concat(points[i], tangent_point_dist(local), angle_between_segments(local))]
);

/**
 * Validates a list of (x, y, r) points to ensure that adjacent radii do not overlap the length of their corresponding line segments.
 * 
 * @param points List of points formatted as [[x1, y1, r1], [x2, y2, r2], ...].
 * @return Boolean value indicating whether the list of points is valid.
 */
function validate_poly_path(points, index=0) = 
  let(A=points[index], B=points[(index+1)%len(points)], dist=norm_2D(B-A))
  index == len(points) ? true : (
    points[index][2] < 0 ? false : (
    dist <= A[3] + B[3] ? false : validate_poly_path(points, index+1)
  ));


function round_single_corner(ABC, angular_res=5) = (
  ABC[1][2] == 0 ? [[ABC[1][0], ABC[1][1]]] : (
    let(
      r = ABC[1][2],
      L = ABC[1][3],
      theta = ABC[1][4],
      AB=[ABC[1][0] - ABC[0][0], ABC[1][1] - ABC[0][1]],
      X = unit_2D(AB),
      Y = rot_left(X),
      BC = [ABC[2][0] - ABC[1][0], ABC[2][1] - ABC[1][1]],
      u_BC = unit_2D(BC),
      sig = dot_2D(Y, u_BC) > 0 ? 1 : -1,
      center = ABC[1] - L*X + sig*r*Y,
      alpha = normalize_angle(atan2(X[1], X[0])),
      beta = normalize_angle(atan2(BC[1], BC[0])),
      n = ceil(theta/angular_res),
      step = (theta < 180) ? theta / n : (360 - theta) / n
    )
    (normalize_angle(beta - alpha) > 0)
    ? [for (i=[0:n]) let(angle=alpha + sig*i*step - 90) center + [r * cos(angle), r * sin(angle)]]
    : [for (i=[0:n]) let(angle=alpha + sig*i*step + 90) center + [r * cos(angle), r * sin(angle)]]
  )
);

function round_all_corners(points, angular_res=5) = (
  [for (i=[0:len(points)-1]) round_single_corner(extract_local_points(points, i), angular_res)]
);

/**
 * Rounded Polygon
 * 
 * Generates a polygon with rounded corners based on a list of three or more points.
 * Each point in the list should be formatted as (x, y, r), where:
 * - x: X coordinate of the point
 * - y: Y coordinate of the point
 * - r: Radius of the round at that point
 * 
 * @param points List of three or more points formatted as (x, y, r).
 * @return Polygon with rounded corners.
 */
module round_poly(points, resolution=5) {
  points2 = amend_point_list(points);
  assert(validate_poly_path(points2));
  points3 = round_all_corners(points2, angular_res=resolution);
  polygon(flatten(points3));
}
