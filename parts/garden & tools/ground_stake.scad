use <../../scad-utils/sketch.scad>;
use <../../scad-utils/list.scad>;

$fn=100;

function rounded_edge(angle=90, radius=1) = reverse(transform_2D(scale_factor=radius, translation=[-radius, -radius], points=arc(angle=angle)));

radius = 1.25;
height = 115;
diameter = 22;
channel_depth = 2 * radius;
channel_height = 2 * radius;
head_height = 8;

rotate_extrude()
polygon(concat(
  [[0, 0]],
  transform_2D(translation=[diameter/2, 0], points=rounded_edge(radius=radius)),
  transform_2D(translation=[diameter/2, -head_height], rotation=-90, points=rounded_edge(radius=radius)),
  reverse(transform_2D(translation=[diameter/2 - channel_depth, -head_height], rotation=90, points=rounded_edge(radius=radius))),
  reverse(transform_2D(translation=[diameter/2 - channel_depth, -head_height-channel_height], rotation=180, points=rounded_edge(radius=radius, angle=45))),
  transform_2D(translation=[diameter/2, -head_height-2*channel_height+radius], points=rounded_edge(radius=radius, angle=45)),
  [[diameter/2, -height + 25], [0, -height]]
));