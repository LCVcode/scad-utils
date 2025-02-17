module copy_mirror_x(obj) {
  children();
  mirror([1, 0, 0]) children();
}

module copy_mirror_y(obj) {
  children();
  mirror([0, 1, 0]) children();
}

module copy_rotate(angle) {
  children();
  
  rotate([0, 0, angle])
  children();
}

module rotate_array(n) {
  n = max(n, 1);
  angle = 360 / n;
  
  for (i = [1:n]) {
    rotate([0, 0, i*angle]) children();
  }
}

// Takes only the positive x portion of a 2D shape
module take_x() {
  size = 10000;
  difference() {
    children();
    translate([-size/2, 0, 0])
    square(size=size, center=true);
  }
}