module fan_ring(inner_diam, outer_diam, hole_line_diam, stick_diam, thickness) {
    difference() {
        extra = 0.2;
        cylinder(h = thickness, d = outer_diam);
        
        translate([0, 0, -extra / 2])
        cylinder(h = thickness + extra, d = inner_diam);
        
        hole_line_rad = hole_line_diam/2;
        
        for (i = [0 : 3]) {
            rotate([0, 0, 90 * i])
            translate([0, hole_line_rad, -extra/2])
            cylinder(h = thickness + extra, d = stick_diam);
        }
    }
}
