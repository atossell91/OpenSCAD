
module concavey(radius, thickness, p infill = 1) {
    
    fill = radius - thickness / 2;
    val = fill * cos(angle);
    
    translate([-val , 0, 0]) {
        cyl_offset = 0.2;
        
        difference() {
            rotate_extrude(angle = angle)
            difference() {
                square([radius, thickness]);
                
                translate([radius, thickness/2, 0])
                circle(d = thickness);
            }
            
            translate([0, 0, -cyl_offset/2])
            cylinder(h = thickness +cyl_offset, r = fill *  (1- infill / 100));
        }
    }
}

$fn = 120;
concavey(700, 25, 30);
