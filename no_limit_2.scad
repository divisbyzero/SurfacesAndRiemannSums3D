//===================================================
// No Limit at the origin
// Main entry file with all user-editable parameters.
//===================================================

/* [Function Parameters] */
// f(x, y) = x^2/(x^2 + y^4), with f(0,0) defined as 1.
function f(x, y) = (x == 0 && y == 0)
    ? 1
    : x*x / (x*x + y*y*y*y);

/* [Output type] */
// 1 = Surface, 2 = RiemannSum
output_mode = 1; // [1:Surface, 2:RiemannSum]

/* [Scaling] */
targetxwidth = 80;
verticalscalefactor = 1.0;
verticaltranslation = 1;

/* [Domain] */
xmin = -2;
xmax = 2;
ymin = -2;
ymax = 2;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 200;
smooth_ny = 200;

include <MathSurface3d.scad>;
