include <mirror.scad>

module Clip(width, depth, gap, thickness) {
    xTrans = gap + thickness;
    yTrans = depth + thickness;
    zTrans = width/2;
    
    union() {
        hull()
        mirror_z()
        hull()
        mirror_x()
        translate([xTrans, yTrans, zTrans])
        sphere(d = thickness);
        
        mirror_x()
        hull()
        mirror_z()
        hull() {
            translate([xTrans, yTrans, -zTrans])
            sphere(d = thickness);
            
            translate([xTrans, 0, -zTrans])
            sphere(d = thickness);
        }
    }
}