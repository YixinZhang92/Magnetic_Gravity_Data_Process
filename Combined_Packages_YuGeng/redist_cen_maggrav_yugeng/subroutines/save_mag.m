function save_mag(gif_path, phi, u_max, glon, glat, d_phi)
%PLOT_MAG  Plot the maximum magnitudes of directional derivatives as a
% function of azimuths.
% 
% GENG, Yu
% 2017-12-11

% examine output directory
set(0, 'DefaultLineLineWidth', 1.5);
if ~exist(gif_path, 'dir')
    mkdir(gif_path);
end

% create the plot
fig_az = figure;
hold on;
plot(phi, u_max);
% do not plot scatter here, it really doesn't look good
hold off;

daspect([max(glon)-min(glon), max(glat)-min(glat), 1]);
title('Maximum Amplitude vs. Azimuth');
xlabel('Azimuth [deg]');
ylabel('Directional Derivative [mGal/deg]');
xlim([0, 360]);

% save the figure
fullpath = [gif_path, 'amp_', num2str(d_phi,'%02d'), '_deg.png'];
saveas(fig_az, fullpath);
disp(['Plot saved as: ', fullpath]);

% restore default
% this is important if you have more subroutines to call
% it maintains the 'undisturbed' environment in your main program
set(0, 'DefaultLineLineWidth', 0.5);

end