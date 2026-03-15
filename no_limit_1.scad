//===================================================
// No Limit at the origin
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = ((x^2 - y^2)/(x^2 + y^2))^2, with f(0,0) defined as 0.
function f(x, y) = (x == 0 && y == 0)
    ? 0
    : pow((x*x - y*y) / (x*x + y*y), 2);

/* [Output type] */
// 1 = Surface, 2 = RiemannSum
output_mode = 1; // [1:Surface, 2:RiemannSum]

/* [Scaling] */
targetxwidth = 80;
verticalscalefactor = 1.5;
verticaltranslation = 2;

/* [Domain] */
xmin = -3;
xmax = 3;
ymin = -3;
ymax = 3;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 200;
smooth_ny = 200;

include <MathSurface3d.scad>;
