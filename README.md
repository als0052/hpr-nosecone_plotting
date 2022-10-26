# High-Power Rocketry - Nose Cone Shape Graphers

* **Repository Name:** hpr-nosecone_plotting
* **Created by** als0052
* **Created on** 08-01-2022
* **Updated on** 10-26-2022


## MATLAB Version
Initially these programs were written in MATLAB when I was in college. Since I no longer have MATLAB at home I will (at some point) translate these programs into Python and utilize Matplotlib for the plotting.

### MATLAB Files
* **createfigure.m:** An auto-generated function created by MATLAB. Not sure what it was originally for...
* **nosecone.m:** Original code? Superseded by **nosecone2_boogaloo.m**.
* **nosecone2_boogaloo.m:** Newer code. Supersedes **nosecone.m**.
* **noseconeThing.m:** I think this does basic plotting of a nosecone? Made some edits on 08-01-2022.
* **ogive31.m:** This is the same code and functionality as **noseconeThing.m** so I'm not sure why it is here...
* **transition.m:** Plots the cross section of a body tube transition. 

I really don't remember which of the MATLAB files is the current version, or if any of them actually got to a finished state. At one point there was a "finished" version, but it only generated an outer surface curve and did not have the capability to plot the spherically blunted cap. Most of that will be corrected in the Python version(s).


## Python Version
* **JupyterLab_prototypes**: This directory contains the JupyterLab files used to develop prototype code. If there is a Python ``.py`` file of the same name as a JuptyerLab ``.ipynb`` file then the ``.py`` file is assumed to be the most recently updated version.

### Python Files
* **nosecone_maker2.py**: The Python translation of the ``nosecone2_boogaloo.m`` MATLAB file. 
  * **Warning** Currently very buggy.


## OpenSCAD
There are some OpenSCAD files for generating different things. I don't remember where I got them but I know I did not write the code. I probably got them off the high-powered rocketry forum. I've included them so I don't have to keep up with them elsewhere.


## TODO
* Rocket body tube transition code has not been started


## Changes 
* 10-26-2022: 
  * Consolidated the files from an older series of files that apparently did not get deleted when I made this repo. 
  * Added more CAD files. Made with SolidWorks 2020 and the equations do work for changing the size of the nosecone. Also added .STEP and .STL exports of these SolidWorks models. See ``hpr-nosecone_plotting\SolidWorks\Spherically Blunted Tangent Ogive\SolidWorks 2020\Simple\``

