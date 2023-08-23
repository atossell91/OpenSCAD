include <straight_pipe.scad>
include <concave_cylinder.scad>

$fn = 120;

cup_outer_diam = 100;
cup_rim_thickness = 2;
cup_inner_diam = cup_outer_diam - cup_rim_thickness * 2;

thickness = 1.5;
lid_extension = 5 + thickness;

fan_diam = 65;

lid_outer_diam = cup_outer_diam + thickness *2;
lid_inner_diam = lid_outer_diam - thickness *2;
lid_lip_outer_diam = cup_inner_diam;
lid_lip_inner_diam = lid_lip_outer_diam - thickness *2;

straight_pipe(lid_extension, lid_outer_diam, thickness);
straight_pipe(lid_extension, lid_lip_outer_diam, thickness);
difference() {
    cylinder(h = thickness, d = lid_outer_diam - thickness);

    extra = 0.1;
    translate([0, 0, -extra])
    concave_cylinder(fan_diam, thickness+extra*2);
}
