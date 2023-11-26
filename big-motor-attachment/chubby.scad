$fn = 120;

diam = 30;
height = 2;


color([0.5, 0.5, 1, 0.5])
circle(d = diam);

color([0, 0.3, 0, 0.6])
square([diam, height], true);

h = height/2;
r = diam/2;
l = sqrt(r*r-h*h);
v = l*2;
color([0.3, 0, 0, 0.7])
square([v, height], true);
