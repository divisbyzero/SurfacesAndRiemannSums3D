//===================================================
// MathSurface3d — Versatile 3D Model Engine
// Author: https://github.com/divisbyzero
// Description:
//    This script generates 3D printable models of mathematical
//    surfaces and Riemann sum approximations for functions of
//    two variables over a rectangular domain.
//
//    Set output_mode in the including file to choose output type.
//===================================================

//----------------------------
// Shared Engine
//----------------------------
// This file expects these values to be defined by the including file:
// f(x, y), xmin, xmax, ymin, ymax, nx, ny, targetxwidth,
// verticalscalefactor, verticaltranslation, output_mode.
// Optional smooth-mode controls: smooth_nx, smooth_ny.
// Optional slice controls: num_slices, k, separate_slices, slice_gap.
// Optional holder controls: holder_margin, holder_height,
//   holder_slot_depth, slot_tolerance.
// Optional clipping control: truncate_at_xy_plane.

//----------------------------
// Derived Scaling Parameters (Do Not Edit Unless Needed)
//----------------------------

domain_width = xmax - xmin;
domain_depth = ymax - ymin;
aspect_ratio = domain_depth / domain_width;

targetywidth = targetxwidth * aspect_ratio;

xscale = targetxwidth / domain_width;
yscale = targetywidth / domain_depth;
zscale = xscale;  // Maintain proportional scaling in x, y, and z

dx_math = domain_width / nx;
dy_math = domain_depth / ny;

dx_phys = dx_math * xscale;
dy_phys = dy_math * yscale;

truncate_at_xy_plane_eff = !is_undef(truncate_at_xy_plane) && truncate_at_xy_plane;

// Scaled and translated function; optionally clamp below xy-plane.
function g_raw(x, y) = zscale * (verticalscalefactor * f(x, y)) + verticaltranslation;
function g(x, y) = truncate_at_xy_plane_eff ? max(0, g_raw(x, y)) : g_raw(x, y);

//----------------------------
// Riemann Prism Generator
//----------------------------
module riemann_prism(i, j) {
    x0 = xmin + i * dx_math;
    y0 = ymin + j * dy_math;
    z = g(x0 + dx_math/2, y0 + dy_math/2);

    translate([0, 0, 0.01])  // Slight lift to avoid base artifacts
        cube([dx_phys, dy_phys, z], center = false);
}

//----------------------------
// Riemann Surface Assembly
//----------------------------
module riemann_surface() {
    for (i = [0 : nx - 1])
        for (j = [0 : ny - 1]) {
            x_phys = (xmin + i * dx_math - xmin) * xscale;
            y_phys = (ymin + j * dy_math - ymin) * yscale;

            translate([x_phys, y_phys, 0])
                riemann_prism(i, j);
        }
}

//----------------------------
// Smooth Surface Assembly
//----------------------------
module smooth_cell(i, j) {
    smooth_nx_eff = is_undef(smooth_nx) ? max(2, nx * 4) : max(2, smooth_nx);
    smooth_ny_eff = is_undef(smooth_ny) ? max(2, ny * 4) : max(2, smooth_ny);
    dx_smooth_math = domain_width / smooth_nx_eff;
    dy_smooth_math = domain_depth / smooth_ny_eff;

    x0 = xmin + i * dx_smooth_math;
    x1 = x0 + dx_smooth_math;
    y0 = ymin + j * dy_smooth_math;
    y1 = y0 + dy_smooth_math;

    x0p = (x0 - xmin) * xscale;
    x1p = (x1 - xmin) * xscale;
    y0p = (y0 - ymin) * yscale;
    y1p = (y1 - ymin) * yscale;

    z00 = g(x0, y0);
    z10 = g(x1, y0);
    z11 = g(x1, y1);
    z01 = g(x0, y1);

    // Solid cell with bilinear-style top sampled at corners.
    polyhedron(
        points = [
            [x0p, y0p, z00],
            [x1p, y0p, z10],
            [x1p, y1p, z11],
            [x0p, y1p, z01],
            [x0p, y0p, 0],
            [x1p, y0p, 0],
            [x1p, y1p, 0],
            [x0p, y1p, 0]
        ],
        faces = [
            [0, 1, 2], [0, 2, 3],
            [4, 6, 5], [4, 7, 6],
            [0, 4, 5], [0, 5, 1],
            [1, 5, 6], [1, 6, 2],
            [2, 6, 7], [2, 7, 3],
            [3, 7, 4], [3, 4, 0]
        ]
    );
}

