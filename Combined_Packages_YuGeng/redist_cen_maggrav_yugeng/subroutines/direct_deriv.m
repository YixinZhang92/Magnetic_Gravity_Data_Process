function u_max = direct_deriv(clim, fig, dl, Cg, glon, glat, az, subfdr)
%DIRECT_DERIV    Directional derivative.
% Compute first derivative along arbitrary azimuth.
% clim - a specified fixed value range for the colorbar
% fig - the figure handle, used for saving plot
%     - you could have trouble with aspect ratio if you do not pass it
% dl - spacing along both x and y
% Cg - 2-D gridded data, could be gravity or anything
% glon, glat - gridded horizontal and vertical axes
% az - azimuth provided in [deg], clockwise from north
% subfdr - subfolder for saving figure
%        - specify 'none' to turn the saving off
% GENG, Yu
% 2017-12-08
% 
% Coordinate System in a Matrix
% Note that we did not flip lon and lat here. It is just a convention that
% X corresponds to the first index and Y corresponds to the second index.
% O --------------------> Y (lat)
% |
% |
% |
% |
% |
% |
% |
% |
% \/
% X (lon)

%% Compute gradients.
Gx = diff(Cg, 1, 1) ./ dl;  % 1 means along lon
Gy = diff(Cg, 1, 2) ./ dl;  % 2 means along lat

% create duplicate values at matrix borders (remain original size)
Gx_last_row = Gx(end,:);
Gx = [Gx; Gx_last_row];

Gy_last_column = Gy(:,end);
Gy = [Gy, Gy_last_column];

%% Create a unit vector representing the AZ angle.
rad = 90 - az;  % convert to math radian
unit_x = cosd(rad);  % scalar
unit_y = sind(rad);  % scalar
% unit = [unit_x, unit_y];

% perform inner product (Gx, Gy) : (unit_x, unit_y)
Gd = Gx .* unit_x + Gy .* unit_y;

%% Create a figure and save it.

% find the origin of the vector
loc = 0.67;  % location on plot, given as a ratio
org_x = min(glon) + loc * (max(glon) - min(glon));
org_y = min(glat) + loc * (max(glat) - min(glat));
% org = [org_x, org_y];

% start making the figure
clf;
savname = ['az_', num2str(az,'%03d'), '.png'];

hold on;
pcolor(glon, glat, Gd');
shading interp;
colormap jet;
% quiver(org_x, org_y, 0.1*unit_x, 0.1*unit_y, 'MaxHeadSize', 2.0);
hold off;

annotation('arrow', [loc, loc+0.1*loc*unit_x], [loc, loc+0.1*loc*unit_y]);
title(['First Derivative towards ', num2str(az,'%3d'), '^\circ']);
xlabel('Lon [deg]');
ylabel('Lat [deg]');
cb = colorbar;
title(cb, '[mGal/deg]');

% enfore yellow to be at zero
% clim = min(abs_min, abs_max);  % the one that is closer to zero
caxis([-clim, clim]);  % use the stabilized clim given as the input
axis('equal', 'tight');

if ~strcmp(subfdr, 'none')
    outdir = ['./output/', subfdr, '/'];
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end  % examine directory
    fullpath = [outdir, savname];
    saveas(fig, fullpath);  % save the plot
end

% compute maximum magnitude
abs_min = abs(min(min(Gd)));
abs_max = abs(max(max(Gd)));
u_max = max(abs_min, abs_max);  % the one that is further from zero

shg;

end