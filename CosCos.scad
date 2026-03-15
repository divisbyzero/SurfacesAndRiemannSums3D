//===================================================
// Cosine-Cosine Surface
// Main entry file with all user-editable parameters.
//===================================================

/* [Function] */
// f(x, y) = cos(π x) cos(π y)
function f(x, y) = cos(x * 180) * cos(y * 180);

/* [Output type] */
// 1 = Surface, 2 = Riemann sum, 3 = x slice, 4 = y slice, 5 = All x slices, 6 = All y slices, 7 = Holder (x), 8 = Holder (y)
output_mode = 1; // [1:Surface, 2:Riemann sum, 3:x slice, 4:y slice, 5:All x slices, 6:All y slices, 7:Holder (x), 8:Holder (y)]

/* [Scaling] */
// Final model width in mm (x direction); height and depth scale proportionally
targetxwidth = 80;
verticalscalefactor = 0.5;
verticaltranslation = 20;

/* [Domain] */
xmin = -2;
xmax = 2;
ymin = -2;
ymax = 2;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 100;
smooth_ny = 100;

/* [Slice Parameters] */
// Number of intervals for XSlice / YSlice / AllXSlices / AllYSlices modes
num_slices = 8;
// Index (1-based) of the interval to render (XSlice / YSlice modes)
k = 4;
// Separate slices with a gap (for AllXSlices / AllYSlices modes)
separate_slices = false;
// Gap in mm between slices when separate_slices = true
slice_gap = 1.0;

/* [Holder Parameters] */
// Margin added around the surface footprint on each side (mm)
holder_margin = 3;
// Total height of the holder box (mm)
holder_height = 15;
// Depth of slots from the top of the holder (mm)
holder_slot_depth = 10;
// Extra clearance added to slot width for fit (mm) — increase if too tight
slot_tolerance = 0.3;

include <MathSurface3d.scad>;
