function y = invert_conv(x,z)

xpad = [x;zeros(length(z)-length(x),1)];

y = ifft(fft(z)./fft(xpad));

y = y(1:length(z)-length(x)+1);
