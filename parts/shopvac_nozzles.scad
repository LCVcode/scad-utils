$fn=125;

inner_diameter = 31.21;
outer_diameter = 35.6;
length = 41.94;

inner_radius = inner_diameter / 2;
outer_radius = outer_diameter / 2;
wall_thickness = outer_radius - inner_radius;

module vac_hose_mount() {
    center_radius = (inner_radius + outer_radius) / 2;
    
    rotate_extrude() {
        union() {
            translate([center_radius, 0, 0])
                square([wall_thickness, length], center=true);
            
            translate([center_radius, -length/2, 0])
                circle(wall_thickness / 2);
        }
    }
}

module fine_crevice_nozzle() {
    overlap = 1;
    neck_radius = inner_radius / 3;
    neck_length = length;
    tip_radius = 3.5;
    tip_length = 70;
    
    union() {
        translate([0, 0, -length/2])
            vac_hose_mount();
        rotate_extrude() {
            union() {
                polygon([[inner_radius, -overlap], 
                         [inner_radius, 0], 
                         [neck_radius, neck_length], 
                         [tip_radius, neck_length + tip_length], 
                         [tip_radius + wall_thickness, neck_length + tip_length], 
                         [neck_radius + wall_thickness, neck_length], 
                         [inner_radius + wall_thickness, 0], 
                         [inner_radius + wall_thickness, -overlap],
                ]);
                translate([tip_radius + wall_thickness / 2,
                           tip_length + neck_length,
                           0])
                    circle(wall_thickness / 2);
            }
        }
    }
}

fine_crevice_nozzle();