function inches(x) = 25.4 * x;
function feet(x) = 12 * inches(x);

module scale_inches() {
  scale([25.4, 25.4, 25.4]) children();
}

module scale_feet() {
  scale([12, 12, 12]) inches() children();
}