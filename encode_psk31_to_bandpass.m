[v]=encode_psk31_to_bandpass(message,phase,Fs,fc)
% This file encodes Binary PSK31 signals.
% Usage:  [v] = encode_psk31(message,phase)
% message is a text string to be encoded
% phase is the phase offset of the baseband signal
% Fs is the sample rate
% fc is the carrier frequency
% The baud rate is 31.25 symbols/second
% (C) Rob Frohne, 2011


pause;

baseband_bit = make_bits(message,phase);
t0 = 0:1/Fs:1/31.25;
pulse = ones(size(t0));  % Change this if you want the raised
						  % cosine pulse shape or something else.
pause;
baseband = [];
%for k = 1:length(baseband_bit)
%	baseband = [baseband, pulse.*baseband_bit(k)];
%end
t = 0:1/Fs:length(baseband);
v = real(exp(j*2*pi*fc*t).*baseband);
