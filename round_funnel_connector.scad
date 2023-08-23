module round_funnel(outer_diam, thickness, height) {
    radius = outer_diam/2;
    x = sqrt(radius * radius - height * height);
    rotate_extrude()
    difference() {
        circle(radius);
        circle(radius - thickness);
        
        extra = 0.1;
        translate([-radius - extra, -radius - extra, 0])
        square([(radius + extra) * 2, radius + extra]);
        
        translate([-radius - extra, height, 0])
        square([(radius + extra) * 2, radius + extra]);
        
        translate([-radius - extra, -radius - extra, 0])
        square([radius + extra, (radius + extra) * 2]);
        
        square([x-thickness, height+extra]);
    }
}
