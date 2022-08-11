%% Ogive Nosecone Plotting
%  
%  Plots the cross section of a hollow nose cone with wall thickness.
%  
% *This file supersedes 'nosecone.m'*
% 
%  TODO: 
% * Write more comments and documentation for usage of this script.
%  
%  Created by Andrew Smelser
%  Created on 03-18-2022
%  Updated on 08-01-2022
clear,clc,close all
format compact

%% Define Parameters
i = 1;
dgamma = 0.001;  % Plot resolution, same units as gamma
ar = 4;  % Length to width aspect ratio, dimensionless
beta = 40;  % Aft nosecone diameter, mm
beta_s = 38;  % Shoulder outer diameter, mm
gamma = ar*beta;  % Nosecone length, mm
gamma_s = 38;  % Shoulder length, mm
alpha = 1;  % Nosecone shape parameter, dimensionless
tau = beta - beta_s;  % Shoulder offset distance, mm
k = 1.5;  % Wall thickness, mm

%% Outer curves
x = @(t) t;
y = @(x) beta*((-alpha*x.^2 / gamma^2) + (2*x/gamma))/(2*(2-alpha));

xt(1,:) = x(0:dgamma:gamma);
yt(1,:) = y(xt);
yyyyy = yt';
xxxxx = xt';

%% Inner curves
x2 = @(x1) (-beta*k*((-2*alpha*x1/gamma^2)+(2/gamma))) / (2*(2-alpha)*sqrt(...
	       (beta^2 * ((-2*alpha*x1/gamma^2)+(2/gamma)).^2)/(4*(2-alpha)^2)+1))+x1;	
y2 = @(x2) ((beta*(-(alpha*x2.^2 /gamma^2) + (2*x2/gamma))) / (2*(2-alpha))) - ...
	       (k./sqrt(((beta^2 * (-(2*alpha*x2/gamma^2)+(2/gamma)).^2)/ ...
		   (4*(2-alpha)^2))+1));
x2t(1,:) = x2(xt);
y2t(1,:) = y2(x2t);

% Fix the shoulder offset thickness
mask = x2t >= xt(end)-k;
x2t(mask) = [];
y2t(mask) = [];
x2t(end) = xt(end)-k;
y2t(end) = y2(x2t(end));

mask = y2t < yt(1);
y2t(mask) = [];
x2t(mask) = [];
% x2t(1) = xt(1);
y2t(1) = yt(1);

%% Fix the inner shoulder
outer_shoulder_points = [xt(end), yt(end)-tau, xt(end)+gamma_s, yt(end)-tau];
inner_shoulder_points = [x2t(end), y2t(end)-tau, x2t(end)+gamma_s, y2t(end)-tau];

xx1 = outer_shoulder_points(3);
yy1 = outer_shoulder_points(4);
xx2 = inner_shoulder_points(3);
yy2 = inner_shoulder_points(4);
shoulder_end_diff = sqrt((xx2-xx1)^2 + (yy2-yy1)^2);  % hypotenuse
remainder_shoulder = sqrt(shoulder_end_diff^2 - k^2);

%% Plot the curves
% 
%  Set the plot axes limits
border_width = 2;  % Extra space around the plot
x0 = 0; x1 = xt(end) + gamma_s + border_width;
y0 = 0; y1 = xt(end)/4 + border_width;

% Plot the shapes
f = figure(1);
hold on;
grid on;

% Outer surface
outer_surface = plot(xt, yt, 'b');
offset_shoulder = line([xt(end), xt(end)], [yt(end), yt(end)-tau]);
outer_shoulder = line([xt(end), xt(end)+gamma_s], [yt(end)-tau, yt(end)-tau]);
offset_shoulder.Color = 'blue';
outer_shoulder.Color = 'blue';

% Inner surface
inner_surface = plot(x2t, y2t, 'g');
inner_offset_shoulder = line([x2t(end), x2t(end)], [y2t(end), y2t(end)-tau]);
inner_shoulder = line([x2t(end), x2t(end)+gamma_s+remainder_shoulder], ...
	                  [y2t(end)-tau, y2t(end)-tau]);
inner_offset_shoulder.Color = 'green';
inner_shoulder.Color = 'green';

% Close the shoulder gap
gap = line([xt(end)+gamma_s, xt(end)+gamma_s], [yt(end)-tau, y2t(end)-tau]);
gap.Color = 'green';

% Close the nose gap
nose_gap = line([xt(1), x2t(1)], [0, 0]);
nose_gap.Color = 'green';

xlabel('Nose Cone Length');
ylabel('Nose Cone Diameter');
axis equal;
axis([x0 x1 y0 y1]);
hold off;
