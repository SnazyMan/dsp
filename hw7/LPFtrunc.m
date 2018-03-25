function [h] = LPFtrunc(N)
%LPFtrunc Truncated and shifted impulse response
% of size N

wc = 2.0;
n = -(N-1)/2:1:(N-1)/2;
h = (wc/pi).*sinc(wc.*n./pi);

end