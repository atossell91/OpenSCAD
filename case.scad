module shell_sketch(diam, outlet_len, outlet_height) {
    rad = diam /2;
    circle(d = diam);

    translate([0, rad-outlet_height, 0])
    square([rad + outlet_len, outlet_height]);
}

module shell(diam, outlet_len, outlet_height, depth, thickness) {
    rad = diam/2;
    linear_extrude(thickness)
    shell_sketch(diam, outlet_len, rad/2);
    translate([0, 0, thickness  ])
    linear_extrude(depth)
    difference() {
        shell_sketch(diam, outlet_len, rad/2);
        shell_sketch(diam - thickness*2, outlet_len + thickness, rad/2-thickness*2);
    }
}

module foot2(diam, thickness) {
    rad = diam /2;

    hThickness = thickness/2;
    len = rad / (2* sqrt(2)) + hThickness;

    union() {
        translate([-hThickness, 0, 0])
        square([len - hThickness, thickness]);

        translate([len-hThickness*2, hThickness, 0])
        circle(d = thickness);
    }
}

module foot(length, thickness, back_len = undef) {
    back_len = back_len == undef ? 0 : back_len;

    hThickness = thickness/2;

    union() {
        translate([-back_len, 0, 0])
        square([length + back_len - hThickness, thickness]);

        translate([length-hThickness, hThickness, 0])
        circle(d = thickness);
    }

}

module feet(diam, thickness, depth, lip, cover_thickness) {
    rad = diam/2;
    hThickness = thickness/2;
    bLen = hThickness;

    rrt = 1/sqrt(2);
    hComp = rad - rad * rrt;

    moveAmt = rad;

    //  Added 1 (rad + 1... for cover thickness
    foot_len = (rad + cover_thickness - hThickness) * (sqrt(2) - 1);

    rotate([0, 0, -45])
    translate([moveAmt, -hThickness, 0])
    foot(foot_len, thickness, back_len = bLen);

    rotate([0, 0, -135])
    translate([moveAmt, -hThickness, 0])
    foot(foot_len, thickness, back_len = bLen);

    cb = hThickness - rrt * hThickness;
    
    // Angle
    xComp = hComp - hThickness;
    yComp = hComp + lip + hThickness;
    angle = atan(yComp / xComp) - 45; // Len, not comp
    echo("ANGLE: ", angle);
    
    // Length
    xLen = xComp + hThickness * sin(angle);
    yLen = yComp + hThickness * cos(angle);
    len = sqrt(xLen * xLen + yLen * yLen);

    rotate([0, 0, -225]) //-225
    translate([moveAmt, 0, 0])
    rotate([0, 0, -angle])
    translate([0, -hThickness, 0])
    foot(len, thickness, back_len = bLen);
}

module outet_lips(lip_width, lip_height,outlet_len, outlet_height, case_diam, case_depth) {
    rad = case_diam/2;
    translate([rad + outlet_len - lip_width, rad, 0])
    square([lip_width, lip_height]);

    translate([rad + outlet_len - lip_width, rad - outlet_height - lip_height, 0])
    square([lip_width, lip_height]);
}

module motor_holes(center_hole_diam, outer_hole_offset, outer_hole_diam, num_outer_holes) {
    circle(d = center_hole_diam);

    for (i = [0 : num_outer_holes]) {
        angle = i * (360 / num_outer_holes);

        rotate([0, 0, angle])
        translate([center_hole_diam/2 + outer_hole_diam/2 + outer_hole_offset, 0, 0])
        circle(d = outer_hole_diam);
    }
}

$fn = 120;

diam = 90;
outlet_len = 10;
outlet_height = diam/4;
depth = 30;
thickness = 2;
lip = 2;
cover_thickness = 1; // Outer bit, i.e the bit that wraps around the 'circle'

difference() {
    shell(diam, outlet_len, outlet_height, depth, thickness);

    translate([0, 0, -0.1])
    linear_extrude(thickness + 0.2)
    motor_holes(20, 20, 3, 3);
}
linear_extrude(depth + thickness) {
feet(diam, thickness+1, depth, lip, cover_thickness);

outet_lips(thickness, lip, outlet_len, outlet_height, diam, depth + thickness);
}
%square(120, 120, center = true);
