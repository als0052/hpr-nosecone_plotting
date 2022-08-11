// Parabolic Nose Cone 3D Model Generator

// Leave these alone
$fn = 0;
$fa = 0.01;

// User modifiable items below marked with * in comments

// Render quality setting
$fs = 0.3;	// * range: 2 (coarse) to 0.3 (fine)

// Parabolic Series type selection
// * for Conical set k = 0
// * for 1/2 Parabola set k = 1/2
// * for 3/4 Parabola set k = 3/4
// * for Parabola (tangent base) set k = 1
k = 1;	

// All dimensions should be in MILLIMETERS

// Set shoulder length and diameter
shl_len = 35;	// * shoulder length
shl_dia = 28.8;	// * shoulder diameter

// Set anchor hole diameter and depth 
anc_dep = 25; 	// * anchor hole depth
anc_dia = 12.5;	// * anchor hole diameter

// Set nosecone body base diameter and aspect ratio (fineness)
bdy_dia = 30.8;	// * body base diameter
asp_rat = 5;	// * body aspect ratio (Length/Diameter)

// Build nosecone shoulder
translate ([0, 0, -shl_len])
difference(){
    cylinder (h=shl_len, r=shl_dia/2);    // create shoulder
    cylinder (h=anc_dep, r=anc_dia/2);    // create anchor hole
}

// Number of longitudinal faces to calculate
num_fcs = 400;  // * default = 400, finer resolution with increase

// Build nosecone body
bdy_len = bdy_dia*asp_rat;	// body length
bdy_rad = bdy_dia/2;		// body base radius
function y(x) = bdy_rad*(2*x/bdy_len-k*pow(x/bdy_len,2))/(2-k);
ply_pts = concat([[0, 0]],[for (i=[0:num_fcs]) let (x=(i*bdy_len/num_fcs))[y(bdy_len-x), x]]);
rotate_extrude() polygon(points = ply_pts);