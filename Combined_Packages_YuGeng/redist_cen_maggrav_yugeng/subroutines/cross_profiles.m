function cross_profiles(subdir, sup_title, unit, Cg, glon, glat, margin, tol)
%CROSS_PROFILES Calculate and show several gravity profiles along the
%   determined cross-section planes from the range of your data, used for
%   either raw data or first and second derivatives.
%   If multiple profiles exist within a projection plane (depends on your
%   choice of tol), mean values are computed.
% 
% subdir - output directory to save figures
%        - given as the subdirectory under ./output/
% sup_title - title shown on the X-Y plane data (the first figure)
% unit - modify it according to the data you are showing
% Cg - data to plot, given as a numel(glon) by numel(glat) matrix
% glon - gridded longitude axis
% glat - gridded latitute axis
% margin - distance between texts and the borders of the study region
% tol - tolerance of data truncation
% 
% Yu Geng
% 2017-11-13

%% Divide the study domain.
min_lon = min(glon);  % these will be repeatedly used
max_lon = max(glon);  % store them as variables to improve efficiency
min_lat = min(glat);
max_lat = max(glat);
div_lon = linspace(min_lon, max_lon, 5);
div_lat = linspace(min_lat, max_lat, 5);

%% Text locations (given in the format [x,y]).

% buffer string
space_buffer = repmat(' ', 1, 100);

% there are exactly one hundred spaces
% count if you do not believe it

% EW cross-sections
tex_A  = [min_lon+0.5*margin, div_lat(4)];
tex_AA = [max_lon-0.5*margin, div_lat(4)];
tex_B  = [min_lon+0.5*margin, div_lat(3)];
tex_BB = [max_lon-0.5*margin, div_lat(3)];
tex_C  = [min_lon+0.5*margin, div_lat(2)];
tex_CC = [max_lon-0.5*margin, div_lat(2)];

% NS cross-sections
tex_D  = [div_lon(2), min_lat+0.5*margin];
tex_DD = [div_lon(2), max_lat-0.5*margin];
tex_E  = [div_lon(3), min_lat+0.5*margin];
tex_EE = [div_lon(3), max_lat-0.5*margin];
tex_F  = [div_lon(4), min_lat+0.5*margin];
tex_FF = [div_lon(4), max_lat-0.5*margin];

%% Line sections.

% EW cross-sections
AA_lin_x = [min_lon+margin, max_lon-margin];
BB_lin_x = AA_lin_x;
CC_lin_x = AA_lin_x;
AA_lin_y = [div_lat(4), div_lat(4)];
BB_lin_y = [div_lat(3), div_lat(3)];
CC_lin_y = [div_lat(2), div_lat(2)];

% NS cross-sections
DD_lin_x = [div_lon(2), div_lon(2)];
EE_lin_x = [div_lon(3), div_lon(3)];
FF_lin_x = [div_lon(4), div_lon(4)];
DD_lin_y = [min_lat+margin, max_lat-margin];
EE_lin_y = DD_lin_y;
FF_lin_y = DD_lin_y;

%% Fetch data.

% examine working directory
outdir = ['./output/', subdir];
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

% clarification of mean() usage
% a = [1,2,3; 4,5,6];
% 
% mean(a, 1) => [2.5, 3.5, 4.5]
% compute average along the first index (vertically)
% keep the length along the second index
% 
% mean(a, 2) => [2.0, 5.0]
% compute average along the second index (horizontally)
% keep the length along the first index
% 
% adopt the convention that lon is the first index and lat is the second
% which must be consistent with the main program

% from EW cross-sections
sel_AA = (div_lat(4)-tol < glat) & (glat < div_lat(4)+tol);
sel_BB = (div_lat(3)-tol < glat) & (glat < div_lat(3)+tol);
sel_CC = (div_lat(2)-tol < glat) & (glat < div_lat(2)+tol);

if sum(sel_AA) == 0 || sum(sel_BB) == 0 || sum(sel_CC) == 0
    disp('No data obtained for projection!');
    disp('Increase truncation tolerance and try again.');
    delete([outdir, '/*']);
    error('Removing previous output...');
end

AA_pro_x = glon; BB_pro_x = glon; CC_pro_x = glon;
AA_pro_y = mean(Cg(:,sel_AA), 2);  % if multiple profiles are obtained
BB_pro_y = mean(Cg(:,sel_BB), 2);  % compute average along latitude
CC_pro_y = mean(Cg(:,sel_CC), 2);  % keep the size along longitude

% create a unified axis for EW
all_ew = [AA_pro_y; BB_pro_y; CC_pro_y];  % combine dataset
abs_max_ew = abs(max(all_ew));
abs_min_ew = abs(min(all_ew));
ewlim = max(abs_max_ew, abs_min_ew);

% from NS cross-sections
sel_DD = (div_lon(2)-tol < glon) & (glon < div_lon(2)+tol);
sel_EE = (div_lon(3)-tol < glon) & (glon < div_lon(3)+tol);
sel_FF = (div_lon(4)-tol < glon) & (glon < div_lon(4)+tol);

