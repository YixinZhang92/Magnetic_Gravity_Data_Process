% 
% Regional Geop. Synthesis Group Project
%     - a redistribution of plot_cen_maggrav and profile_cen_maggrav
% 
% Main features and capabilities
% 
% The package is capable of
% 1) plotting the gravity map and showing several EW and NS cross-section
%    profiles
% 2) detrending the gravity data before doing upward/downward
%    continuations
% 
% Additional features
% 3) compute directional derivative towards arbitrary azimuth and create a
%    0~359 deg animation
% 4) compute the maximum magnitude of derivative towards each direction
%    and plot it as a function of azimuth
% 5) all matlab plots are saved automatically in the subfolder you
%    specified
% 
% All tests passed on OS X 10.6.8 and 10.9.5 with GMT 4.
% 
% Created on: 2017-09-11
% Last update:
% * adjusted aspect ratio
%   - lon and lat should be in the same scale
% 

clc
clear all
close all

%% Preparations.

% set paths to dependencies
addpath(fullfile(pwd, 'movie2gif'));
addpath(fullfile(pwd, 'subroutines'));

% read in data
xyzgrd = load('./input/xyzgrd.asc');
lon  = xyzgrd(:,1);
lat  = xyzgrd(:,2);
grav = xyzgrd(:,3);

% calculate axes and prepare meshgrid
dl = 0.05;  % assume that spacings along lon and along lat are the same
glon = min(lon) : dl : max(lon);
glat = min(lat) : dl : max(lat);
[LON, LAT] = meshgrid(glon, glat);

% create interpolant
Fg = scatteredInterpolant(lon, lat, grav, 'natural', 'none');
Cg = Fg(LON(:,:,1), LAT(:,:,1));
Cg = Cg.';  % transpose into math convention

%% Screen output and figures.

% show study region
disp('Study region:');
disp([min(lon), max(lon), min(lat), max(lat)]);

% plot raw data with cross-section profiles
tol = 0.6 * dl;  % tolerance of data truncation
margin = 0.10;   % distance between texts and the borders of the figure
cross_profiles('raw_data', 'Raw Data', '[mGal]', Cg, glon, glat, margin, tol);

%% Compute first and second derivatives.

% start timer
tic();
disp('Computing derivatives...');
[Gx, Gy, Gxx, Gyy, Gxy, Gyx] = derivatives(dl, Cg);
toc();

% save data
delete('./input/*.xyv');  % clean-up previous output
save_file('./input/first_x.xyv', glon, glat, Gx);
save_file('./input/first_y.xyv', glon, glat, Gy);
save_file('./input/second_xx.xyv', glon, glat, Gxx);
save_file('./input/second_yy.xyv', glon, glat, Gyy);
save_file('./input/second_xy.xyv', glon, glat, Gxy);
disp('Done. Note that yellow is forcely centred at zero.');

% 
% You can also use the same subroutine to project derivatives.
% Read documentation of cross_profiles() carefully.
% 
% Examples:
% cross_profiles('first_x', '\partial{G}/\partial{x}', ...
%     '[mGal/deg]', Gx, glon, glat, margin, tol);
% cross_profiles('first_y', '\partial{G}/\partial{y}', ...
%     '[mGal/deg]', Gy, glon, glat, margin, tol);
% cross_profiles('second_xx', '\partial^2{G}/\partial{x}^2', ...
%     '[mGal/deg^2]', Gxx, glon, glat, margin, tol);
% cross_profiles('second_yy', '\partial^2{G}/\partial{y}^2', ...
%     '[mGal/deg^2]', Gyy, glon, glat, margin, tol);
% cross_profiles('second_xy', '\partial^2{G}/\partial{x}\partial{y}', ...
%     '[mGal/deg^2]', Gxy, glon, glat, margin, tol);
% 
% Everytime you call cross_profiles(), figures will be saved automatically in
% the subfolder you specified.
% 

%% Additional feature

% animation parameters
d_phi = 15;  % <= specify a stepsize, please use an integer divisor of 360
phi = 0 : d_phi : 359;
nof_frames = numel(phi);
F(nof_frames) = struct('cdata',[], 'colormap',[]);
u_max = zeros(1, nof_frames);

% obtain clim from x and y derivatives
GxGy = [Gx, Gy];  % merge dataset
min_GxGy = min(min(GxGy));
max_GxGy = max(max(GxGy));
abs_min = abs(min_GxGy);
abs_max = abs(max_GxGy);
clim = min(abs_min, abs_max);

% render the first time, obtain the value range
fig_mov = figure;
disp('Rendering animation...');
for i = 1 : nof_frames
    u_max(i) = direct_deriv(clim, fig_mov, dl, Cg, glon, glat, phi(i), 'none');
    drawnow;
    F(i) = getframe(gcf);
end
close(fig_mov);

% examine output directory
gif_path = './output/direct_deriv/';
if ~exist(gif_path, 'dir')
    mkdir(gif_path);
end

% plot maximum magnitude vs. azimuth
fig_az = figure;
% subplot(2,1,1);
hold on;
plot(phi, u_max);
% scatter(phi, u_max, '.');
hold off;
daspect([max(glon)-min(glon), max(glat)-min(glat), 1]);
title('Maximum Amplitude vs. Azimuth');
xlabel('Azimuth [deg]');
ylabel('Directional Derivative [mGal/deg]');
xlim([0, 360]);
saveas(fig_az, ['./output/direct_deriv/amp_', ...
    num2str(d_phi,'%02d'), '_deg.png']);

% play the movie
figure;  % show rendered movie in a separate window
disp('Playing the movie...');
movie(F, 3);  % play it for three times
% note that it doesn't increase the file size of the saved gif

% save the movie
fullpath = [gif_path, 'anime_', num2str(d_phi,'%02d'), '_deg.gif'];
movie2gif(F, fullpath, 'LoopCount', Inf, 'DelayTime', 0);
disp(['Movie saved as: ', fullpath]);
