//===================================================
// Monkey Saddle
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = x^3 - 3xy^2
function f(x, y) = x*x*x - 3*x*y*y;

/* [Output type] */
// 1 = Surface, 2 = RiemannSum
output_mode = 1; // [1:Surface, 2:RiemannSum]

/* [Scaling] */
targetxwidth = 80;
verticalscalefactor = 0.04;
verticaltranslation = 20;

/* [Domain] */
xmin = -2.5;
xmax = 2.5;
ymin = -2.5;
ymax = 2.5;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 140;
smooth_ny = 140;

include <MathSurface3d.scad>;
