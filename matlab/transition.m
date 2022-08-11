%% Bodytube Transitions
%  
%  TODO
% * Fix comments and documentation. 
% 
%  Created by Andrew Smelser
%  Created on 03-18-2022
%  Updated on 08-01-2022
clear,clc,close all
format compact

%{
alpha = Aft diameter, outside, mm
      = Equals inner diameter of aft airframe

beta = aft transition outer diameter, mm
     = equals outer diameter of aft airframe

gamma = fore transition outer diameter, mm
      = equals outer diameter of fore airframe

delta = fore diameter, outside, mm
      = equals inner diameter of fore airframe

epsilon_1 = aft shoulder length, mm
epsilon_2 = transition length, mm
epsilon_3 = fore shoulder length, mm
theta = transition angle, degrees
tau_1 = beta - alpha
tau_2 = gamma - delta
k = wall thickness, mm

A: (0, alpha)
B: (epsilon_1, alpha)
C: (epsilon_1, beta)
D: (epsilon_1 + epsilon_2, gamma)
E: (epsilon_1 + epsilon_2, delta)
F: (epsilon_1 + epsilon_2 + epsilon_3, delta)
G: (epsilon_1, alpha - gamma)
%}

%% Test Case 1
alpha = 38;  % mm
beta = 40;  % mm
gamma = 24;  % mm
delta = 22;  % mm
epsilon_1 = 40;  % mm
epsilon_3 = 24;  % mm
theta = 45;  % degrees
% epsilon_2 = [];  % mm

eps_2 = @(theta, beta, gamma) (beta - gamma)/tand(theta);  % calculate epsilon_2, mm
epsilon_2 = eps_2(theta, beta, gamma);

%% Convert diamters to radii
alpha = alpha / 2;
beta = beta / 2;
gamma = gamma / 2;
delta = delta / 2;

%% Plot the Test Case
A = [0, alpha];
B = [epsilon_1, alpha];
C = [epsilon_1, beta];
D = [epsilon_1 + epsilon_2, gamma];
E = [epsilon_1 + epsilon_2, delta];
F = [epsilon_1 + epsilon_2  + epsilon_3, delta];
G = [epsilon_1, alpha - gamma];

figure(1)
hold on
grid on

plot_A = scatter(0, alpha);
plot_B = scatter(epsilon_1, alpha);
plot_C = scatter(epsilon_1, beta);
plot_D = scatter(epsilon_1 + epsilon_2, gamma);
plot_E = scatter(epsilon_1 + epsilon_2, delta);
plot_F = scatter(epsilon_1 + epsilon_2  + epsilon_3, delta);
plot_G = scatter(epsilon_1, gamma);

xlabel('Length (mm)');
ylabel('Radius (mm)');

x0 = 0;
x1 = epsilon_1+epsilon_2+epsilon_3;
y0 = 0;
y1 = beta;
% axis('equal')
axis([x0, x1, y0, y1])
hold off

%% Plot the Test Case with Line Primitives

figure1 = figure;
axes1 = axes('Parent', figure1);
hold(axes1,'on');
grid(axes1,'on');

AB = line([0, epsilon_1], [alpha, alpha]);
BC = line([epsilon_1, epsilon_1], [alpha, beta]);
CD = line([epsilon_1, epsilon_1 + epsilon_2], [beta, gamma]);
DE = line([epsilon_1 + epsilon_2, epsilon_1 + epsilon_2], [gamma, delta]);
EF = line([epsilon_1 + epsilon_2, epsilon_1 + epsilon_2 + epsilon_3], [delta, delta]);

% Show point markers
A = plot(0, alpha, 'r*');
B = plot(epsilon_1, alpha, 'r*');
C = plot(epsilon_1, beta, 'r*');
D = plot(epsilon_1 + epsilon_2, gamma, 'r*');
E = plot(epsilon_1 + epsilon_2, delta, 'r*');
F = plot(epsilon_1 + epsilon_2  + epsilon_3, delta, 'r*');
G = plot(epsilon_1, gamma, 'b.');

% Show triangle CGD
CG = line([epsilon_1, epsilon_1], [beta, gamma]);
CG.Color = 'Blue';
CG.LineStyle = '--';
GD = line([epsilon_1, epsilon_1+epsilon_2], [gamma, gamma]);
GD.Color = 'Blue';
GD.LineStyle = '--';
CD.Color = 'Blue';

xlabel('Length (mm)')
ylabel('Radius (mm)')

% % Annotations
% x.A = [0.151190476190476, 0.131547619047619]; 
% y.A = [0.705075533661741, 0.752052545155993];
% x.B = [0.494642857142857, 0.514285714285715]; 
% y.B = [0.71264367816092, 0.749410509031198];
% x.D = [0.697619047619048, 0.674404761904764]; 
% y.D = [0.597701149425287, 0.57699671592775];
% x.C = [0.554761904761905, 0.520238095238096]; 
% y.C = [0.763546798029557, 0.784893267651888];
% x.E = [0.651785714285714, 0.668452380952381]; 
% y.E = [0.51788341543514, 0.540229885057471];
% x.F = [0.886904761904762, 0.901785714285715]; 
% y.F = [0.579638752052545, 0.548440065681445];
% set(axes1,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[40 10 1]);
% 
% annotation(figure1,'textarrow',x.A, y.A,'String',{'A'});
% annotation(figure1,'textarrow',x.B, y.B,'String',{'B'});
% annotation(figure1,'textarrow',x.C, y.C,'String',{'C'});
% annotation(figure1,'textarrow',x.D, y.D,'String',{'D'});
% annotation(figure1,'textarrow',x.E, y.E,'String',{'E'});
% annotation(figure1,'textarrow',x.F, y.F,'String',{'F'});

axis('equal')
axis([x0, x1, y0, y1])
hold off
