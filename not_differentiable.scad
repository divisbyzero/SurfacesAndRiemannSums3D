//===================================================
// A function with both partial derivatives equal to zero at the origin, but not differentiable there.
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = xy/(x^2 + y^2), with f(0,0) defined as 0.
function f(x, y) = (x == 0 && y == 0)
    ? 0.5
    : x*y / (x*x + y*y);

/* [Output type] */
// 1 = Surface, 2 = RiemannSum
output_mode = 1; // [1:Surface, 2:RiemannSum]

/* [Scaling] */
// Final model width in mm (x direction); height and depth scale proportionally
targetxwidth = 80;
verticalscalefactor = 0.5;
verticaltranslation = 12;

/* [Domain] */
xmin = -1;
xmax = 1;
ymin = -1;
ymax = 1;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 100;
smooth_ny = 100;

include <MathSurface3d.scad>;
