include <../centrifugal-fan/common-vals.scad>

ring_inner_diam = gBlade_support_ring_outer_diam - gBlade_support_ring_thickness*2;

cylinder(h = gThickness, d = gBlade_support_ring_outer_diam);

translate([0, 0, -gBlade_support_ring_depth])
difference() {
    cylinder(gBlade_support_ring_depth, d = gBlade_support_ring_outer_diam);

    translate([0, 0, -0.1])
    cylinder(gBlade_support_ring_depth + 0.2, d = ring_inner_diam);
}
