/* .22 LR Cartridge (Sporting)
 * Source: https://saami.org/wp-content/uploads/2019/06/ANSI-SAAMI-Z299.1-Rimfire-2015-R2018-Approved-2018-06-13.pdf
 * 
 * Units are INCHES unless otherwise stated
 *
 * This object not working. Probably did not actually ever finish it. 
 */
$fa = 1;	// min. angle of fragment, degrees
$fs = 1;	// min. size of fragment, inch

casing_22_LR();

/*================================*/
/*       Module Definitions       */
/*================================*/
module casing_22_LR(){
	/* Inches Units */
	t_rim = 0.043;
	r_rim = 0.278/2;
	r_casing = 0.226/2;
	r_bullet = 0.2255/2;
	length_casing = 0.613 - t_rim;
	length_max = 1.0; // maximum overall loaded length
	length_bullet = length_max - length_casing;

	// .22 LR Casing -- Exterior only
	cylinder(h=t_rim, r1=r_rim, r2=r_rim);
	translate([0,0,t_rim]){
		cylinder(h=length_casing, r1=r_casing, r2=r_casing);
	};

	// .22 LR Bullet -- Exterior only
	// TODO
};
