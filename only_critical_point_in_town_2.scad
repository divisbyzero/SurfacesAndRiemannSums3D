//===================================================
// Only critical point in town: a 3D plot of a function with a single critical point that is a local maximum but not a global maximum.
// This shows that the "only critical point in town" is not necessarily the highest point on the surface (unlike in single-variable calculus).
// Main entry file with all user-editable parameters.
//===================================================

/* [Function Parameters] */
function f(x, y) = min(x^2*(1+y)^3 + y^2, 6);
truncate_at_xy_plane = true; // Truncate the final surface at the xy-plane

/* [Output type] */
// 1 = Surface, 2 = Riemann sum, 3 = x slice, 4 = y slice, 5 = All x slices, 6 = All y slices, 7 = Holder (x), 8 = Holder (y)
output_mode = 1; // [1:Surface, 2:Riemann sum, 3:x slice, 4:y slice, 5:All x slices, 6:All y slices, 7:Holder (x), 8:Holder (y)]

/* [Scaling] */
targetxwidth = 80;
verticalscalefactor = .5;
verticaltranslation = 10;

/* [Domain] */
xmin = -2;
xmax = 2;
ymin = -3.25;
ymax = .75;

/* [Subdivisions] */
nx = 29;
ny = 29;
smooth_nx = 200;
smooth_ny = 200;

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
// Extra clearance added to slot width and ends for fit (mm) — increase if too tight
slot_tolerance = 0.4;

include <MathSurface3d.scad>;
