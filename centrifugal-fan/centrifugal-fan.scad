include <../curve.scad>
include <../centrifugal-fan/common-vals.scad>
include <pipe.scad>

$fn = 120;

num_blades = 11;

module BottomPlate(major_diam, center_hole_diam, fastener_cutout_depth, fastener_diam, thickness) {
    
    difference() {
        //  Bottom plate - Main plate
        translate([0, 0, -thickness])
        cylinder(h = thickness, d = major_diam);
        
        //  Bottom plate - Central hole 
        translate([0, 0, -thickness - 0.1])
        cylinder(h = thickness + 0.2, d = center_hole_diam);
    }
    
    difference() {
        cylinder(h = fastener_cutout_depth, d = fastener_diam);
        size = fastener_diam/2;
        translate([0, 0, fastener_cutout_depth/2])
        cube([size, size, fastener_cutout_depth+0.2], true);
    }
}

module Blade(curve_angle, curve_height, blade_height, thickness) {
        //translate([0, curve_height, 0])
        linear_extrude(blade_height)
        arc_height(curve_angle, curve_height, thickness);
}

module BladeRing(outer_diam, ring_width, blade_height, num_blades, thickness) {
    
    difference() {
        for (i = [0 : num_blades]) {
            rotate([0, 0, i * 360 / num_blades])
            //color([0, 255, 0, 255])
            translate([0, outer_diam/2 - ring_width, 0])
            Blade(90, ring_width, blade_height, thickness);
        }
        //  Add cylinder to cut off extra
        translate([0, 0, -0.1])
        difference() {
            cylinder(h = blade_height+0.2, d = outer_diam*2);
            cylinder(h = blade_height+0.2, d = outer_diam);
        }
    }
}

module SupportRing(blades_outer_diam, blade_ring_width, blade_height, ridge_thickness, ridge_depth) {
    outer_diam = blades_outer_diam - blade_ring_width + ridge_thickness;
    inner_diam = outer_diam - ridge_thickness;
    translate([0, 0, blade_height-ridge_depth]) {
        difference() {
            cylinder(h = ridge_depth+0.1, d = outer_diam);
            translate([0, 0, -0.1])
            cylinder(h = ridge_depth+0.2, d = inner_diam);
        }
    }
}

module outlet_cube() {
    width = gCase_outer_diam/2 + gOutlet_length;
    height = gBlade_width + gThickness*2;
    depth = gThickness + gBlade_height + gCase_depth_gap*2;
    
    translate([0, gCase_outer_diam/2 -height, -gThickness])
    cube([width, height, depth]);
}

module outlet_hollow_cube() {
        yTrans = gCase_outer_diam/2 - gBlade_width - gThickness;
        translate([0, yTrans, 0])
        cube([gCase_outer_diam + gOutlet_length, gBlade_width, gBlade_height + gCase_depth_gap*2+0.2]);
}

module solid_case() {
    translate([0,0,-gThickness])
        cylinder(h = gBlade_height + gCase_depth_gap*2 + gThickness*2, d = gCase_outer_diam);
}

//  -- Defining components --
module blades() {
    BottomPlate(gWheel_outer_diam, gPinhole_diam, gFastener_depth, gFastener_outer_diam, gThickness);
    difference() {
        BladeRing(gBlades_outer_diam, gBlade_width, gBlade_height, num_blades, gThickness);
        SupportRing(gBlades_outer_diam, gBlade_width, gBlade_height, gBlade_support_ring_thickness, gBlade_support_ring_depth);
    }
}

module blades_support_ring() {
    translate([0, 0, gBlade_height]) {
        inner_rad_adjustment = 1.4;
        difference() {
            cylinder(h = gThickness, d = gBlades_outer_diam);
            cylinder(h = gThickness, d = gBlades_inner_diam*inner_rad_adjustment);
        }
    }
    
    thickness_offset = 0.2;
    SupportRing(gBlades_outer_diam, gBlade_width, gBlade_height, gBlade_support_ring_thickness - thickness_offset, gBlade_support_ring_depth);
}

module motor_nut() {
    tolerance = 0.2;
    dims = gFastener_outer_diam /2 -tolerance;
    halfDims = dims/2;
    
    difference() {
        translate([-halfDims, -halfDims, 0])
        cube([dims, dims, gFastener_depth]);
        
        translate([0, 0, -0.1])
        cylinder(h = gFastener_depth+0.2, d = gMotor_pin_diam +tolerance/2);
    }
}

module case_old() {
    difference() {
        stand_width = gCase_outer_diam*2/3;
        stand_height = gCase_outer_diam/2;
        translate([-stand_width/2, -stand_height, -gThickness])
        cube([stand_width, stand_height, gBlade_height+gCase_depth_gap*2 + gThickness]);
        solid_case();
    }
    difference() {
        difference() {
            outlet_cube();
            solid_case();
        }
        outlet_hollow_cube();
    }
    difference() {
        cylinder(h = gBlade_height + gCase_depth_gap*2, d =     gCase_outer_diam);
        
        outlet_hollow_cube();
        
        translate([0, 0, -0.1])
        cylinder(h = gBlade_height + gCase_depth_gap*2+0.2, d =gCase_outer_diam - gThickness*2);
    }
    translate([0, 0, -gThickness])
    
