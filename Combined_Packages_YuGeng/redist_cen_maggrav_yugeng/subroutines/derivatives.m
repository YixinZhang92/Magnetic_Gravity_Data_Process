function [Gx, Gy, Gxx, Gyy, Gxy, Gyx] = derivatives(dl, Cg)
% first and second derivatives of Bouguer anomaly
% created by Yu Geng
% 2017-09-13
% 
% WARNING
% Only if the study region is small can you take derivatives with respect
% to lon and lat. Projection effects cannot be ignored if the study region
% is big. In that case, [deg] must be converted into [km] by doing an UTM
% conversion.
% 
% If the grid is not evenly spaced, dl must be a vector. For example,
% diff(lon) and diff(lat).
% Note that x corresponds to the row of a matrix and y corresponds to the
% column of a matrix.
% 
% Clarification about MATLAB convention
% * use the first index to move along +y axis (north)
% * use the second index to move along +x axis (east)
% - the convention about y axis is confusing, because when the index number
%   increases, you are actually moving downward
% - however, the data are stored in the matrix in a "downward increasing"
%   manner i.e. you do not have to flip anything
% 

%% Compute first derivatives.

% restore matlab convention
Cg = Cg';

% compute central difference
[Gx, Gy] = gradient(Cg);

% convert to derivatives
Gx = Gx ./ dl;
Gy = Gy ./ dl;

% Gx - gradient along longitude
% Gy - gradient along latitude

%% Compute second derivatives.

% compute central difference
[Gxx, Gxy] = gradient(Gx);
[Gyx, Gyy] = gradient(Gy);

% convert to derivatives
Gxx = Gxx ./ dl;
Gxy = Gxy ./ dl;
Gyx = Gyx ./ dl;
Gyy = Gyy ./ dl;

% Avoid using diff(), you will miss one row/column each time you take a
% derivative.
% Use gradient() instead of diff(), it adopts central difference which
% retains the size of the matrix.

% restore math convention (fetch data with M(i,j) instead of M(j,i))
Gx = Gx';
Gy = Gy';
Gxx = Gxx';
Gxy = Gxy';  % you can verify that
Gyx = Gyx';  % Gyx is very close to Gxy
Gyy = Gyy';

end