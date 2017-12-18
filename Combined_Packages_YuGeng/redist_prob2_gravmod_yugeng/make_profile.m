function [X_new, Y_new] = make_profile(X_l, Y_l, smoother)
% MAKE_PROFILE sample the left half of a gravity profile curve, the
% function gives a smoothed full profile curve
% X_l, Y_l - sampled left half of a profile curve
%          - given as row vectors with consistent lengths
% smoother - how much you want to smooth the profile curve
%          - given as the interpolation interval
%          - the smaller the interval is, the more smoothed curve you get

% flip the vectors to get the right half
X_r = - fliplr(X_l(1:end-1));
Y_r = fliplr(Y_l(1:end-1));

% concatenate them
X_f = [X_l, X_r];
Y_f = [Y_l, Y_r];

% smooth the curve a little bit
% by applying pchip interpolation
X_new = min(X_f) : smoother : max(X_f);
Y_new = interpn(X_f, Y_f, X_new, 'pchip');

end