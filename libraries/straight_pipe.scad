module straight_pipe(length, outer_diameter, thickness) {
    hThickness = thickness /2;
    outer_rad = outer_diameter/2;
    
    length = length < thickness ? thickness : length;
    
    rotate_extrude(angle = 360)
    translate([outer_rad - hThickness, 0,  0])
    rotate([0, 0, 90])
    hull() 
    {
        translate([hThickness, 0, 0])
        circle(d = thickness);
        
        translate([length - hThickness, 0, 0])
        circle(d = thickness);
    }
}

module straight_pipe_inner(length, inner_diameter, thickness) {
    diam = inner_diameter + 2 * thickness;
    straight_pipe(length, diam, thickness);
}
