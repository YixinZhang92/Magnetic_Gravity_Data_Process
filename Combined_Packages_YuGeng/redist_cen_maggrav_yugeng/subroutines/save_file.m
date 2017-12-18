function save_file(fname, glon, glat, value)
% a function which takes care of repeated file saving operations during
% gravity data processing
% GENG, Yu
% 2017-09-13
% 
% How To Use
% glon and glat and new axes computed using the spacing specified in your
% main function. value is the data you want to plot.
% e.g. Cg: the interpolated gravity surface on the new meshgrid

fp = fopen(fname, 'w');

% Compute axis lengths.
nlon = numel(glon);
nlat = numel(glat);

for M = 1:nlon
    for N = 1:nlat
        fprintf(fp, '%10.4f%9.4f%12.4f\n', glon(M), glat(N), value(M, N));
        % When saving second derivatives with decimal digits specified, at
        % least 15 digits should be given for value(M, N). A much safer way
        % is to not specify decimal digits. This is also to satisfy the
        % floating point specification that larger numbers are distributed
        % less denser on the real axis.
    end
end

fclose(fp);
disp(['Saved file: ', fname]);

end
