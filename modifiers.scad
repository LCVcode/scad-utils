module copy_mirror_x(obj) {
  children();
  mirror([1, 0, 0]) children();
}

module copy_mirror_y(obj) {
  children();
  mirror([0, 1, 0]) children();
}

module rotate_array(n) {
  n = max(n, 1);
  angle = 360 / n;
  
  for (i = [1:n]) {
    rotate([0, 0, i*angle]) children();
  }
}