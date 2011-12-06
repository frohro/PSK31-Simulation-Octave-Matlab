function [sync_idx] = sync_psk31(v, zero, frac)
% This script is to synchronize the psk31 signal.
%
% v is the baseband signal to be synchronized
% coming from encode_psk31 or a down converted (to DC)
% signal.
%
% zero is the signal of the zero symbol which you
% are trying to synchronize to.  It assumes a
% constant baud rate of the length of that symbol,
% and assumes that the other symbol = - pulse.
%
%frac throws out peaks < frac(max(dp))
% 
% (C) Rob Frohne, 2011
%

N = length(v);
M = length(zero);  % The number of points in one bit time.
dp = [];					  
for k=1:N-M
	dp = [dp,v(k:k+M-1)*zero'];
end

% Notes regarding synchronization:
% Only synchronize when a PSK signal is present.
% Use all the information you have about the signal & dp.
% Here is a list those facts that occur to me.
% 	1) The baud rate is 31.25.
%	2) Only 0's give you sync data.
%	3) In dp peaks represent where the data matched
%		a zero the best, and valleys where the data
%		matched -zero the best.
%	4) You match zero and -zero alternately.
%	5) The dp is a matched filter (optimum for AWGN)
%		to the zero signal.
%	6) The zero has less power than the one.
%   7) Maxima should occur at intervals of mod M.
 

%Note: We use the negative peaks, but not the fact that 
%they alternate below.

peaky = [abs(dp) > max(abs(dp))*frac].*abs(dp); % Make zeros of all 
						% values that are less than frac of the max.
peaks = maxima(peaky);  % Find the local maxima in peaky. Note maxima
						% needs to be set to not get flat places. 
						% because 0's cause problems then.
idx = round(mean(mod(peaks,M/2))); % Note: abs() doubles the frequency of 
						%the peaks => M/2.
peaks_cleaned = [(mod(peaks,M/2) - idx) < (M/20)].*peaks; % Throw out 
						% bad peaks (ones not close to probable sync).
peaks_cleaned = peaks_cleaned(~~peaks_cleaned); % Get rid of zeros.
plot(dp,'b-',peaky,'r-',peaks_cleaned,dp(peaks_cleaned),'g*')
sync_idx = round(mean(mod(peaks_cleaned,M/2)))

