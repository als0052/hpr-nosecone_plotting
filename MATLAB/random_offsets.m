%% 
clear,clc,close all
format compact

%%
number_trials = 5;	% Number of trials
sample_size = 5;	% Number shots/trial
total_shots = number_trials * sample_size;	% Total shots fired

grouping_size = randn(1);	% Inches, diameter
for t = 1:number_trials
	for s = 1:sample_size
		shot(t).x = rand(1);	% random x coord
		shot(t).y = rand(1);	% random y coord
	end
end
