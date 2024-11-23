#!/usr/bin/env python3

"""
NoseCone Maker


.. note:: This program is not yet working. 


A script written in Python 3.7 to create a nosecone with shoulder for a 
given airframe size. The nosecone will have a hollow interior with constant 
wall thickness of value ``k``. The coordinates of the nosecone will be 
produced as a 2D matrix and printed to a .csv file for use in OpenSCAD.


Requirements:
-------------
* Python 3.7.6+
* Shapely 1.6.4+
* Matplotlib 3.1.1+
* Numpy 1.17.3+


Instructions:
-------------
1. Define the parameters
2. Run the code
3. Open the file that was just created and copy its contents
4. Paste those contents into an OpenSCAD file (alternatively change the file 
   extension from *.csv* to *.scad*)
5. Run the OpenSCAD file
6. It should produce a nosecone with the parameters you have defined


User Parameters:
----------------
d<sub>&gamma;</sub>		Plot resolution, same units as gamma
ar						Length to width ratio, dimensionless
&alpha;					Nosecone shape parameter, dimensionless
&beta;					Aft nosecone diameter, mm. This is the same as the 
						outer airframe diameter.
&gamma;					Nosecone length (excluding shoulder length), mm
k						Wall thickness, mm
&beta;<sub>s</sub>		Shoulder outer diameter, mm. This is the same as the 
						inner airframe diameter.
&gamma;<sub>s</sub>		Shoulder length, mm


Default Test Values:
--------------------
dgamma = 0.1	# plot resolution, same units as gamma
ar = 4			# length to width ratio, dimensionless
alpha = 1		# nosecone shape parameter, dimensionless
beta = 40		# aft nosecone diameter, mm
gamma = ar * beta	# nosecone length, mm
k = 1.5			# wall thickness, mm
beta_s = 36		# shoulder outer diameter, mm
gamma_s = 38	# shoulder length, mm

See the ``tests/NoseConeMaker`` folder for the outputs of the test.


Notes:
------
* The nosecone coordinate axes are defined as such:
  * X-axis: The longitudinal axis extending down the center of the nosecone
            in the direction of maximum length; that is to say, from tip of 
			the nosecone (where X = 0) to the base of the shoulder.

  * Y-axis: The axis extending perpendicular to the X-axis and parallel 
            with the plane of the bottom of the shoulder. 

  * Z-axis: Z-axis and Y-axis are effectively the same.

* Currently only ``alpha = 1`` is supported. This should produce an ogive 
  nosecone.

* Change the value of ``ar`` to achieve different types of ogive. For example 
  ``ar = 4`` is a 4:1 ogive.

* The output file will contain several hundred lines of coordinate points, 
  depending on the overall length of the nosecone and the value of 
  ``dgamma``. 
    * A value of ``dgamma = 0.1`` should be sufficient for a nosecone of 40mm 
	  long (excluding shoulder). 

* The coordinates produced can be used in other CAD programs. 
    * The nosecone profile is designed to be created by a revolve-extrude 
	  operation around the central axis. 

    * Attempts to test a similar program as this one (transition_maker, which 
	  makes hollow transition sections) were not successful in Solid Edge, 
	  but it is likely that it could be made to work. 

* This code was developed and tested only in Jupyter NoteBook. Attempts might 
  be made later to transition all the code and related codes to a PyCharm 
  project. If you attempt this and run into issues please let the developer know!
    * NOTE: If you are reading this sentance then this code has been 
	        converted to a normal python module (.py file). 

* Attempting to export the generated nosecone from OpenSCAD 2019.05 has 
  caused the program to lock-up for me. You might run into similar issues. 
  I was using OpenSCAD 2019.05. Try reducing the ``dgamma`` value or 
  vodka-cooling your PC.

* This file supersedes nosecone_maker.ipynb


TODO:
-----
.. todo:: Add functionality to plot a nosecone that will include a metal tip. 
          Just supply the length of the metal tip and mask the plot data?

.. todo:: Need to add functionality to make the nose blunted (see bullet plotter 
          I think?)

.. todo:: Add plotting functionality with Matplotlib to view the nosecone 
          before exporting to openSCAD.

Created by: Andrew Smelser
Created on: 02-14-2020
Updated on: 11-22-2024
"""

from shapely.geometry import Point, LineString, LinearRing
from shapely.ops import polygonize
import matplotlib.pyplot as plt
from pathlib import Path
from shapely import *
import numpy as np
import os