module smooth_surface() {
    smooth_nx_eff = is_undef(smooth_nx) ? max(2, nx * 4) : max(2, smooth_nx);
    smooth_ny_eff = is_undef(smooth_ny) ? max(2, ny * 4) : max(2, smooth_ny);

    for (i = [0 : smooth_nx_eff - 1])
        for (j = [0 : smooth_ny_eff - 1])
            smooth_cell(i, j);
}

//----------------------------
// X-Slice Assembly
// Divides the x-domain into num_slices equal intervals and renders
// the slab for interval k using x = midpoint of that interval.
//----------------------------
module x_slice() {
    smooth_ny_eff = is_undef(smooth_ny) ? max(2, ny * 4) : max(2, smooth_ny);
    n_slices      = is_undef(num_slices) ? 8 : num_slices;
    k_idx         = is_undef(k) ? 4 : k;

    x_iw_math = domain_width / n_slices;           // interval width in math units
    x_mid     = xmin + (k_idx - 0.5) * x_iw_math; // midpoint of interval k
    x0_phys   = (k_idx - 1) * x_iw_math * xscale; // physical left edge of slab
    x1_phys   = k_idx * x_iw_math * xscale;        // physical right edge of slab

    dy_smooth_math = domain_depth / smooth_ny_eff;

    for (j = [0 : smooth_ny_eff - 1]) {
        y0 = ymin + j * dy_smooth_math;
        y1 = y0 + dy_smooth_math;
        y0p = (y0 - ymin) * yscale;
        y1p = (y1 - ymin) * yscale;

        z0 = g(x_mid, y0);   // height at y0 using midpoint x
        z1 = g(x_mid, y1);   // height at y1 using midpoint x

        polyhedron(
            points = [
                [x0_phys, y0p, z0],
                [x1_phys, y0p, z0],
                [x1_phys, y1p, z1],
                [x0_phys, y1p, z1],
                [x0_phys, y0p, 0],
                [x1_phys, y0p, 0],
                [x1_phys, y1p, 0],
                [x0_phys, y1p, 0]
            ],
            faces = [
                [0, 1, 2], [0, 2, 3],
                [4, 6, 5], [4, 7, 6],
                [0, 4, 5], [0, 5, 1],
                [1, 5, 6], [1, 6, 2],
                [2, 6, 7], [2, 7, 3],
                [3, 7, 4], [3, 4, 0]
            ]
        );
    }
}

//----------------------------
// Y-Slice Assembly
// Divides the y-domain into num_slices equal intervals and renders
// the slab for interval k using y = midpoint of that interval.
//----------------------------
module y_slice() {
    smooth_nx_eff = is_undef(smooth_nx) ? max(2, nx * 4) : max(2, smooth_nx);
    n_slices      = is_undef(num_slices) ? 8 : num_slices;
    k_idx         = is_undef(k) ? 4 : k;

    y_iw_math = domain_depth / n_slices;           // interval width in math units
    y_mid     = ymin + (k_idx - 0.5) * y_iw_math; // midpoint of interval k
    y0_phys   = (k_idx - 1) * y_iw_math * yscale; // physical front edge of slab
    y1_phys   = k_idx * y_iw_math * yscale;        // physical back edge of slab

    dx_smooth_math = domain_width / smooth_nx_eff;

    for (i = [0 : smooth_nx_eff - 1]) {
        x0 = xmin + i * dx_smooth_math;
        x1 = x0 + dx_smooth_math;
        x0p = (x0 - xmin) * xscale;
        x1p = (x1 - xmin) * xscale;

        z0 = g(x0, y_mid);   // height at x0 using midpoint y
        z1 = g(x1, y_mid);   // height at x1 using midpoint y

        polyhedron(
            points = [
                [x0p, y0_phys, z0],
                [x1p, y0_phys, z1],
                [x1p, y1_phys, z1],
                [x0p, y1_phys, z0],
                [x0p, y0_phys, 0],
                [x1p, y0_phys, 0],
                [x1p, y1_phys, 0],
                [x0p, y1_phys, 0]
            ],
            faces = [
                [0, 1, 2], [0, 2, 3],
                [4, 6, 5], [4, 7, 6],
                [0, 4, 5], [0, 5, 1],
                [1, 5, 6], [1, 6, 2],
                [2, 6, 7], [2, 7, 3],
                [3, 7, 4], [3, 4, 0]
            ]
        );
    }
}

