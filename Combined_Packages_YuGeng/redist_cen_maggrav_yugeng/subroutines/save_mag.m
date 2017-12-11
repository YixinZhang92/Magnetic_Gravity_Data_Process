function save_mag(gif_path, phi, u_max, glon, glat, d_phi)
%PLOT_MAG  Plot the maximum magnitudes of directional derivatives as a
% function of azimuths.

% examine output directory
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

end