use <../../scad-utils/list.scad>;
use <../../scad-utils/modifiers.scad>;
use <../../scad-utils/shapes.scad>;
use <../../scad-utils/sketch.scad>;
use <../../scad-utils/bolts-and-screws.scad>;
use <../../utils/nuts.scad>;

$fn=30;

// Handle parameters
handleHeight = 25.3 * 3.8;
handleDepth = 25.3 * 2;
handleRadius = 25.3 / 2;
handleWidth = 20;
handleThickness = 5;
handleRounding = 1.5;

// Plate parameters
plateThickness = 5;
plateWidth = handleWidth + 35;
plateHeight = handleHeight + 55;
plateRadius = 25.3;

// Mount parameters
slotHeight = 5;
slotWidth = 12;
mountOffset = 25;

// Assembly parameters
doorThickness = 34;

module handleProfile() roundedRect(width=handleWidth, height=handleThickness, radius=handleRounding);

module handle() {
  copyMirrorY() translate([0, handleHeight/2, 0])
  linear_extrude(handleDepth - handleRadius)
  handleProfile();
  
  translate([0, 0, handleDepth])
  rotate([90, 0, 0])
  linear_extrude(handleHeight - 2*handleRadius, center=true)
  handleProfile();
  
  copyMirrorY() translate([0, handleHeight/2-handleRadius, handleDepth-handleRadius])
  rotate([0, -90, 0])
  rotate_extrude(angle=90, convexity=2)
  translate([handleRadius, 0, 0])
  rotate([0, 0, 90])
  handleProfile();
}

module plate() {
  radius = min(plateRadius, plateWidth/2);
  
  translate([0, 0, -plateThickness/2])
  rotate([90, 0, 0])
  
  union() {
    linear_extrude(plateHeight - 2*radius, center=true)
    roundedRect(width=plateWidth, height=plateThickness, radius=handleRounding);
        
    rotate([0, 90, 0])
    linear_extrude(plateWidth - 2*radius, center=true)
    roundedRect(width=plateHeight, height=plateThickness, radius=handleRounding);
        
    xStride = (plateWidth - 2*plateRadius) / 2;
    zStride = (plateHeight- 2*plateRadius) / 2;
        
    for (i = [-1:2:1]) for (j = [-1:2:1]) 
      translate([i*xStride, 0, j*zStride]) rotate([90, 0, 0]) rotate_extrude()
      intersection() {
        translate([0, -handleThickness/2, 0])
        square([plateWidth, 2*handleThickness]);
        roundedRect(width=2*radius, height=plateThickness, radius=handleRounding);
      }
  }
}

module filletProfile(radius) {
  tolerance = 0.1;
  difference() {
    translate([-tolerance, -tolerance, 0]) square(radius + tolerance);
    translate([radius, radius, 0]) circle(radius);
  }
}

module handleToPlateFillet(radius) {
  copyMirrorY() translate([0, handleHeight/2, 0])
  union() {
    copyMirrorY() translate([0, handleThickness/2, 0]) rotate([90, 0, 90]) 
    linear_extrude(handleWidth - 2*handleRounding, center=true)
      filletProfile(radius=radius);
    
    copyMirrorX() translate([handleWidth/2, 0, 0]) rotate([90, 0, 0]) 
    linear_extrude(handleThickness - 2*handleRounding, center=true)
      filletProfile(radius=radius);
  
    copyMirrorX() copyMirrorY()
    translate([handleWidth/2 - handleRounding, handleThickness/2 - handleRounding, 0]) rotate_extrude(angle=90) translate([handleRounding, 0, 0]) filletProfile(radius=radius);
  }
}

module baseHandle() {
  union() {
    handle();
    plate();
    handleToPlateFillet(radius=handleRounding);
  }
}

module nutSlot() {
  difference() {
    rotate_extrude()
    polygon(concat([ [0, 0],[0, slotHeight] ], translatePoints(reverse(arc(90, res=9)), [slotWidth/2, slotHeight - 1]), translatePoints(rotatePoints(arc(90, res=9), 180), [slotWidth/2 + 2, 1])));
    rotate([0, 0, -90]) nut_8_32_slot(length=18);
  }
}

module outsideHandle() {
  union() {
  difference() {
    baseHandle();
    
    // Screw holes
    translate([0, mountOffset, -50+3.2])
    rotate([0, 0, 0])
    8_32_2_machine_screw();
    translate([0, -mountOffset, -50+3.2])
    rotate([0, 0, 0])
    8_32_2_machine_screw();
  }
  
  // Nut slots
  translate([0, mountOffset, 0])
  nutSlot();
  translate([0, -mountOffset, 0])
  nutSlot();
  }
}

module insideHandle() {
  difference() {
    union() {
      baseHandle();
      copyMirrorY() translate([0, mountOffset, 0]) rotate_extrude()
      polygon(concat([[0, 0], [0, 2]], reverse(translatePoints([3.95, 1, 0], arc(90, res=5))), translatePoints([5.95, 1, 0], rotatePoints(180, arc(90, res=5)))));
    }

    translate([0, 0, -2*plateThickness + 50 - doorThickness - 3.2]) rotate([180, 0, 0]) {
    translate([0, mountOffset, 0])
    8_32_2_machine_screw();

    translate([0, -mountOffset, 0])
    8_32_2_machine_screw();
    }
  }
}

module handleAssembly() {
  // Outside handle
  translate([0, -doorThickness/2 - handleThickness, 0])
  rotate([90, 0, 0])
  outsideHandle();
  
  // Inside handle
  translate([0, doorThickness/2 + handleThickness, 0])
  rotate([-90, 0, 0])
  insideHandle();
  
  // Screws
  color("YellowGreen") {
    
  translate([0, 50-3.2 - doorThickness/2 - handleThickness, mountOffset])
  rotate([90, 0, 0])
  8_32_2_machine_screw();
  translate([0, 50-3.2 - doorThickness/2 - handleThickness, -mountOffset])
  rotate([90, 0, 0])
  8_32_2_machine_screw();
  
  }
}
handleAssembly();