//----------------------------
// All X-Slices Assembly
// Renders all num_slices slabs across the full x-domain.
// When separate_slices = true, each slab is inset by slice_gap/2 on
// each side so adjacent slabs are disjoint.
//----------------------------
module all_x_slices() {
    smooth_ny_eff = is_undef(smooth_ny) ? max(2, ny * 4) : max(2, smooth_ny);
    n_slices      = is_undef(num_slices) ? 8 : num_slices;
    gap           = (!is_undef(separate_slices) && separate_slices &&
                     !is_undef(slice_gap)) ? slice_gap : 0;

    x_iw_math = domain_width / n_slices;
    x_iw_phys = x_iw_math * xscale;

    dy_smooth_math = domain_depth / smooth_ny_eff;

    for (ki = [1 : n_slices]) {
        x_mid   = xmin + (ki - 0.5) * x_iw_math;
        x0_phys = (ki - 1) * x_iw_phys + gap / 2;
        x1_phys = ki       * x_iw_phys - gap / 2;

        for (j = [0 : smooth_ny_eff - 1]) {
            y0 = ymin + j * dy_smooth_math;
            y1 = y0 + dy_smooth_math;
            y0p = (y0 - ymin) * yscale;
            y1p = (y1 - ymin) * yscale;

            z0 = g(x_mid, y0);
            z1 = g(x_mid, y1);

            polyhedron(
                points = [
                    [x0_phys, y0p, z0],
                    [x1_phys, y0p, z0],
                    [x1_phys, y1p, z1],
                    [x0_phys, y1p, z1],
                    [x0_phys, y0p, 0],
                    [x1_phys, y0p, 0],
                    [x1_phys, y1p, 0],
                    [x0_phys, y1p, 0]
                ],
                faces = [
                    [0, 1, 2], [0, 2, 3],
                    [4, 6, 5], [4, 7, 6],
                    [0, 4, 5], [0, 5, 1],
                    [1, 5, 6], [1, 6, 2],
                    [2, 6, 7], [2, 7, 3],
                    [3, 7, 4], [3, 4, 0]
                ]
            );
        }
    }
}

//----------------------------
// All Y-Slices Assembly
// Renders all num_slices slabs across the full y-domain.
// When separate_slices = true, each slab is inset by slice_gap/2 on
// each side so adjacent slabs are disjoint.
//----------------------------
module all_y_slices() {
    smooth_nx_eff = is_undef(smooth_nx) ? max(2, nx * 4) : max(2, smooth_nx);
    n_slices      = is_undef(num_slices) ? 8 : num_slices;
    gap           = (!is_undef(separate_slices) && separate_slices &&
                     !is_undef(slice_gap)) ? slice_gap : 0;

    y_iw_math = domain_depth / n_slices;
    y_iw_phys = y_iw_math * yscale;

    dx_smooth_math = domain_width / smooth_nx_eff;

    for (ki = [1 : n_slices]) {
        y_mid   = ymin + (ki - 0.5) * y_iw_math;
        y0_phys = (ki - 1) * y_iw_phys + gap / 2;
        y1_phys = ki       * y_iw_phys - gap / 2;

        for (i = [0 : smooth_nx_eff - 1]) {
            x0 = xmin + i * dx_smooth_math;
            x1 = x0 + dx_smooth_math;
            x0p = (x0 - xmin) * xscale;
            x1p = (x1 - xmin) * xscale;

            z0 = g(x0, y_mid);
            z1 = g(x1, y_mid);

            polyhedron(
                points = [
                    [x0p, y0_phys, z0],
                    [x1p, y0_phys, z1],
                    [x1p, y1_phys, z1],
                    [x0p, y1_phys, z0],
                    [x0p, y0_phys, 0],
                    [x1p, y0_phys, 0],
                    [x1p, y1_phys, 0],
                    [x0p, y1_phys, 0]
                ],
                faces = [
                    [0, 1, 2], [0, 2, 3],
                    [4, 6, 5], [4, 7, 6],
                    [0, 4, 5], [0, 5, 1],
                    [1, 5, 6], [1, 6, 2],
                    [2, 6, 7], [2, 7, 3],
                    [3, 7, 4], [3, 4, 0]
                ]
            );
        }
    }
}

