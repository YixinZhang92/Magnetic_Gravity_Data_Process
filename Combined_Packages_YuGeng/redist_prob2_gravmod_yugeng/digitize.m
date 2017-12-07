% digitized gravity profiles by sampling Elizabeth's snapshots
% created by: Yu Geng
% 2017-10-21

clc
clf
clear all
close all

%% Profile 1.

% sample the left half of the profile curve
% this has to be done manually
X_l1 = [-10, -8, -6, -4, -2, 0];
Y_l1 = [20, 25, 33, 42, 50, 53];

% create a smoothed full profile curve
% read documentation of make_profile() carefully
[X_new_1, Y_new_1] = make_profile(X_l1, Y_l1, 0.5);

%% Profile 2.

% sample the left half of the profile curve
% this has to be done manually
X_l2 = [-10, -8, -6, -4, -2, 0];
Y_l2 = [8, 10, 15, 30, 70, 140];

% create a smoothed full profile curve
% read documentation of make_profile() carefully
[X_new_2, Y_new_2] = make_profile(X_l2, Y_l2, 0.5);

%% Visualize them.
fig = figure
set(0, 'DefaultLineLineWidth', 2)

subplot(2,1,1)
plot(X_new_1, Y_new_1)
xlabel('[km]')
ylabel('[mGal]')
title('Profile One')

subplot(2,1,2)
plot(X_new_2, Y_new_2)
xlabel('[km]')
ylabel('[mGal]')
title('Profile Two')

saveas(fig, './plots/eliz_profiles_reprod.png');

%% Write the data into disk files.

% examine saving directory
if ~exist('./input/', 'dir')
    mkdir('./input/');
end

% concatenate and save profile 1
profile_1 = [X_new_1', Y_new_1'];
save ./input/eliz_p1.dat -ascii profile_1
disp('File saved as: ./input/eliz_p1.dat');

% concatenate and save profile 2
profile_2 = [X_new_2', Y_new_2'];
save ./input/eliz_p2.dat -ascii profile_2
disp('File saved as: ./input/eliz_p2.dat');
