function dot_plot(subdir, Cg, glon, glat, interv)
%DOT_PLOT  Maxima of horizontal gradients.
% Show places where horizontal gradients of gravity data are locally high.
% 
% subdir - subdirectory to save figure, provide name only (no slash symbol)
% Cg - gridded 2-D gravity data
% glon, glat - gridded axes corresponding to Cg
% interv - interval size you want to level the data with
%        - for gravity gradient in unit [mGal/deg], use 100
%        - in [mGal/km], 1 is suggested
%        - it is also related to your spacing
% 
% GENG, Yu
% 2017-12-10

%% Computation.

% retain matlab convention (use the first index to move along latitude and
% use the second index to move along longitude)
Cg = Cg';

% compute maximum gradient
[Gx, Gy] = gradient(Cg);
mag_H = Gx .* Gx + Gy .* Gy;  % magnitude of horizontal gradient
max_mag = max(max(mag_H));

% divide them into levels
levels = 0 : interv : max_mag;
levels = [levels, max_mag];
nof_levels = idivide(int32(max_mag), int32(interv));
nof_levels = nof_levels + 1;

%% Plot.

% create figure
fig_dot = figure;
title('Maxima of Horizontal Gradients');
xlabel('Lon [deg]');
ylabel('Lat [deg]');

hold on;
for i = 2:nof_levels  % skip the smallest interval so that you get a white bg
    lowlim = levels(i);
    upplim = levels(i+1);
    [dlon, dlat, sc, lgd] = ...
        sel_data(upplim, lowlim, mag_H, glon, glat);  % sc is for size only
    scatter(dlon, dlat, sc, 'filled', ...
        'DisplayName', lgd);  % color is automatic
end
hold off;

axis('equal');  % do not set 'tight' here
xlim([min(glon), max(glon)]);
ylim([min(glat), max(glat)]);
leg = legend('show', 'Location', 'Best');  % cannot add title to legend
% title(leg, '\|\nabla{g}_z(x,y)\|_2 [mGal/deg]');

% examine working directory
outdir = ['./output/', subdir, '/'];
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

% save the figure
fullpath = [outdir, 'dot_plot.png'];
saveas(fig_dot, fullpath);
disp(['Plot saved as: ', fullpath]);

end