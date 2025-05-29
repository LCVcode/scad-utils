use <circles.scad>

INCH_TO_MM = 25.4;
TOL = 0.1;

3_4_OD = 1.05 * INCH_TO_MM;
3_4_ID = 0.804* INCH_TO_MM;

module 3_4_pipe(length, center=true) {
    linear_extrude(INCH_TO_MM * length, center=center)
    ring(outer_radius=3_4_OD/2, inner_radius=3_4_ID/2);
}
*3_4_pipe(length=0.75);

module 3_4_connector_inner(length, thickness, center=true) {
    linear_extrude(INCH_TO_MM * length, center=center)
    ring(outer_radius=3_4_ID/2 - TOL, inner_radius=3_4_ID/2 - INCH_TO_MM * thickness);
}
3_4_connector_inner(length=0.75, thickness = 0.1);

module 3_4_connector_outer(length, thickness, center=true) {
    linear_extrude(INCH_TO_MM * length, center=center)
    ring(outer_radius=3_4_OD/2 + INCH_TO_MM * thickness, inner_radius=3_4_OD/2 + TOL);
}
3_4_connector_outer(length=0.75, thickness = 0.1);