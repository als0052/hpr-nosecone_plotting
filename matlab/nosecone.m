%%
clear,clc,close all
format compact

%%
k = 1;
t_wall = 2;	% wall thickness, mm
num_fcs = 100;	% number of faces
bdy_len = 5*40;	% length of nosecone, mm
bdy_rad = 20;	% aft radius, mm
bdy_rad_inner = bdy_rad - t_wall; % aft inner radius, mm

for t = 1:num_fcs
	x(t) = (t * bdy_len / num_fcs);
	y_outer(t) = y(x(t), bdy_rad, bdy_len, k);
	points_outer(t, :) = [y_outer(t), x(t)];
	
	y_inner(t) = y2(x(t), bdy_rad_inner, bdy_len, k);
	points_inner(t, :) = [y_inner(t), x(t)];
end

figure()
hold on
grid on
x = [1:num_fcs];
p1 = plot(x, y_outer, 'b');
p2 = plot(x, y_inner, '--r');

%% Functions
function point = y(x, bdy_rad, bdy_len, k)
	point = bdy_rad * (2*x/bdy_len - k * (x/bdy_len)^2) / (2 - k);
end

function point2 = y2(x, bdy_rad_inner, bdy_len, k)
	point2 = bdy_rad_inner * (2*x/bdy_len - k * (x/bdy_len)^2) / (2 - k);
end


