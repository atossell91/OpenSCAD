include <mirror.scad>

$fn = 60;

faucetInnerdiam = 20;
faucetOuterDiam = 23;
faucetDepth = 4;
thickness = 2;
screwDiam = 10;
screwDepth = 5;

module screwTab(screwDiam, offset, thickness) {
    outerDiam = screwDiam + thickness*2;
    xTrans = outerDiam/2 + offset;

    difference() {
        union() {
            translate([xTrans, 0, 0])
            circle(d = outerDiam);

            translate([0, -outerDiam/2, 0])
            square([xTrans, outerDiam]);
        }

        translate([xTrans, 0, 0])
        circle(d = screwDiam);
    }
}

module ring2d(outerDiam, thickness) {
    difference() {
        circle(d = outerDiam);
        innerDiam = outerDiam - thickness * 2;
        circle(d = innerDiam);
    }
}

numTabs = 2;
pie = 360 / numTabs;
linear_extrude(thickness) {
    ringThickness = faucetOuterDiam - faucetInnerdiam;
    backOffset = ringThickness;
    tabOffset = backOffset + thickness;
    ring2d(faucetOuterDiam, ringThickness);
    for (i = [0 : numTabs]) {
        rotate([0, 0, pie * i]) {
            translate([faucetOuterDiam/2 - backOffset, 0, 0])
            screwTab(screwDiam, tabOffset, thickness);
        }
    }
}

for (i = [0 : numTabs]) {
    linear_extrude(screwDepth)
    rotate([0, 0, pie * i]) {
        screwXTrans = screwDiam / 2 + thickness*2 + faucetOuterDiam/2;
        translate([screwXTrans, 0, 0])
        ring2d(screwDiam + thickness * 2, thickness);
    }
}

