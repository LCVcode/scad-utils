function inches(x) = 25.4 * x;
function mm_to_inches(x) = x / 25.4;
function feet(x) = 12 * inches(x);
function mm_to_feet(x) = x / 304.8;

module scale_inches() {
  scale([25.4, 25.4, 25.4]) children();
}

module scale_feet() {
  scale([12, 12, 12]) inches() children();
}