function [peak_indices] = maxima(a)
% Finds the local maxima of a vector (1xn) and returns the indices

n=length(a);
r = [a(1,2:n) - a(1,1:n-1) < 0, 1]; % derivative on the right <= 0
l = [1, a(1,2:n) - a(1,1:n-1) > 0]; % derivative on the left >= 0
d = l & r;
peak_indices = find(d);
