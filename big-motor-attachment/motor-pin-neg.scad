include <motor-pin-pos.scad>

insert_tol = -0.3;

square_side_raw = 3.16;

cyl_depth = pin_depth + block_depth;

fan_insert_depth = 8;
square_side = square_side_raw + insert_tol;
hull_offset = 5;

cyl_diam = base_cylinder_diam - 0.1;

module block_base_sketch() {
    circle(d = cyl_diam);

    xTrans = cyl_diam - (cyl_diam/2 - block_height);
    translate([xTrans, 0, 0])
    square(cyl_diam, true);
}

module motor_pin_neg() {
    difference() {
        cylinder(d = cyl_diam, h = cyl_depth);
        motor_pin_pos();
    }
}

module fan_insert_block() {
    translate([0, 0, pin_depth + block_depth + hull_offset])
    linear_extrude(fan_insert_depth)
    translate([-square_side/2, -square_side/2])
    square(square_side);
}

module neg_insert_connector() {
    hull() {
        translate([-square_side/2, -square_side/2])
        
        translate([0, 0, hull_offset])
        linear_extrude(1)
        square(square_side);

        linear_extrude(1)
        circle(d=cyl_diam);
    }
}

motor_pin_neg();
#block_base_sketch();
block_sketch();
