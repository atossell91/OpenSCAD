include <../janet_fan_ring.scad>
include <../funnel.scad>
include <../round_funnel_connector.scad>
include <rounded_cuboid.scad>
include <mirror.scad>

$fn = 60;

union() {
    fan_outer_padding = 2.6;
    fan_inner_padding = -1.2;

    fan_stick_outer_diam = 65.95;
    fan_ring_padding = 2;
    fan_stick_diam = 2.4;
    fan_ring_thickness = 2;

    funnel_nozzle_diam = 13;
    funnel_nozzle_height = 20;
    funnel_thickness = 1;

    connector_height = 8;
    
    hook_width = 5;
    hook_height = fan_ring_thickness;
    
    hook_depth = 3.5;
    hook_top_height = 5;

    fan_stick_midline = fan_stick_outer_diam - fan_stick_diam;
    funnel_top_diam = fan_stick_outer_diam;
    funnel_top_height = funnel_top_diam;


    fan_ring_outer_diam = fan_stick_outer_diam + fan_outer_padding * 2;
    fan_ring_inner_diam = fan_stick_outer_diam - fan_stick_diam * 2 - fan_inner_padding * 2;

    fan_ring(fan_ring_inner_diam, fan_ring_outer_diam, fan_stick_midline, fan_stick_diam, fan_ring_thickness);

    difference() {
        translate([0, 0, -connector_height])
        cylinder(h = connector_height, d = funnel_top_diam + funnel_thickness);

        translate([0, 0, -connector_height -0.1])
        cylinder(h = connector_height + 0.2, d = funnel_top_diam);
    }

    translate([0, 0, -connector_height-funnel_top_height/2])
    funnel(funnel_top_diam, funnel_top_height/2, funnel_nozzle_diam, funnel_nozzle_height, funnel_thickness);
    
    mirror_x()
    union() {
        translate([fan_stick_outer_diam/2, -hook_depth/2, 0])
        rounded_cuboid(hook_width, hook_height, hook_depth, 1.5, false);
        
        translate([fan_stick_outer_diam/2+hook_width-hook_height, -hook_depth/2, 0])
        rounded_cuboid(hook_height, hook_height-hook_top_height, hook_depth, 1.5, false);
    }
}
