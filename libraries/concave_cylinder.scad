module concave_cylinder(inner_diam, thickness) {
    inner_rad = inner_diam /2;
    
    rotate_extrude()
    difference() {
        square([inner_rad, thickness]);
        
        translate([inner_rad, thickness/2, 0])
        circle(d = thickness);
    }
}