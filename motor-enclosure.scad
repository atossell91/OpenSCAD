gThickness = 2;

module enclosure(motor_diam, motor_len, thickness) {
    enclosure_outer_len = motor_len + thickness;
    enclosure_outer_diam = motor_diam;

    enclosure_inner_len = motor_len;
    enclosure_inner_diam = motor_diam;

    difference() {
        %cylinder(h = enclosure_outer_len, d = enclosure_outer_diam);

        #translate([0, 0, thickness])
        cylinder(h = enclosure_inner_len, enclosure_inner_diam);
    }
}

$fn = 120;

enclosure(10, 20, gThickness);
