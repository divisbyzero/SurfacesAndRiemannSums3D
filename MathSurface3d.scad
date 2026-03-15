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

// Scaled and translated function
function g(x, y) = zscale * (verticalscalefactor * f(x, y)) + verticaltranslation;

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
// Final Model Assembly
//----------------------------
module final_model() {
    if (output_mode == 2)
        union() {
            // Thin floor for printability and watertightness (1 mm thick)
            cube([targetxwidth, targetywidth, 1], center = false);
            riemann_surface();
        }
    else
        smooth_surface();
}

//----------------------------
// Build the Model
//----------------------------
final_model();