if sum(sel_DD) == 0 || sum(sel_EE) == 0 || sum(sel_FF) == 0
    disp('No data obtained for projection!');
    disp('Increase truncation tolerance and try again.');
    delete([outdir, '/*']);
    error('Removing previous output...');
end

DD_pro_x = glat; EE_pro_x = glat; FF_pro_x = glat;
DD_pro_y = mean(Cg(sel_DD,:), 1);  % if multiple profiles are obtained
EE_pro_y = mean(Cg(sel_EE,:), 1);  % compute average along longitude
FF_pro_y = mean(Cg(sel_FF,:), 1);  % keep the size along latitude

% create a unified axis for NS
all_ns = [DD_pro_y, EE_pro_y, FF_pro_y];  % combine dataset
abs_max_ns = abs(max(all_ns));
abs_min_ns = abs(min(all_ns));
nslim = max(abs_max_ns, abs_min_ns);

%% Create plots.

% original data (shown on an X-Y plane)
fig_xy = figure;
pcolor(glon, glat, Cg.');
shading interp;
colormap jet;  % 2015 default: parula

abs_min = abs(min(min(Cg)));
abs_max = abs(max(max(Cg)));
clim = min(abs_min, abs_max);
caxis([-clim, clim]);  % adjust colorscale

title(sup_title);
xlabel('Lon [deg]');
ylabel('Lat [deg]');
cb = colorbar;
title(cb, unit);

hold on;
line_style = 'k:';
set(0, 'DefaultLineLineWidth', 0.5);  % 0.5 by default
plot(AA_lin_x, AA_lin_y, line_style, BB_lin_x, BB_lin_y, line_style, ...
    CC_lin_x, CC_lin_y, line_style);
plot(DD_lin_x, DD_lin_y, line_style, EE_lin_x, EE_lin_y, line_style, ...
    FF_lin_x, FF_lin_y, line_style);

text(tex_A(1),  tex_A(2),  'A');
text(tex_AA(1), tex_AA(2), 'A''');
text(tex_B(1),  tex_B(2),  'B');
text(tex_BB(1), tex_BB(2), 'B''');
text(tex_C(1),  tex_C(2),  'C');
text(tex_CC(1), tex_CC(2), 'C''');
text(tex_D(1),  tex_D(2),  'D');
text(tex_DD(1), tex_DD(2), 'D''');
text(tex_E(1),  tex_E(2),  'E');
text(tex_EE(1), tex_EE(2), 'E''');
text(tex_F(1),  tex_F(2),  'F');
text(tex_FF(1), tex_FF(2), 'F''');
hold off;

saveas(fig_xy, [outdir, '/xy_plane.png']);

% EW cross sections
fig_ew = figure;
suptitle('EW Cross-Sections')
set(0, 'DefaultLineLineWidth', 1.5)

subplot(3,1,1);
plot(AA_pro_x, AA_pro_y);
xlim([min_lon, max_lon]);
ylim([-ewlim, ewlim]);  % unified window scale
xlabel('Lon [deg]');
ylabel(unit);
title(['A', space_buffer, 'A''']);

subplot(3,1,2);
plot(BB_pro_x, BB_pro_y);
xlim([min_lon, max_lon]);
ylim([-ewlim, ewlim]);  % unified window scale
xlabel('Lon [deg]');
ylabel(unit);
title(['B', space_buffer, 'B''']);

subplot(3,1,3);
plot(CC_pro_x, CC_pro_y);
xlim([min_lon, max_lon]);
ylim([-ewlim, ewlim]);  % unified window scale
xlabel('Lon [deg]');
ylabel(unit);
title(['C', space_buffer, 'C''']);

saveas(fig_ew, [outdir, '/profiles_ew.png']);

% NS cross sections
fig_ns = figure;
suptitle('NS Cross-Sections')
set(0, 'DefaultLineLineWidth', 1.5)

subplot(3,1,1);
plot(DD_pro_x, DD_pro_y);
xlim([min_lat, max_lat]);
ylim([-nslim, nslim]);  % unified window scale
xlabel('Lat [deg]');
ylabel(unit);
title(['D', space_buffer, 'D''']);

subplot(3,1,2);
plot(EE_pro_x, EE_pro_y);
xlim([min_lat, max_lat]);
ylim([-nslim, nslim]);  % unified window scale
xlabel('Lat [deg]');
ylabel(unit);
title(['E', space_buffer, 'E''']);

subplot(3,1,3);
plot(FF_pro_x, FF_pro_y);
xlim([min_lat, max_lat]);
ylim([-nslim, nslim]);  % unified window scale
xlabel('Lat [deg]');
ylabel(unit);
title(['F', space_buffer, 'F''']);

saveas(fig_ns, [outdir, '/profiles_ns.png']);

end
