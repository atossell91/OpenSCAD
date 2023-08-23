module pipe(height, outer_diam, thickness) {
    difference() {
        cylinder(h = height, d = outer_diam);

        translate([0, 0, -0.1])
        cylinder(h = height+0.2, d = outer_diam - thickness*2);
    }
}
