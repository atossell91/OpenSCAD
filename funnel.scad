module funnel(funnel_diam, funnel_height, nozzle_diam, nozzle_height, thickness) {
    
    rotate_extrude()
    union() {
        hull() {
            translate([funnel_diam/2, funnel_height, 0])
            circle(d = thickness);
            
            xTrans = (thickness + nozzle_diam)/2;
            translate([xTrans, 0, 0])
            circle(d = thickness);
        }
        
        hull() {
            xTrans = (thickness + nozzle_diam)/2;
            translate([xTrans, 0, 0])
            circle(d = thickness);
            
            translate([xTrans, -nozzle_height, 0])
            circle(d = thickness);
        }
    }
}
