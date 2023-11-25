module tube(height, outer_diam = undef, inner_diam = undef, thickness) {
    if (outer_diam == undef && inner_diam == undef) {
        echo("ERROR: Pipe diameter not specified");
    }
    else {
        outer = outer_diam == undef ? inner_diam + thickness*2 : outer_diam;
        inner = inner_diam == undef ? outer_diam - thickness*2 : inner_diam;

        difference() {
            cylinder(h = height, d = outer);
            translate([0, 0, -0.1])
            cylinder(h = height+0.2, d = inner);
        }
    }
}

tube(5, outer_diam = 40, thickness = 1);
