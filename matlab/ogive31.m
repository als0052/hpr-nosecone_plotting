function ogive31(L,D,d_shoulder,L_shoulder,saveName,outType)
	% OGIVE31  Plot a 3:1 Ogive Nosecone
	%   ogive31(L, D, d_shoulder, L_shoulder, saveName, outType)
	% 
	%  Plots the shape of a 4:1 Ogive Nose Cone when given the necessary inputs
	%  and saves the results as a .csv or .xls file for importation into Solid Edge
	%
	%  Inputs:
	%    L = exposed nose cone length, inches
	%    D = base diameter, inches
	%    d_shoulder = shoulder diameter, inches
	%    L_shoulder = shoulder lenght, inches
	%    saveName = a string which will be used as the output save name. Must be
	%               enclosed in 'single quotes'
	%    outType = an option to select the output type. enter 'xls' for excel
	%              output or 'csv' for .csv output (faster) or 'non' to suppress file
	%              output.
	%
	%  Outputs:
	%    Plot of the shape
	%    A file of all geometric points (x,y,z)
	%
	%  Created by Andrew Smelser
	%  Created on 11-18-2018
	%  Updated on 08-11-2022
	% 
	%  TODO
	% * This file is the same as `noseconeThing.m`. Why?
	if nargin < 1 || isempty(L)
		error("L is a required input")
	end
	if nargin < 2 || isempty(D)
		error("D is a required input")
	end
	if nargin < 3 || isempty(d_shoulder)
		error("d_shoulder is a required input")
	end
	if nargin < 4 || isempty(L_shoulder)
		error("L_shoulder is a required input")
	end
	if nargin < 5 || isempty(saveName)
		% 	a = regexprep(datestr(now, 31), '..(..)-(..)-(..) (..):(..):(..)', '$1$2$3_$4$5$6');
		formatOut = 'ddmmyy_HHMMSS';
		saveName = datestr(now,formatOut);
	end
	if nargin < 6 || isempty(outType)
		outType = 'csv';
	end
	if L_shoulder < D
		warning("WARNING: Nose cone shoulder length is less than 1 caliber! Consider increasing shoulder length!")
	end
	if L_shoulder <= 0
		error("L_shoulder must be a positive non-zero number")
	end

	R = D/2;	% base radius, inches
	r_shoulder = d_shoulder/2;

	axisLimit = L+L_shoulder;	% set axis limits to total length of nose cone

	rho = (R^2 + L^2) / (2*R);						% Ogive radius
	y = @(x) sqrt(rho^2 - (L-x).^2)+R - rho;		% pos y at any location x
	y2 = @(x) -(sqrt(rho^2 - (L-x).^2)+R - rho);	% pos y at any location x

	%===== PLOTTING =====%
	figure()
	hold on
	grid minor
	fplot(y,[0 L],'b')
	fplot(y2,[0 L],'b')
	axis([0 axisLimit -axisLimit/2 axisLimit/2])
	title("4:1 Ogive Nosecone")

	%===== Plot the shoulder =====%
	yy = r_shoulder;
	p1 = line([L L+L_shoulder],[yy yy]);	% upper shouler line
	yy2 = -r_shoulder;
	p2 = line([L L+L_shoulder],[yy2 yy2]);	% lower shoulder line
	xx = (D/2)-(d_shoulder/2);	% dist. from outer edge to shoulder in y direction
	p3 = line([L L],[R R-xx]);	% upper shoulder distance
	p4 = line([L L],[-R -R+xx]);	% lower shoulder distance

	%===== GET THE SHOULDER COORDS =====%
	p1_xdata = get(p1,'Xdata');		% upper shoulder line
	p1_ydata = get(p1,'Ydata');		% upper shoulder line
	p2_xdata = get(p2,'Xdata');		% lower shoulder line
	p2_ydata = get(p2,'Ydata');		% lower shoulder line
	p3_xdata = get(p3,'Xdata');		% upper shoulder distance
	p3_ydata = get(p3,'Ydata');		% upper shoulder distance
	p4_xdata = get(p4,'Xdata');		% lower shoulder distance
	p4_ydata = get(p4,'Ydata');		% lower shoulder distance

	shoulder_xData_upper = [p1_xdata p2_xdata];
	shoulder_yData_upper = [p1_ydata p2_ydata];
	shoulder_xData_lower = [p3_xdata p4_xdata];
	shoulder_yData_lower = [p3_ydata p4_ydata];
	shoulder_zData = zeros([length(shoulder_xData_upper) 1]);
	shoulder_data_upper = [shoulder_xData_upper' shoulder_yData_upper' shoulder_zData];
	shoulder_data_lower = [shoulder_xData_lower' shoulder_yData_lower' shoulder_zData];

	%===== SAVE TO FILE =====%
	x = 0:0.1:L;
	upperPts = y(x);
	x2 = 0:0.1:L;
	lowerPts = y2(x2);
	points = [x' upperPts' zeros([length(x),1]) x2' lowerPts' zeros([length(x),1])];
	fid = string(saveName);
	appendRange = length(points(1));	% find the max column length in excel
	Range = strcat('A',string(appendRange),':','C',string(length(shoulder_zData)));
	Range = string(Range);

	if outType == 'xls'
		%===== XLS OUTPUT =====%
		fid = strcat(fid, '.xls');
		xlswrite(fid,points)
	% 	xlswrite(fid,shoulder_data_upper,Range)	
	elseif outType == 'csv'
		%===== CSV OUTPUT =====%
	% 	col = length(points(1));
	% 	row_upper = [1 2 3];	% for upper line
	% 	row_lower = [4 5 6];	% for lower line
		fid = strcat(fid,'.csv');
		csvwrite(fid,points) %,col,row_upper)	% only writes the upper line
	elseif outType == 'non'
		fprintf("No output file requested\n")
	end
	fprintf("done\n")
end
