function [bitstream] = demod_to_bitstream(v,Fs)
% Demodulates PSK31 to a bitstream like make_bits
% generates.

t0 = 0:1/Fs:1/31.25-1/Fs;

one = ones(size(t0)); 
zero = cos(pi*t0*31.25);

ind = sync_psk31(v,zero,.5)

% Construct the bit stream by doing the matched filter to a bit pulse.
M = length(zero);
bitstream = [];
m=1;
for k = 0:floor((length(v)-ind)/M)-1
	% Note: every zero we get, changes the sign of inequality below.
	bitstream = [bitstream, [(v(1,k*M+ind:(k+1)*M+ind-1)*zero')*m < (v(1,k*M+ind:(k+1)*M+ind-1)*one')*m]];
	if(bitstream(k+1) == 0) 
		m = -m;
	end
end

