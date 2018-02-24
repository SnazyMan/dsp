%%
% Tyler Olivieri DSP ESE531 HW5

clc;clear;

% 3 points
t = [ 0 1 2 ];
x = [ 2 1 -1 ];

% % fit analog signal with sine wave
syms A w phi;
eqns = [A*cos(phi) == 2, A*cos(w + phi) == 1, A*cos(2*w + phi) == -1];
S = solve(eqns, [A w phi]);
t_sin = -5:.01:5;
x_sin = S.A(1)*cos(S.w(1).*t_sin + S.phi(1));
x_sin2 = S.A(2)*cos(S.w(2).*t_sin + S.phi(2));
plot(t_sin, x_sin, t_sin, x_sin2)
title('Sine wave(s) fit to 3 sample signal');
xlabel('time');
ylabel('amplitude');
legend('Sine wave 1', 'Sine wave 2');
print -depsc sinFit

% fit analog signal with linear interpolation
t_li = (0:.01:2);
x_li = interp1q(t', x', t_li');

figure;
plot(t,x,'o',t_li,x_li);
title('linear interpolation, (matlab function)');
xlabel('samples (n), with .01 grid between samples');
ylabel('amplitude');
print -depsc linInterpMatlabFunc

% convolve the three samples with an impulse response that is triangular,
% upsample by 4, lowpass using impulse response of a triangle
x_us = upsample(x,5);
t_us =(0:.2:2);
x_us = x_us(1:end-4);
h_ir = [.2 .4 .6 .8 1 .8 .6 .4 .2];
y = conv(x_us, h_ir, 'same');

figure;
plot(t,x,'o',t_us,y)
title('linear interpolation, upsample and linear interpolation');
xlabel('samples(n), with .2 grid between samples');
ylabel('amplitude');
print -depsc linearInterpUp

% second degree polynomial fitting
p = polyfit(t,x,2);

t_p = -5:.01:5;
xeval = polyval(p,t_p);

figure;
plot(t_p, xeval);
title('polynomial fit of 3 sample signal');
xlabel('time');
ylabel('amplitude');
print -depsc polyFit

% fitting using 'ideal lowpass'
% convolution by sinc in time domain
delta = 1;
t_sinc = -5:.01:5;
x_sinc = sinc(t_sinc);
y_sinc = conv(x_sinc, delta);
y_sinc3 = conv(x_sinc, x, 'same');
figure;
plot(t_sinc, y_sinc)
title('sinc convolved with delta');
xlabel('time');
ylabel('amplitude');
print -depsc sincD

figure;
plot(t_sinc, y_sinc3)
title('sinc convolved with 3 sample signal');
xlabel('time');
ylabel('amplitude');
print -depsc sinc3