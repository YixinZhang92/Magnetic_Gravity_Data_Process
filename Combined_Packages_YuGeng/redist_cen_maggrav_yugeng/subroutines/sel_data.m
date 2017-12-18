function [dlon, dlat, sc, lgd] = ...
    sel_data(upplim, lowlim, mag_H, glon, glat, interv)
%SEL_DATA  Subroutine of dot_plot().
% Create two vectors containing the coordinates for the data within the
% range. The interval for fetching data is right-closed (largest value
% included while smallest not).
% 
% mag_H - computed magnitudes of horizontal gradients in dot_plot
%       - given in the matlab index convention
% glon, glat - axes matching the gravity data
% interv - interval used to section the data
%        - used for normalizing symbol size
% 
% GENG, Yu
% 2017-12-10

%% Pre-allocation.

% convert to math convention (consistent with the main function)
mag_H = mag_H.';

% this is purely temporary operation
% you do not need to flip it at the end of the function

% create boolean matrix
bool_M = ((lowlim < mag_H) & (mag_H <= upplim));  % right-closed interval
nof_ones = sum(bool_M(:) == 1);

% allocate structures
dlon = zeros(nof_ones, 1);
dlat = zeros(nof_ones, 1);

%% Fetch data.

% traverse through all the coordinates
counter = 0;
for j = 1:length(glat)
    for i = 1:length(glon)
        if bool_M(i, j)  % if it corresponds to one
            counter = counter + 1;
            dlon(counter) = glon(i);  % store the current
            dlat(counter) = glat(j);  % coordinate
        end
    end
end

% check validity
if counter ~= nof_ones
    error('Fetched inconsistent with pre-allocated!');
end

% create size and legend
sc = upplim / interv;
lgd = [num2str(lowlim), '~', num2str(upplim), ' mGal/deg'];

end