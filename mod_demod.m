% This encodes and decodes a PSK31 signal.

% Note: With this algorithm, being right on frequency is very very important!
% However, the noise performance is impressive when you are on frequency.

Fs =8000;
phrase = 'Hi there beautiful!';
[t,v] = encode_psk31(phrase,0,Fs,0); % Really we need to do this in terms
									 % of x(t) & y(t), here we use only x(t).
									 % Another way of saying this is, we 
									 % need to find the phase of v.
[t,v1]  = encode_psk31(phrase,0,Fs,375);

system('espeak "Here is the psk stream without noise modulated at 400 Hertz so you can hear it."')
soundsc(v1)

v = v+3*randn(size(v)); % add noise.
v1 = v1+3*randn(size(v)); % add noise.

system('espeak "Here is the psk stream modulated at 400 Hertz so you can hear it with noise."')
soundsc(v1)
specgram(v1)
pause
spec = abs(fftshift(fft(v1)));
plot(spec)
pause;

bitstream = demod_to_bitstream(v,Fs);
[make_bits(phrase)(1:length(bitstream))]-bitstream  % Test it out! (should return all 0's).
