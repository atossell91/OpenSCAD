tolerence = 0.0;
thickness = 1.5;
width = 12;
pi_gap = 1.75;
bracket_gap = 4.05;
angle = 90;
top_depth = 35;

depth = width;
t_pi_gap = pi_gap + tolerence;
t_bracket_gap = bracket_gap + tolerence;

module clip(width, depth, gap, thickness) {
    cube([width, thickness, gap + thickness * 2]);
    translate([0, thickness, 0]) {
        cube([width, depth, thickness]);
        translate([0, 0, thickness + gap]) cube([width, depth, thickness]);
    }
}

union() {
    //Pi
    clip(top_depth+thickness, depth, t_pi_gap, thickness);
    
    xTrans = (depth +thickness)/2;
    yTrans = (top_depth + thickness)/2;
    zTrans = t_pi_gap + thickness;

    // Bracket
    translate([yTrans, xTrans, zTrans])
    rotate([0, 0, angle])
    translate([-xTrans, -yTrans, 0])
    clip(width+thickness, top_depth, t_bracket_gap, thickness);
}