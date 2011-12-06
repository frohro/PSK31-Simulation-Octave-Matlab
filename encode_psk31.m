function [t,v]=encode_psk31(message,phase,Fs,fc)
% This file encodes Binary PSK31 signals.
% Usage:  [v] = encode_psk31(message,phase)
% message is a text string to be encoded
% phase is the phase offset of the baseband signal
% Fs is the sample rate
% fc is the carrier frequency
% The baud rate is 31.25 symbols/second
% (C) Rob Frohne, 2011

message_bit = make_bits(message);

t0 = 0:1/Fs:1/31.25-1/Fs;
one = ones(size(t0)); 
zero = cos(pi*t0*31.25);
						  
baseband = [];
m=1;
for k = 1:length(message_bit)
	if(message_bit(k)==0) 
		baseband = [baseband, zero*m];
		m=-m;
	else
		baseband = [baseband, one*m];
	end
end

t = 0:1/Fs:length(baseband)/Fs-1/Fs;

v = real(exp(j*2*pi*fc*t+phase).*baseband);

