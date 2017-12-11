% 
% /gaia/home/chi/oldclass/geop7112/problem2/prob2.m  
% Shu-Chioung Chiu
% September 19,2003
% modified by Yu Geng
% 
% new features added:
% 1) read Elizabeth's gravity profiles as the input data
% 2) regularized working directory
%    - intermediate results are written into subfolders
% 3) inverting two gravity profiles and plot them at once
% 4) study domain and # of measurements are automatically adjusted
%    according to your input data
% 5) several tiny changes made on prob2.m because of the input data change
% 6) figures are automatically saved into the ./plots/ folder
% 

clc
clf
clear all
close all

%% Set up dependencies.

% examine working directory
if ~exist('./output/', 'dir')
    mkdir('./output/');
end

% set paths to dependencies
p1_path = './input/eliz_p1.dat';
p2_path = './input/eliz_p2.dat';

%% Initial values of X0, R0 and Z0

% test I
X1 = 0.25;
R1 = 1.75;
Z1 = 8.00;

% test II
X2 = 0.25;
R2 = 1.50;
Z2 = 2.50;

%% Run inversion and plot them vertically.

% density contrast on
% Elizabeth's profiles
rho = 5.0;  % [gm/cc]

% run inversion
tic();
disp('--->  Results for Profile One');
[xx1,GG1,G1,x1,gg1] = prob2_sub(p1_path, rho, X1,R1,Z1);
disp('--->  Results for Profile Two');
[xx2,GG2,G2,x2,gg2] = prob2_sub(p2_path, rho, X2,R2,Z2);
toc();

% visualize the results
fig = figure;
set(0, 'DefaultLineLineWidth', 2)

subplot(2,1,1)
plot(xx1,GG1, xx1,G1, x1,gg1,'*');
title('Profile One')
ylabel('Gravity [mGal]')
xlabel('Distance [km]')
legend('True location', 'Inversion location', ...
    'Measurement data', 'Location', 'Best');

subplot(2,1,2)
plot(xx2,GG2, xx2,G2, x2,gg2,'*');
title('Profile Two')
ylabel('Gravity [mGal]')
xlabel('Distance [km]')
legend('True location', 'Inversion location', ...
    'Measurement data', 'Location', 'Best');

saveas(fig, './plots/inversion_results.png');
