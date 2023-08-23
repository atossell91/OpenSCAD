module curve(outer_radius, height, thickness) {
    extra = 1;
    inner_radius = outer_radius - thickness;
    
    difference() {
        circle(outer_radius);
        circle(inner_radius);
        difference() {
            square((outer_radius + extra) *2, true);
            square(outer_radius + extra, false);
        }
        
        x_inner = sqrt(inner_radius * inner_radius - height * height);
        x_outer = sqrt(outer_radius * outer_radius - height * height);
        
        translate([0, height, 0])
        square([outer_radius + extra, outer_radius - height]);
        square([x_outer - thickness, outer_radius + extra]);
    }
}

module slice(angle, radius) {
    difference() {
        circle(radius);
        
        rotate([0, 0, angle])
        translate([-2*radius/2, 0, 0])
        square([2*radius, radius]);
        translate([-radius, -radius])
        square([2*radius, radius]);
    }
}

module slice_height(angle, height) {
    rad = height / sin(angle);
    slice(angle, rad);
}

module arc(angle, radius, width) {
    translate([-radius + width, 0, 0])
    difference() {
        slice(angle, radius);
        slice(angle, radius - width);
    }
}

module arc_height(angle, height, width) {
    radius = height / sin(angle);
    translate([-radius + width, 0, 0])
    difference() {
        slice(angle, radius);
        slice(angle, radius - width);
    }
}

//module pacman(angle, radius) {
//    
//    if (angle >= 360) {
//        circle(radius);
//    }
//    else if (angle == 0) {}
//    else {
//        a = angle;
//        rot = 0;
//        if (angle > 180) {
//            slice(180, radius);
//        }
//        
//        a = angle > 180 ? angle - 180 : angle;
//        rot = angle > 180 ? 180 : 0;
//        
//        echo("A2:", a);
//        rotate([0, 0, rot])
//        slice(a, radius);
//    }
//}
