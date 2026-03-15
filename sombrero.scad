//===================================================
// Sombrero function
// Main entry file with all user-editable parameters.
//===================================================
/* [Function Parameters] */

// Decay constant for the sombrero profile.
k = 0.18;

function f(x, y) = exp(-k * sqrt(x*x + y*y)) * cos(sqrt(x*x + y*y) * (180 / PI));

/* [Output type] */
// 1 = Surface, 2 = RiemannSum, 3 = XSlice, 4 = YSlice, 5 = AllXSlices, 6 = AllYSlices
output_mode = 1; // [1:Surface, 2:RiemannSum, 3:XSlice, 4:YSlice, 5:AllXSlices, 6:AllYSlices]

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

/* [Slice Parameters] */
// Number of x-intervals for XSlice mode
num_slices_x = 8;
// Index (1-based) of the x-interval to render
kx = 4;
// Number of y-intervals for YSlice mode
num_slices_y = 8;
// Index (1-based) of the y-interval to render
ky = 4;
// Separate slices with a gap (for AllXSlices / AllYSlices modes)
separate_slices = false;
// Gap in mm between slices when separate_slices = true
slice_gap = 1.0;

include <MathSurface3d.scad>;
