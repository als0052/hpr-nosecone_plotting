/* 9x19mm Casing
 *
 * Call externally using ``luger_9x19mm_3d(360);``
 *
 * Dimensions are approximate. 
 * All dimensions are given in inches and degrees unless otherwise 
 * stated and then CONVERTED to millimeters.
 *
 * Created by Andrew Smelser
 * Created on 09-14-2021
 * Updated on 09-14-2021
 */
$fa = 1;	// min. angle of fragment, degrees
$fs = 0.4;	// min. size of fragment, inch

luger_9x19mm_3d(360);

/*================================*/
/*       Module Definitions       */
/*================================*/
module luger_9x19mm_3d(angle=360) {
	/* luger_9x19mm_3d(angle)
	 *
	 * 3D rotated extrusion of the 9mm luger casing
	 * Filled interior; wall thicknesses not calculated or rendered.
	 * All dimensions/measurements in inches
	 *
	 * Inputs
	 * angle: the rotation angle for the 3D object. Default is 360 degrees.
	 */ 
	assert(angle <= 360, "Max angle is 360deg");
	assert(angle > 0, "Minimum angle must be greater than 0");
	rotate_extrude(angle=angle){
		luger_9x19mm_2d();
	};
};

module luger_9x19mm_2d(){
	/* luger_9x19mm_2d()
	 * 
	 * 2-Dimensional approximation of case dimensions for 9mm luger casing.
	 * All dimensions in inches and converted to mm unless otherwise specified.
	 * Dimensions obtained from SAAMI technical specification.
	 * 2D polygon rendered in the +x and +z plane.
	 * 2D Point coordinates obtained from 3D solid model made in SolidWorks. 
	 * 
	 * Coordinate pairs were transformed such that for each [a_i, b_i] the 
	 * coordinate pair was then 25.4*[[b_i, -1*a_i], ...]. This is to compensate 
	 * for how SolidWorks does it's reference planes all weird and to convert 
	 * to mm. 
	 * 
	 * Created by Andrew Smelser
	 * Created on 09-14-2021
	 * Updated on 09-14-2021
	 */
	polygon(points=25.4*[
		[0, 0],
		[0.18649689, 0],
		[0.197, -1*-0.015],
		[0.197, -1*-0.05],
		[0.1735, -1*-0.05],
		[0.1735, -1*-0.085],
		[0.19631591, -1*-0.1175845],
		[0.1955, -1*-0.20],
		[0.19055, -1*-0.70],
		[0.1900154, -1*-0.754],
		[0, -1*-0.754],
		[0, -1*-0.70],
		[0, -1*-0.20],
		[0, 0]]);	// convert to mm
};