    difference() {
        cylinder(h = gThickness, d = gCase_outer_diam);
        translate([0, 0, -0.1])
        cylinder(h = gThickness+0.2, d = gMotor_podium_diam);
        
        xTrans = gMotor_screw_hole_diam/2 + gMotor_podium_diam/2 + gMotor_screw_hole_offset;
        translate([xTrans, 0, 0]) {
            cylinder(h = gThickness+0.2, d = gMotor_screw_hole_diam);
            translate([0, 0, gThickness/2])
            cylinder(h = gThickness/2, d = gMotor_screw_hole_diam+1);
        }
        translate([-xTrans, 0, 0]) {
            cylinder(h = gThickness+0.2, d = gMotor_screw_hole_diam);
            translate([0, 0, gThickness/2])
            cylinder(h = gThickness/2, d = gMotor_screw_hole_diam+1);
        }
    }

    //  Adding outlet lips
    //    Top lip
    translate([gCase_outer_diam/2 + gOutlet_length - gOutlet_lip_width, gCase_outer_diam/2, -gThickness])
    cube([gOutlet_lip_width, gOutlet_lip_height, gBlade_height + gCase_depth_gap*2 + gThickness]);

    //    Bottom lip
    translate([gCase_outer_diam/2 + gOutlet_length - gOutlet_lip_width, gCase_outer_diam/2-gOutlet_height - gThickness*2-gOutlet_lip_height, -gThickness])
    cube([gOutlet_lip_width, gOutlet_lip_height, gBlade_height + gCase_depth_gap*2 + gThickness]);
}

//  Doesn't include central hole(s)
module outer_case_sketch() {
    circle(d = gCase_outer_diam);

    total_outlet_len = gOutlet_length + gCase_outer_diam/2;
    outlet_yTrans = gCase_outer_diam/2-gOutlet_height - gThickness*2;
    translate([0, outlet_yTrans, 0]) {
    square(size=[total_outlet_len, gOutlet_height+gThickness*2], center=false);
        translate([gCase_outer_diam/2 + gOutlet_length-gOutlet_lip_width, 0, 0]) {
            translate([0, -gOutlet_lip_height, 0])
            square(size=[gOutlet_lip_width, gOutlet_lip_height], center=false);
            translate([0, gOutlet_height+gOutlet_lip_height, 0])
            square(size=[gOutlet_lip_width, gOutlet_lip_height], center=false);
        }
    }

    stand_height = gCase_outer_diam/4;
    stand_width = gCase_outer_diam*2/3;
    translate([-stand_width/2, -gCase_outer_diam/2, 0])
        square(size =[stand_width, stand_height]);
}

module inner_case_sketch() {
    circle(d = gCase_outer_diam-gThickness*2);

    total_outlet_len = gOutlet_length + gCase_outer_diam/2;
    outlet_yTrans = gCase_outer_diam/2-gOutlet_height - gThickness;
    translate([0, outlet_yTrans, 0]) {
    square(size=[total_outlet_len, gOutlet_height], center=false);
    }
}

module motor_holes_sketch() {
    circle(d = gMotor_podium_diam);

    offset = gMotor_screw_hole_offset + gMotor_podium_diam - gMotor_screw_hole_diam;
    translate([offset, 0, 0])
    circle(d = gMotor_screw_hole_diam);
    translate([-offset, 0, 0])
    circle(d = gMotor_screw_hole_diam);
}

module case() {
    case_height = gBlade_height + gThickness + gCase_depth_gap*2;

    difference() {
        linear_extrude(case_height)
        outer_case_sketch();

        
        translate([0, 0, gThickness])
        linear_extrude(case_height-gThickness+0.1)
        inner_case_sketch();

        linear_extrude(gThickness+0.1)
        motor_holes_sketch();
    }
}

module case_front() {
    tol = 0.2;
    outer_diam = gCase_outer_diam + gThickness*2+tol*2;
    zTrans = gBlade_height + gCase_depth_gap*2 + gThickness;

    tot_outlet_len = gCase_outer_diam/2 + gOutlet_length;

    translate([0, 0, zTrans]) {
        difference() {
            union() {
                cylinder(h = gThickness, d = outer_diam);

                translate([0, 0, -gFront_wrap_depth])
                pipe(height = gFront_wrap_depth, outer_diam = outer_diam, thickness = gThickness);

                translate([0, gOutlet_height, -gFront_wrap_depth])
                cube(size=[tot_outlet_len, gOutlet_height+gThickness*4, gFront_wrap_depth+gThickness], center = false);
            }

           translate([0, 0, -gFront_wrap_depth-0.1])
            cylinder(h = gFront_wrap_depth, d = gCase_outer_diam + tol*2);
            
            translate([0.1, gOutlet_height+gThickness+tol, -gFront_wrap_depth-gThickness])
            cube(size=[tot_outlet_len+0.1, gOutlet_height+gThickness*2-tol, gFront_wrap_depth+gThickness], center = false);

            cylinder(d=(gCase_front_center_hole_diam), h=gFront_wrap_depth, center=true);

            translate([gCase_outer_diam/2+gOutlet_length-gOutlet_lip_width-tol, gCase_outer_diam/4 -gThickness*3, -gBlade_height])
            cube([gOutlet_lip_width*2, gOutlet_height*2, gBlade_height*2]);

            height = 20; // Magic number
            width = gCase_outer_diam;
            translate([-width/2, -height*2, gThickness-gBlade_height*2-gThickness])
            cube([width, height, gBlade_height*2]);
        }
    }
}

//  -- Calling the components (so that they can be used) --
*translate([0, 0, gThickness]) {
    blades_support_ring();
    blades();
    motor_nut();
}
*case();
case_front();
