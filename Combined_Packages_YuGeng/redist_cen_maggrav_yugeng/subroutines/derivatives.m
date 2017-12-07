function [Gx, Gy, Gxx, Gyy, Gxy] = derivatives(dl, Cg)
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
% Coordinate System in a Matrix
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

%% Compute first derivatives.
Gx = diff(Cg, 1, 1) ./ dl;  % 1 means along lon
Gy = diff(Cg, 1, 2) ./ dl;  % 2 means along lat

%% Compute second derivatives.
Gxx = diff(Cg, 2, 1) ./ dl ./ dl;
Gyy = diff(Cg, 2, 2) ./ dl ./ dl;
Gxy = diff(Gx, 1, 2) ./ dl;  % 1,2 mean perform one derivative on the y coordinate

% diff(a, 2, 1) is equivalent to diff(diff(a, 1, 1), 1, 1)
% You can verify this by creating a random matrix.

%% Create duplicate values at matrix borders (remain original size).
Gx_last_row = Gx(end,:);
Gx = [Gx; Gx_last_row];

Gy_last_column = Gy(:,end);
Gy = [Gy, Gy_last_column];

Gxx_first_row = Gxx(1,:);
Gxx_last_row = Gxx(end,:);
Gxx = [Gxx_first_row; Gxx; Gxx_last_row];

Gyy_first_column = Gxx(:,1);
Gyy_last_column = Gxx(:,end);
Gyy = [Gyy_first_column, Gyy, Gyy_last_column];

Gxy_last_column = Gxy(:,end);
Gxy = [Gxy, Gxy_last_column];
Gxy_last_row = Gxy(end,:);
Gxy = [Gxy; Gxy_last_row];

% dGxy was obtained by taking x derivative first and then take y
% derivative.
% Conversely, the missing column should be created firstly and the missing
% row shoule be created secondly.

end