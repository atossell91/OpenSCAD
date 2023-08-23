module curved_bracket(width, height, thickness) {
    r = (width * width + height * height) / (2 * height);
    
    cylinder_len = thickness + 0.2;
    
    translate([0, -r+height, thickness/2])
    difference() {
        translate([0, r-height, -thickness/2])
        cube([width, height, thickness]);
        
        translate([0, 0, -cylinder_len/2])
        cylinder(h = cylinder_len, r = r);
    }
}
