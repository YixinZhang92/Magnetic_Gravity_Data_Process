% 
% Regional Geop. Synthesis Group Project
%     - a redistribution of plot_cen_maggrav and profile_cen_maggrav
% 
% Main features and capabilities
% 
% The package is capable of:
% 1) plotting the gravity map and showing several EW and NS cross-section
%    profiles
% 2) detrending the gravity data before doing upward/downward continuations
% 
% In addition,
% 3) by modifying main.m, you can also show the cross-section profiles of the
%    first and second derivatives, which is explained in the documentation in
%    details
% 4) matlab plots are saved automatically in the subfolder you specified
% 
% All tests passed on OS X 10.6.8 and 10.9.5 with GMT 4.
% 
% Created on: 2017-09-11
% Last modification:
%     - the colorscale of map view is forcely centred at zero
%     - vertical axes are unified for all the cross-section windows
% 

clc
clf
clear all
close all

%% Preparations.

% set paths to dependencies
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

% the idea matlab flips X and Y is to show the matrix with pcolor() with
% its original structure (first index as vertical and second index as
% horizontal)

%% Screen output and figures.

% show study region
disp('Study region:');
disp([min(lon), max(lon), min(lat), max(lat)]);

% plot raw data with cross-section profiles
tol = 0.6 * dl;  % tolerance of data truncation
margin = 0.10;  % distance between texts and the borders of the figure
cross_profiles('raw_data', 'Raw Data', '[mGal]', Cg, glon, glat, margin, tol);

%% Compute first and second derivatives.

% start timer
tic();
[Gx, Gy, Gxx, Gyy, Gxy] = derivatives(dl, Cg);
toc();

% save data
delete('./input/*.xyv');  % clean-up previous output
save_file('./input/first_x.xyv', glon, glat, Gx);
save_file('./input/first_y.xyv', glon, glat, Gy);
save_file('./input/second_xx.xyv', glon, glat, Gxx);
save_file('./input/second_yy.xyv', glon, glat, Gyy);
save_file('./input/second_xy.xyv', glon, glat, Gxy);
disp('Done. Go to the ./report/ folder to visualize them.');

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
