//===================================================
// Monkey Saddle
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = x^3 - 3xy^2
function f(x, y) = x*x*x - 3*x*y*y;

/* [Output type] */
// 1 = Surface, 2 = RiemannSum, 3 = XSlice, 4 = YSlice, 5 = AllXSlices, 6 = AllYSlices
output_mode = 6; // [1:Surface, 2:RiemannSum, 3:XSlice, 4:YSlice, 5:AllXSlices, 6:AllYSlices]

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

/* [Slice Parameters] */
// Number of x-intervals for XSlice mode
num_slices_x = 20;
// Index (1-based) of the x-interval to render
kx = 8;
// Number of y-intervals for YSlice mode
num_slices_y = 20;
// Index (1-based) of the y-interval to render
ky = 3;
// Separate slices with a gap (for AllXSlices / AllYSlices modes)
separate_slices = true;
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
