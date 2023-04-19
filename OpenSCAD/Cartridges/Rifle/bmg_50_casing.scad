/* 12.7x99mm NATO Casing
 * Dimensions are approximate
 *
 * Call ``bmg50_NATO_3d()``
 *
 * See https://www.keywild.com/Six_Mountains/Images/Ammunition%2050BMG_12.7x99mm_Nato.png
 * for more details
 *
 * Created by Andrew Smelser
 * Created on 4/6/2020
 * Updated on 09-14-2021
 */
$fa = 1;	// min. angle of fragment, degrees
$fs = 0.5;	// min. size of fragment, mm

bmg50_NATO_3d(360);

/*================================*/
/*       Module Definitions       */
/*================================*/
module bmg50_NATO_3d(angle=360){
	/* bmg50_NATO_3d(angle)
	 * 
	 * 3D rotated extrusion of the 12.7x99mm NATO casing
	 * Filled interior; wall thicknesses not calculated or rendered.
	 * All dimensions/measurements in mm
	 *
	 * Inputs
	 * angle: The rotation angle for the 3D object. Default is 360degrees. 
	 */ 
	assert(angle <= 360, "Max angle is 360deg");
	assert(angle > 0, "Minimum angle must be greater than 0");
	rotate_extrude(angle=angle){
		bmg50_NATO_2d();
	};
};

module bmg50_NATO_2d(){
	/* bmg50_NATO_2d()
	 *
	 * Approximate case dimensions for 12.7x99mm NATO casing
	 * 2D polygon rendered in the +y and -x plane.
	 * All dimensions in mm unless otherwise stated
	 */
	y1 = 1.8022;	// mm, approx.; Derived geometrically
	y2 = 2.1678;	// mm, approx.; Derived geometrically

	thick_base = 0.84;
	r_base = 17.27/2;

	thick_rim = 1.42;
	r_rim = 20.42/2;

	thick_groove = y1;
	r_groove = 17.27/2;

	thick_chamfer = y2;
	r_chamfer_aft = 17.27/2;
	r_chamfer_fore = 20.42/2;

	len_case = 70.11;
	len_shoulder = 6.96;
	r_case_shoulder_aft = 18.14/2;
	r_case_shoulder_fore = 14.22/2;

	len_neck = 16.01;
	r_neck_aft = 14.22/2;
	r_neck_fore = 14.22/2;
	
	a = [-r_base, 0];
	b = [-r_rim, thick_base];
	c = [-r_rim, thick_base+thick_rim];
	d = [-r_groove, thick_base+thick_rim];
	e = [-r_chamfer_aft, thick_base+thick_rim+thick_groove];
	f = [-r_chamfer_fore, thick_base+thick_rim+thick_groove+thick_chamfer];
	g = [-r_case_shoulder_aft, thick_base+thick_rim+thick_groove+thick_chamfer+len_case];
	h = [-r_case_shoulder_fore, thick_base+thick_rim+thick_groove+thick_chamfer+len_case+len_shoulder];
	i = [-r_neck_aft, thick_base+thick_rim+thick_groove+thick_chamfer+len_case+len_shoulder+len_neck];
	polygon(points=[[0, 0], a, b, c, d, e, f, g, h, i, [0, i[1]]]);
};
