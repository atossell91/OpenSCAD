include <sausage.scad>

module rounded_cuboid(width, height, depth, roundness, center = true) {
    rad = roundness/2;
    
    rWidth = width - rad;
    rHeight = height - rad;
    rDepth = depth - rad;
    
    xTrans = center ? width/2 : 0;
    yTrans = center ? depth/2 : 0;
    zTrans = center ? height/2 : 0;
    
    translate([-xTrans, -yTrans, -zTrans])
    hull() {
        hull() {
            translate([rWidth, rDepth, rad])
            sphere(d = roundness);
            
            translate([rad, rDepth, rad])
            sphere(d = roundness);
            
            translate([rWidth, rad, rad])
            sphere(d = roundness);
            
            translate([rad, rad, rad])
            sphere(d = roundness);
        }
        
        hull() {
            translate([rWidth, rDepth, rHeight])
            sphere(d = roundness);
            
            translate([rad, rDepth, rHeight])
            sphere(d = roundness);
            
            translate([rWidth, rad, rHeight])
            sphere(d = roundness);
            
            translate([rad, rad, rHeight])
            sphere(d = roundness);
        }
    }
}

module slow_rounded_cuboid(width, height, depth, roundness, center = true) { 

    rWidth = width - roundness;
    rHeight = height - roundness;
    rDepth = depth - roundness;
    
    xTrans = width/2;
    yTrans = depth/2;
    zTrans = height/2;
    
    cX = center ? 0 : xTrans;
    cY = center ? 0 : yTrans;
    cZ = center ? 0 : zTrans;
    
    translate([cX, cY, cZ]) {
        translate([-xTrans, -yTrans, -zTrans]) { 
            sausage(height, roundness);
            
            translate([rWidth, 0, 0])
            sausage(height, roundness);
            
            translate([0, rDepth, 0])
            sausage(height, roundness);
            
            translate([rWidth, rDepth, 0])
            sausage(height, roundness);
            
            translate([0, 0, roundness])
            rotate([0, 90, 0])
            sausage(width, roundness);
            
            translate([0, rDepth, roundness])
            rotate([0, 90, 0])
            sausage(width, roundness);
            
            translate([0, 0, height])
            rotate([0, 90, 0])
            sausage(width, roundness);
            
            translate([0, rDepth, height])
            rotate([0, 90, 0])
            sausage(width, roundness);
            
            translate([0, 0, roundness])
            rotate([-90, 0, 0])
            sausage(depth, roundness);
            
            translate([rWidth, 0, roundness])
            rotate([-90, 0, 0])
            sausage(depth, roundness);
            
            translate([0, 0, height])
            rotate([-90, 0, 0])
            sausage(depth, roundness);
            
            translate([rWidth, 0, height])
            rotate([-90, 0, 0])
            sausage(depth, roundness);
        }
        cube([width, rDepth, rHeight], center = true);
        cube([rWidth, depth, rHeight], center = true);
        cube([rWidth, rDepth, height], center = true);
    }
}
