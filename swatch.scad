use <scad-utils/scale.scad>

$fn = $preview ? 16 : 128;

// The filament color, as printed on the packaging
COLOR = "TRUE WHITE";

// The manufacturer of the filament
MANUFACTURER = "HATCHBOX";

// The filament material.  Usually PLA, PETG, or ABS
MATERIAL = "PLA";

// Swatch parameters
WIDTH = inches(2.1);
HEIGHT = inches(1.1);
THICKNESS = 6;
RADIUS = 5;
HOLE_DIAMETER = 3;
ROUND = 2;
FONT = "Bahnschrift:style=Bold";

// Parameter cleanup (do not change)
_ROUND = min(ROUND, THICKNESS/2-0.01);

module base_swatch() {
  rotate([180, 0, 0])
  linear_extrude(THICKNESS)
  minkowski() {
    circle(r=RADIUS);
    square([WIDTH-RADIUS, HEIGHT-RADIUS], center=true);
  }
}

module base_swatch_2() {
  r = 2 * (_ROUND + RADIUS);
  translate([0, 0, -THICKNESS + _ROUND])
  minkowski() {
    sphere(r=_ROUND);
    linear_extrude(THICKNESS - 2*_ROUND)
    minkowski() {
      circle(r=RADIUS);
      square([WIDTH-r, HEIGHT-r], center=true);
    }
  }
}

module through_hole() {
  r = 2 * (_ROUND + RADIUS);
  translate([(WIDTH-r)/2, -(HEIGHT-r)/2, -THICKNESS/2]) {
    cylinder(h=2*THICKNESS, d=HOLE_DIAMETER, center=true);
    translate([0, 0, 1])
    cylinder(h=THICKNESS, d1=HOLE_DIAMETER, d2=2*HOLE_DIAMETER);
    translate([0, 0, -THICKNESS-1])
    cylinder(h=THICKNESS, d1=2*HOLE_DIAMETER, d2=HOLE_DIAMETER);
  }
}

module swatch_text() {
  translate([0, 3, -THICKNESS/3])
  linear_extrude(THICKNESS) {
    text(COLOR, size=6, halign="center", font=FONT);
    translate([0, -7, 0])
    text(MATERIAL, size=4, halign="center", font=FONT);
    translate([0, -12, 0])
    text(MANUFACTURER, size=4, halign="center", font=FONT);
  }
}

module swatch() {
  difference() {
    base_swatch_2();
    through_hole();
    swatch_text();
  }
}
swatch();
