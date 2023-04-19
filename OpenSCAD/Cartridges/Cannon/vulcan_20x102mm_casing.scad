/* 20x102mm Vulcan Casing
 * Dimensions are approximate. 
 *
 * Call externally using ``vulcan_20x102mm_3d(angle=360)``
 *
 * All dimensions are given in millimeters and degrees unless otherwise 
 * stated.
 *
 * See also for more details: 
 * http://www.keywild.com/Six_Mountains/Images/Ammunition%2020x102mm_Vulcan.png
 * 
 * As of 10-26-2020 a 3D print of this in PLA did not fit in the breech of an 
 * M61 rotary cannon off of an AC-130A. Might be due to printer calibration. 
 * But since dimensions are approximated, it is also likely due to poor 
 * dimensioning of the computer model.
 *
 * TODO: find a 20mm casing and cut it up in 5mm increments. Measure wall 
 *       thicknesses and create a model with hollow interior
 * TODO: find a way to model the projectile (TP "Ball" projectile)
 *
 * Created by Andrew Smelser
 * Created on 4/6/2020
 * Updated on 09-14-2021
 */
$fa = 1;	// min. angle of fragment, degrees
$fs = 1;	// min. size of fragment, mm

vulcan_20x102mm_3d(360);

/*================================*/
/*       Module Definitions       */
/*================================*/
module vulcan_20x102mm_3d(angle=360){
	/* vulcan_20x102mm_3d(angle)
	 *
	 * 3D rotated extrusion of the 20x102mm Vulcan casing
	 * Filled interior; wall thicknesses not calculated or rendered.
	 * All dimensions/measurements in mm
	 *
	 * Inputs
	 * angle: the rotation angle for the 3D object. Default is 360 degrees.
	 */ 
	assert(angle <= 360, "Max angle is 360deg");
	assert(angle > 0, "Minimum angle must be greater than 0");
	rotate_extrude(angle=angle){
		vulcan_20x102mm_2d();
	};
};

module vulcan_20x102mm_2d(){
	/* vulcan_20x102mm_2d()
	 * 
	 * 2-Dimensional approximation of case dimensions for 20x102mm 
	 * Vulcan casing.
	 * 
	 * See http://www.keywild.com/Six_Mountains/Images/Ammunition%2020x102mm_Vulcan.png
	 * for details
	 *
	 * All dimensions in mm unless otherwise specified. 
	 *
	 * 2D polygon rendered in the +y and -x plane.
	 * 
	 * Updated on 10-22-2020
	 *   - Removed comments specifying dimensions in mm and replaced with a 
	 *     comment in the docstring
	 *   - removed old/dead code that had been commented out. Hopefully it 
	 *     wasn't important
	 * 
	 * Created by Andrew Smelser
	 * Created on 4-6-2020
	 */
	y1 = 2.9678;	// mm, approx.; Derived geometrically
	y2 = 2.2822;	// mm, approx.; Derived geometrically

	thick_base = 1.19;
	r_base = 25.26/2;

	thick_rim = 1.61;
	r_rim = 28.14/2;

	thick_groove = y1;
	r_groove = 25.26/2;
	
	thick_chamfer = y2;
	r_chamfer_aft = 25.26/2;
	r_chamfer_fore = 29.09/2;

	len_case = 76.25;
	len_shoulder = 8.6;
	r_case_shoulder_aft = 29.09/2;
	r_case_shoulder_fore = 20.53/2;

	len_neck = 9.1;
	r_neck_aft = 20.53/2;
	r_neck_fore = 20.53/2;

	/* Numeric Dimensions
	 * a = [-12.63, 0];
	 * b = [-14.07, 1.19];
	 * c = [-14.07, 2.80];
	 * d = [-12.63, 2.80];
	 * e = [-12.63, 2.80+y1];
	 * f = [-14.545, 2.80+y1+y2];
	 * g = [-14.545, 84.30];
	 * h = [-10.265, 92.90];
	 * i = [-10.265, 102.00];
	 */
	
	a = [-r_base, 0];
	b = [-r_rim, thick_base];
	c = [-r_rim, thick_base+thick_rim];
	d = [-r_groove, thick_base + thick_rim];
	e = [-r_chamfer_aft, thick_base + thick_rim + thick_groove];
	f = [-r_chamfer_fore, thick_base + thick_rim + thick_groove + thick_chamfer];
	g = [-r_case_shoulder_aft, thick_base + thick_rim + thick_groove + thick_chamfer + len_case];
	h = [-r_case_shoulder_fore, thick_base + thick_rim + thick_groove + thick_chamfer + len_case + len_shoulder];
	i = [-r_neck_aft, thick_base + thick_rim + thick_groove + thick_chamfer + len_case + len_shoulder + len_neck];
	polygon(points=[[0, 0], a, b, c, d, e, f, g, h, i, [0, 102.00]]);
};
