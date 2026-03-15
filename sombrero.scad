//===================================================
// Sombrero function
// Main entry file with all user-editable parameters.
//===================================================
/* [Function Parameters] */

// Decay constant for the sombrero profile.
k = 0.18;

function f(x, y) = exp(-k * sqrt(x*x + y*y)) * cos(sqrt(x*x + y*y) * (180 / PI));

/* [Output type] */
// 1 = Surface, 2 = RiemannSum
output_mode = 1; // [1:Surface, 2:RiemannSum]

/* [Scaling] */
// Final model width in mm (x direction); height and depth scale proportionally
targetxwidth = 80;
verticalscalefactor = 10.0;
verticaltranslation = 25;

/* [Domain] */
xmin = -4*PI;
xmax = 4*PI;
ymin = -4*PI;
ymax = 4*PI;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 180;
smooth_ny = 180;

include <MathSurface3d.scad>;
