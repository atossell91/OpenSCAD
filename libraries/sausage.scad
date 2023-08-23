module sausage(length, diameter, center = false) {
    radius = diameter/2;
    stick_len = length - diameter;
    
    xTrans = center ? 0 : radius;
    yTrans = center ? 0 : radius;
    zTrans = center ? -stick_len/2 : radius;
    
    translate([xTrans, yTrans, zTrans])
    union() {
        cylinder(stick_len, d = diameter);
        
        translate([0, 0, stick_len])
        sphere(d = diameter);
        
        sphere(d = diameter);
    }
}
