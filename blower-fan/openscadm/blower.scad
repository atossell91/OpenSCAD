$fn = 120;

max_diam = 90;
max_nozzle_width = 30;
nozzle_length = 45 + 15;
wall_thickness = 3;
panel_thickness = 2;
wall_depth = 30;

top_panel_inset = 10;
top_panel_ring_hole_diam = 6;
top_panel_ring_thickness = 3;
top_panel_struts = 5;

bottom_panel_shaft_hole_diam = 10;
bottom_panel_screw_hole_diam = 3;
bottom_panel_screw_hole_offset = 10;
bottom_panel_num_screws = 3;

bottom_panel_screw_inset_diam = bottom_panel_screw_hole_diam + 2*2;
bottom_panel_screw_inset_depth = panel_thickness/2;

inner_diam = max_diam - wall_thickness * 2;
inner_nozzle_width = max_nozzle_width - wall_thickness *2;

module blower_sketch(diam, outlet_width, outlet_length) {

    rad = diam/2;

    xTrans = rad - outlet_width;
    yTrans = 0;

    translate([xTrans, yTrans, 0])
    square([outlet_width, outlet_length]);

    circle(d = diam);
}

module blower_wall_sketch(max_diam, max_nozzle_width, nozzle_length, wall_thickness) {
    difference() {
        blower_sketch(max_diam, max_nozzle_width, nozzle_length);

        inner_diam = max_diam - wall_thickness *2;
        inner_nozzle_width = max_nozzle_width - wall_thickness*2;
        inner_nozzle_length = nozzle_length + 0.1;

        blower_sketch(inner_diam, inner_nozzle_width, inner_nozzle_length);
    }
}

module top_panel_sketch() {
    hole_diam = max_diam - top_panel_inset *2;

    difference() {
        blower_sketch(max_diam, max_nozzle_width, nozzle_length);
        circle(d = hole_diam);
    }

    ring_outer_diam = top_panel_ring_hole_diam + top_panel_ring_thickness *2;

    difference() {
        circle(d = ring_outer_diam);
        circle(d = top_panel_ring_hole_diam);
    }

    strut_len = hole_diam/2 - top_panel_ring_hole_diam/2;
    strut_width = top_panel_ring_thickness;
    num_struts = top_panel_struts;
    angle_amt = 360 / num_struts;

    for (i = [0: num_struts]) {
        rotate([0, 0, angle_amt * i])
        translate([top_panel_ring_hole_diam/2, -strut_width/2, 0])
        square([strut_len , strut_width]);
    }
}

module bottom_panel_sketch() {

    screw_angle = 360 / bottom_panel_num_screws;
    difference() {
        blower_sketch(max_diam, max_nozzle_width, nozzle_length);
        circle(d = bottom_panel_shaft_hole_diam);

        for (i = [0 : bottom_panel_num_screws]) {
            rotate([0, 0, i * screw_angle])
            translate([bottom_panel_screw_hole_offset, 0, 0])
            circle(d = bottom_panel_screw_hole_diam);
        }
    }
}

module foot_sketch(width, length, angle, rev_len = 0) {
    yTrans = length - width/2;
    rotate([0, 0, angle])
    translate([0, -yTrans, 0]) {
        translate([-width/2, 0, 0])
        square([width, yTrans + rev_len]);
        circle(d = width);
    }
}

module feet() {
    rad = max_diam/2;
    len = sqrt(2*rad*rad) - rad;
    width = 2;
    offset = -max_diam/2;

    linear_extrude(wall_depth + panel_thickness) {
        rotate([0, 0, 45])
        translate([0, offset, 0])
        foot_sketch(width, len, 0, 1);

        rotate([0, 0, -45])
        translate([0, offset, 0])
        foot_sketch(width, len, 0, 1);

        rotate([0, 0, -135])
        translate([0, offset, 0])
        foot_sketch(width, len, 0, 1);
    }
}

module blower_wall(max_diam, max_nozzle_width, nozzle_length, wall_depth, wall_thickness) {
    linear_extrude(wall_depth)
    blower_wall_sketch(max_diam, max_nozzle_width, nozzle_length, wall_thickness);
}

module bottom_wall() {
    slice = wall_thickness/3;
    depth = wall_depth/2;
    inner_diam = max_diam - slice*2;
    inner_nozzle = max_nozzle_width -slice*2;
    blower_wall(max_diam, max_nozzle_width, nozzle_length, wall_depth, slice);
    blower_wall(inner_diam, inner_nozzle, nozzle_length, depth, slice);
}

module top_wall() {
    slice = wall_thickness/3;
    depth = wall_depth/2;
    mid_diam = max_diam - slice*2;
    mid_nozzle = max_nozzle_width -slice*2;
    inner_diam = mid_diam - slice*2;
    inner_nozzle = mid_nozzle -slice*2;

    translate([0, 0, depth])
    blower_wall(mid_diam, mid_nozzle, nozzle_length, depth, slice);
    
    blower_wall(inner_diam, inner_nozzle, nozzle_length, wall_depth, slice);
}

module top_panel() {
    linear_extrude(panel_thickness)
    top_panel_sketch();
}

module bottom_panel() {

    yTrans = panel_thickness - bottom_panel_screw_inset_depth;
    screw_angle = 360 / bottom_panel_num_screws;

    difference() {
        linear_extrude(panel_thickness)
        bottom_panel_sketch();

        for (i = [0 : bottom_panel_num_screws]) {
            rotate([0, 0, i*screw_angle])
            translate([bottom_panel_screw_hole_offset, 0, yTrans])
            cylinder(d=bottom_panel_screw_inset_diam, h=bottom_panel_screw_inset_depth);
        }
    }
}

module shell_top() {
    translate([0, 0, wall_depth])
    top_panel();
    top_wall();
}

module shell_bottom() {
    translate([0, 0, panel_thickness])
    bottom_wall();
    bottom_panel();
    feet();
}

translate([0, 0, panel_thickness+0.5])
shell_top();
shell_bottom();