//----------------------------
// X-Slice Holder
// A rectangular box with slots sized to receive each AllXSlices slab.
// Slots run the full inner y-depth; slabs drop straight in from the top.
//----------------------------
module x_slice_holder() {
    n_slices   = is_undef(num_slices)       ? 8   : num_slices;
    gap        = (!is_undef(separate_slices) && separate_slices &&
                  !is_undef(slice_gap))      ? slice_gap : 0;
    margin     = is_undef(holder_margin)     ? 3   : holder_margin;
    h          = is_undef(holder_height)     ? 15  : holder_height;
    slot_depth = is_undef(holder_slot_depth) ? 10  : holder_slot_depth;
    tol        = is_undef(slot_tolerance)    ? 0.3 : slot_tolerance;

    x_iw_phys = (domain_width / n_slices) * xscale;
    slab_w    = x_iw_phys - gap;     // actual slab x-width
    slot_w    = slab_w + tol;        // slot x-width with side clearance
    slot_d    = targetywidth + tol;  // slot y-depth with end clearance

    box_w = targetxwidth + 2 * margin;
    box_d = targetywidth + 2 * margin;

    difference() {
        cube([box_w, box_d, h]);
        for (ki = [1 : n_slices]) {
            slot_cx = margin + (ki - 0.5) * x_iw_phys;
            translate([slot_cx - slot_w / 2, margin - tol / 2, h - slot_depth])
                cube([slot_w, slot_d, slot_depth + 0.01]);
        }
    }
}

//----------------------------
// Y-Slice Holder
// A rectangular box with slots sized to receive each AllYSlices slab.
// Slots run the full inner x-width; slabs drop straight in from the top.
//----------------------------
module y_slice_holder() {
    n_slices   = is_undef(num_slices)        ? 8   : num_slices;
    gap        = (!is_undef(separate_slices) && separate_slices &&
                  !is_undef(slice_gap))      ? slice_gap : 0;
    margin     = is_undef(holder_margin)     ? 3   : holder_margin;
    h          = is_undef(holder_height)     ? 15  : holder_height;
    slot_depth = is_undef(holder_slot_depth) ? 10  : holder_slot_depth;
    tol        = is_undef(slot_tolerance)    ? 0.3 : slot_tolerance;

    y_iw_phys = (domain_depth / n_slices) * yscale;
    slab_w    = y_iw_phys - gap;     // actual slab y-width
    slot_w    = slab_w + tol;        // slot y-width with side clearance
    slot_d    = targetxwidth + tol;  // slot x-depth with end clearance

    box_w = targetxwidth + 2 * margin;
    box_d = targetywidth + 2 * margin;

    difference() {
        cube([box_w, box_d, h]);
        for (ki = [1 : n_slices]) {
            slot_cy = margin + (ki - 0.5) * y_iw_phys;
            translate([margin - tol / 2, slot_cy - slot_w / 2, h - slot_depth])
                cube([slot_d, slot_w, slot_depth + 0.01]);
        }
    }
}

//----------------------------
// Final Model Assembly
//----------------------------
module final_model() {
    if (output_mode == 2)
        union() {
            // Thin floor for printability and watertightness (1 mm thick)
            cube([targetxwidth, targetywidth, 1], center = false);
            riemann_surface();
        }
    else if (output_mode == 3)
        x_slice();
    else if (output_mode == 4)
        y_slice();
    else if (output_mode == 5)
        all_x_slices();
    else if (output_mode == 6)
        all_y_slices();
    else if (output_mode == 7)
        x_slice_holder();
    else if (output_mode == 8)
        y_slice_holder();
    else
        smooth_surface();
}

//----------------------------
// Build the Model
//----------------------------
final_model();
