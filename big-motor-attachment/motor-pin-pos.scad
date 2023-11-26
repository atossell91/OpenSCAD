$fn = 120;

pin_tol = 0.6;
block_tol = 0.5;

pin_raw_diam = 3.13; //2.65
pin_inset = 0.48;
pin_depth = 5.99;
tab_offset = 0.5;

block_raw_height = 3;
base_cylinder_diam = 7.87; // Also block len

block_depth = 2.39;

pin_diam = pin_raw_diam + pin_tol;
block_height = block_raw_height + block_tol;

module block_sketch() {
    difference() {
        circle(d=base_cylinder_diam);

        square_height = (base_cylinder_diam - block_height)/2;
        translate([-base_cylinder_diam/2, block_height/2, 0])
        square([base_cylinder_diam, square_height]);

        translate([-base_cylinder_diam/2, -square_height-block_height/2, 0])
        square([base_cylinder_diam, square_height]);
    }
}

module pin_sketch() {

    difference() {
        circle(d=pin_diam);

        translate([-pin_diam/2, -pin_diam*3/2+pin_inset])
        square(pin_diam);
    }
}

module block() {
    linear_extrude(block_depth)
    block_sketch();
}

module pin() {
    linear_extrude(pin_depth)
    pin_sketch();
}

module motor_pin_pos() {
    union() {
        block();
        translate([0, 0, block_depth])
        pin();
    }
}
