// Perform modulus operation like Python's %
function py_mod(value, mod) = value - mod * floor(value / mod);

// Convert any degree value to its equivalent in the (-180, 180] range
function normalize_angle(angle) = 
    let(mod_angle = py_mod(angle, 360))
    mod_angle > 180 ? mod_angle - 360 : mod_angle;

function dot_2D(v1, v2) = v1[0]*v2[0] + v1[1]*v2[1];

function norm_2D(vec) = is_undef(vec[0]) || is_undef(vec[1]) 
    ? undef
    : sqrt(vec[0]*vec[0] + vec[1]*vec[1]);

function unit_2D(vec) = let(dist=norm_2D(vec)) dist==0 ? [0, 0] : vec/dist;

// Rotate a 2D vector left by 90 degrees
function rot_left(vec) = [-vec[1], vec[0]];

/**
 * Computes the angle between three line segments given as a list of three points.
 * Returned angle represents the angle of a left turn to align the first segment with the second.
 * 
 * @param points List of points formatted as [[x1, y1], [x2, y2], [x3, y3]].
 * @return Angle between the vectors AB and BC in degrees.
 */
function angle_between_segments(points) = (
    let(
        A = points[0],
        B = points[1],
        C = points[2],
        angle_AB = atan2(B[1] - A[1], B[0] - A[0]),
        angle_BC = atan2(C[1] - B[1], C[0] - B[0])
    )
    (360 + angle_BC - angle_AB) % 360
);