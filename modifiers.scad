module copyMirrorX(obj) {
  children();
  mirror([1, 0, 0]) children();
}

module copyMirrorY(obj) {
  children();
  mirror([0, 1, 0]) children();
}

module rotateArray(n) {
  n = max(n, 1);
  angle = 360 / n;
  
  for (i = [1:n]) {
    rotate([0, 0, i*angle]) children();
  }
}