class Nosecone:
	def __init__(self, base_radius, tip_radius, k, shoulder_radius,
	             shoulder_length, ar, **kwargs):
		self.base_radius = base_radius
		self.tip_radius = tip_radius
		self.ar = ar  # Aspect Ratio
		self.shoulder_radius = shoulder_radius
		
		# FIXME: When either k or shoulder_length are 0 the _inner_surface 
		#        and _outer_surface attributes don't get populated later in 
		#        the program.
		self.k = k  # Wall thickness
		self.shoulder_length = shoulder_length
		
		# beta = self.base_radius
		# gamma = self.ogive_length
		self.ogive_length = self.base_radius * 2 * ar
		self.ogive_radius = ((self.base_radius**2 + self.ogive_length**2) / 
		                     (2*self.base_radius))

		self.xy = np.array([])
		self._xnose = np.array([])
		self._ynose = np.array([])
		self.coord_pairs = np.array([])
		
		self.res = kwargs.get('res', 1000)
		self.alpha = kwargs.get('alpha', 1)
		
		self._xa = 0  # apex point
		self._xt = 0  # x-coord of tangency
		self._yt = 0  # y-coord of tangency
		self._x0 = 0  # don't remember what this is
		
		self._outer_surface = LineString()
		self._inner_surface = LineString()
	
	def __repr__(self):
		r = (f"Nosecone(base_radius={self.base_radius}, tip_radius="
		     f"{self.tip_radius}, k={self.k}, shoulder_radius="
			 f"{self.shoulder_radius}, shoulder_length="
			 "{self.shoulder_length}, ar={self.ar})")
		return r

	# @property
	# def line_coords(self):
	# 	r = []
	# 	if self._outer_surface.is_empty:
	# 		raise ValueError('No outer surface defined')
	# 	else:
	# 		r.append(self._outer_surface)
	# 	
	# 	if not self._inner_surface.is_empty:
	# 		r.append(self._inner_surface)
	# 	return r
	
	@property
	def has_inner_surface(self):
		return not self._inner_surface.is_empty

	@property
	def has_outer_surface(self):
		return not self._outer_surface.is_empty

	@property
	def ls_coords(self):
		"""Returns the pairs of X and Y coordinates for the LineStrings
			
			Not to be confused with self.coord_pairs.
			
			If the outer surface exists its X coords and Y coords are 
			elements 0 and 1 in the returned list. 
			If the inner surface exists its X coords and Y coords are 
			elements 2 and 3 in the returned list.
		"""
		if self.has_outer_surface:
			out_xx = [xy[0] for xy in self._outer_surface.coords]
			out_yy = [xy[1] for xy in self._outer_surface.coords]
		else:
			out_xx = None
			out_yy = None
		
		if self.has_inner_surface:
			in_xx = [xy[0] for xy in self._inner_surface.coords]
			in_yy = [xy[1] for xy in self._inner_surface.coords]
		else:
			in_xx = None
			in_yy = None
		pairs = [out_xx, out_yy, in_xx, in_yy]
		return pairs

	def _blunt_tangent_ogive(self):
		"""Calculate the values of x0, xt, yt, and xa"""
		gamma_s = self.shoulder_length
		gamma = self.ogive_length
		beta_s = self.shoulder_radius
		beta = self.base_radius
		rn = self.tip_radius
		rho = self.ogive_radius
		
		self._x0 = gamma - np.sqrt((rho - rn)**2 - (rho - beta)**2)
		self._yt = rn*(rho - beta)/(rho - rn)
		self._xt = self._x0 - np.sqrt(rn**2 - self._yt**2)
		self._xa = self._x0 - rn
		return None
	
	def _nose_arc(self):
		theta0 = 0  # radians
		theta_t = (np.arctan(self._yt / (self._x0 - self._xt)))  # radians
		theta = np.linspace(theta0, theta_t, self.res)  # radians
		
		# rn = self.tip_radius
		xnose = -self.tip_radius * np.cos(theta) + self._x0
		ynose = self.tip_radius * np.sin(theta)

		xnose = xnose[xnose<=self._xt]
		ynose = ynose[ynose<=self._yt]
		self._xnose = np.append(xnose, self._xt)
		self._ynose = np.append(ynose, self._yt)
		return None
	
	def _straight_points(self):
		gamma = self.ogive_length
		beta = self.base_radius
		
		if beta >= 0 and gamma >= 0:
			xy_out2 = np.vstack((self._xy[0][-1] + gamma, self._xy[1][-1]))
			xy = np.concatenate((self._xy, xy_out2), axis=1)
			_x = np.array([xy_out2[0][0], xy_out2[0][0]])
			_y = np.array([xy_out2[1][0], 0])
			self._xy = np.concatenate((xy, np.vstack((_x, _y))), axis=1)
		else:
			raise ValueError(f'Unexpected logic condition occurred: gamma='
			                 f'{gamma}, beta={beta}')
		return None

	def tangent_ogive(self):
		"""Create a tangent ogive nose cone"""
		gamma = self.ogive_length
		beta = self.base_radius
		rho = self.ogive_radius
		x_coord = np.array([])
		y_coord = np.array([])
		
		self._blunt_tangent_ogive()
		for i in np.arange(0, gamma, gamma/self.res):
			# x = i
			y = np.sqrt(rho**2 - (gamma-i)**2) + beta - rho
			x_coord = np.append(x_coord, i)
			y_coord = np.append(y_coord, y)

		self._nose_arc()
		x_coord = x_coord[x_coord>=self._xt]
		y_coord = y_coord[y_coord>=self._yt]

		x_coord = np.append(self._xnose, x_coord)
		y_coord = np.append(self._ynose, y_coord)
		self._xy = np.array([x_coord, y_coord]).T
		return None

	def add_shoulder(self):
		"""Add a shoulder to the nose cone"""
		gamma_s = self.shoulder_length
		beta_s = self.shoulder_radius
		
		sldr_stop_x0_y0 = np.array([[self._xy[-1, 0], self._xy[-1, 1]]])
		sldr_stop_x1_y1 = np.array([[self._xy[-1, 0], beta_s]])
		sldr_end_x2_y2 = np.array([[self._xy[-1, 0] + gamma_s, beta_s]])
		xy = np.concatenate((self._xy, sldr_stop_x0_y0, sldr_stop_x1_y1,
		                     sldr_end_x2_y2), axis=0)
		
		if self.k == 0:
			end_xy = np.array([[xy[-1,0], 0]])
		else:
			end_xy = np.array([[xy[-1,0], xy[-1,1]-self.k]])
		
		# This adds the vertical line to close off the bottom of the 
		# shoulder. Need to do it somewhere else because of the use of 
		# offset_curve for the inner surface.
		# xy = np.concatenate((xy, end_xy), axis=0)
		
		if self.k == 0:
			# No inner surface, we can go ahead and close the linestring
			self._outer_surface = LinearRing(xy)
		else:
			self._outer_surface = LineString(xy)
		
		self._xy = xy
		return None
		
	def inner_surface(self):
		"""Create the interior surface of the nose cone"""
		if self.k == 0:
			return None
		self._inner_surface = self._outer_surface.offset_curve(
			distance=self.k, quad_segs=16, join_style=2)
		return None
	
	def correct_ends(self):
		loc_coords_copy = []
		
		r = []
		if self.has_outer_surface:
			r.append(self._outer_surface)
		if self.has_inner_surface:
			r.append(self._inner_surface)
		
		for _coords in r:
			loc_coords = np.array([(x[0], x[1]) for x in _coords.coords])
			loc_coords_copy.append(loc_coords)

		upper_surface = loc_coords_copy[0].T
		if len(upper_surface) == 0:
			raise ValueError('Surface array is empty')
		
		us_x = upper_surface[0]
		us_y = upper_surface[1]
		
		if self.has_inner_surface:
			lower_surface = loc_coords_copy[1].T
			ls_x = lower_surface[0]
			ls_y = lower_surface[1]
			
			# Correct lower surface nosetip if it passes the X=0 axis
			msk = ls_y < 0
			ls_x = np.extract(~msk, ls_x)
			ls_y = np.extract(~msk, ls_y)
		
		# FIXME: There's nothing wrong with the values in the two line 
		#        strings. But, when plotted the upper surface finishes its 
		#        X-axis run and then immediately returns to near-zero for the 
		#        X-value when plotting the first pair of the inner surface. 
		#        To plot them we must append the reverse iteration of the 
		#        inner surface to the outer surface's coordinate pairs. See 
		#        current implementation of plot_linestrings() below.
		
		us_end = np.array(us_x[-1], us_y[-1])
		ls_end = np.array(ls_x[-1], ls_y[-1])
		
		xx = np.concatenate([us_x, ls_x])
		yy = np.concatenate([us_y, ls_y])
		
		self.coord_pairs = np.vstack((xx, yy)).T
		breakpoint()
		return None
	
	def plot_linestrings(self):
		ls_outer = self._outer_surface
		xx_outer = [xy[0] for xy in ls_outer.coords]
		yy_outer = [xy[1] for xy in ls_outer.coords]

		ls_inner = self._inner_surface
		xx_inner = [xy[0] for xy in ls_inner.coords]
		xx_inner.reverse()
		yy_inner = [xy[1] for xy in ls_inner.coords]
		yy_inner.reverse()
		
		first_pair = [xx_outer[0], yy_outer[0]]
		
		xx = xx_outer + xx_inner + [first_pair[0]]
		yy = yy_outer + yy_inner + [first_pair[1]]
		self.plot_coords(xx=xx, yy=yy)
		return None
	
	def plot_coords(self, xx=None, yy=None, fn=None):
		"""Plot the nosecone cross section
		
			:param xx: The x-coords to plot.
			:type xx: np.array, None
			:param yy: The y-coords to plot.
			:type yy: np.array, None
			:param fn: The filename to save the plot to.
			:type fn: None, Pathlike, str
		"""
		if xx is None:
			xx = self.coord_pairs[:, 0]
		if yy is None:
			yy = self.coord_pairs[:, 1]
		
		fig = plt.figure(figsize=(13,6), dpi=150)
		ax = fig.add_subplot(111)
		ax.grid()
		ax.plot(xx, yy, color='g')
		ax.set_aspect('equal')
		plt.show()
		
		if fn is not None:
			plt.savefig(fn)
		return fig

	def build_nosecone(self, write=False, fn='output_coordinates_file.txt'):
		"""Create the spherically blunted nosecone
		
			:param write: A flag to enable or disable writing the data to a 
				file. Default is False.
			:type write: bool
			:param fn: The file to write the data to.
			:type fn: Pathlike, str, None
		"""
		self.tangent_ogive()
		if self.shoulder_length > 0:
			self.add_shoulder()
		
		if self.k != 0:
			self.inner_surface()
		
		self.correct_ends()
		breakpoint()
		
		if write and fn is None:
			self.write_to_file(fn=fn)
		return None

	def write_to_file(self, fn):
		"""Write the nosecone data to a file
		
			:param fn: The file to write the data to.
			:type fn: Pathlike, str, None
		"""
		filename = os.path.join(os.getcwd(), fn)
		rows, _ = self.coord_pairs.shape
		i = 0
		max_length = max(self.coord_pairs.T[0])
		header = f"""rotate_extrude($fn=200)
		\trotate([0,0,-90])
		\t\ttranslate([-{max_length},0,0])
		\t\t\tpolygon(
		\t\t\t\tpoints=[
		"""
		with open(filename, mode='w', newline='') as fout:
			fout.write(header)
			for row in self.coord_pairs:
				i = i + 1
				if i == rows:
					write_str = f'\t\t\t\t\t[{row[0]},' \
					            f'{row[1]}]\n\t\t\t\t]\n\t\t\t);'
				else:
					write_str = f'\t\t\t\t\t[{row[0]},{row[1]}],\n'
				fout.write(write_str)
		print('File created: {}'.format(filename))
		return None
	
	def to_csv(self, fn=None, base_plane='xy'):
		"""Write the data to a .csv file
		
			:param fn: The name of the output file to write the data to.
			:type fn: None, Pathlike, str
			:param base_plane: The coordinate plane in which the base of the 
				nose cone is drawn. Default is 'xy' plane.
			:type base_plane: str
		"""
		if fn is None:
			fn = Path().cwd().joinpath('nosecone.txt')
		
		n_rows = self.coord_pairs.shape[0]
		z_col = np.zeros(self.coord_pairs.shape[0]).reshape(n_rows, 1)
		y_col = self.coord_pairs[:, 1].reshape(n_rows, 1)
		x_col = self.coord_pairs[:, 0].reshape(n_rows, 1)
		xyz = np.zeros(shape=[n_rows, 3])
		
		if base_plane.lower() in ['xy', 'yx']:
			# Output the base of the nosecone in the XY plane. Add all zeros 
			# for the Z axis.
			xyz = np.concatenate((x_col, y_col, z_col), axis=1)
		elif base_plane.lower() in ['xz', 'zx']:
			# The y-column is the zero column. Swap the Y and Z columns.
			xyz = np.concatenate((x_col, z_col, y_col), axis=1)
		elif base_plane.lower() in ['yz', 'zy']:
			# The x-column is the zero columns. Swap the X and Z columns.
			xyz = np.concatenate((z_col, y_col, x_col), axis=1)
		np.savetxt(str(fn), xyz, delimiter=",", fmt='%.4f')
		return None


if __name__ == "__main__":
	nc = Nosecone(base_radius=33, tip_radius=10, k=3, shoulder_radius=23,
	              shoulder_length=50, ar=4, **{'res': 50})
	nc.build_nosecone()
	nc.to_csv(fn=Path().home().joinpath("Downloads/nosecone.txt"))
	nc.plot_coords()
