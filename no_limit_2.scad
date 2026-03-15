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
// 1 = Surface, 2 = RiemannSum, 3 = XSlice, 4 = YSlice, 5 = AllXSlices, 6 = AllYSlices
output_mode = 1; // [1:Surface, 2:RiemannSum, 3:XSlice, 4:YSlice, 5:AllXSlices, 6:AllYSlices]

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

/* [Holder Parameters] */
// Render the holder for AllXSlices mode (overrides output_mode when true)
render_x_holder = false;
// Render the holder for AllYSlices mode (overrides output_mode when true)
render_y_holder = false;
// Margin added around the surface footprint on each side (mm)
holder_margin = 3;
// Total height of the holder box (mm)
holder_height = 15;
// Depth of slots from the top of the holder (mm)
holder_slot_depth = 10;
// Extra clearance added to slot width for fit (mm) — increase if too tight
slot_tolerance = 0.3;

include <MathSurface3d.scad>;
