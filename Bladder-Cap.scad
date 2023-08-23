$fn = 60;

thickness = 2.5;
diam = 11;
depth = 15;

module cup(diam, depth, thickness) {
    yTrans = depth/2;
    xTrans = (thickness + diam) /2;
    
    translate([0, 0, (depth-thickness)/2])
    linear_extrude(thickness)
    circle(d = (diam + thickness));
    
    rotate_extrude(angle = 360)
    //rotate([0, 0, 0])
    union() {
            
        hull() {
            translate([xTrans, yTrans, 0])
            circle(d = thickness);
            
            translate([xTrans, -yTrans, 0])
            circle(d = thickness);
        }
    }
}

cup(diam, depth, thickness);
