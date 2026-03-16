//===================================================
// Monkey Saddle
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = x^3 - 3xy^2
function f(x, y) = x*x*x - 3*x*y*y;

/* [Output type] */
// 1 = Surface, 2 = Riemann sum, 3 = x slice, 4 = y slice, 5 = All x slices, 6 = All y slices, 7 = Holder (x), 8 = Holder (y)
output_mode = 8; // [1:Surface, 2:Riemann sum, 3:x slice, 4:y slice, 5:All x slices, 6:All y slices, 7:Holder (x), 8:Holder (y)]

/* [Scaling] */
targetxwidth = 80;
verticalscalefactor = 0.04;
verticaltranslation = 30;

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
// Number of intervals for XSlice / YSlice / AllXSlices / AllYSlices modes
num_slices = 15;
// Index (1-based) of the interval to render (XSlice / YSlice modes)
k = 3;
// Separate slices with a gap (for AllXSlices / AllYSlices modes)
separate_slices = true;
// Gap in mm between slices when separate_slices = true
slice_gap = 2.0;

/* [Holder Parameters] */
// Margin added around the surface footprint on each side (mm)
holder_margin = 3;
// Total height of the holder box (mm)
holder_height = 10;
// Depth of slots from the top of the holder (mm)
holder_slot_depth = 5;
// Extra clearance added to slot width and ends for fit (mm) — increase if too tight
slot_tolerance = 0.3;

include <MathSurface3d.scad>;
