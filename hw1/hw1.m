% dsp hw1 
% Tyler Olivieri

% Instead of noise, generate an interfence frequency
% w_int[n] = cos(2*pi*fn) for n = 0,1, ..., 100 with
% f = .2. Filter x_int[n] = s[n] + w_int[n] with an M-point
% MA filter for M = 4, 5, and 6.
% Is the interference completely removed?
clc; clear;

% generate signal s[n] = 2n(.9)^n for n = 0,1, ..., 100
n = 0:1:100;
s_n = 2.*n.*(.9).^n;

% generate independent gaussian random noise with mean = 0
% and variance = 1, w[n], for n = 0, 1, ..., 100
% Note noise power in decibels:: dB = 10log10(Variance)
w_n = wgn(101, 1, 0);
dB = 10 * log10(var(w_n));

% generate x[n] = s[n] + w[n]
x_n = s_n' + w_n;

% Plot the discrete time signals {s[n]}, {w[n]}
% and {x[n]}. Label axis
figure(1);
subplot(3, 1, 1)
stem(n, s_n)
title('Signal s[n]')
xlabel('n')
ylabel('s[n] = 2n * (.9)^n')
subplot(3, 1, 2)
stem(n, w_n);
title('Gaussian white noise N(0,1), w[n]')
xlabel('n')
ylabel('w[n] N(0,1)')
subplot(3, 1, 3)
stem(n, x_n)
title('Signal x[n]') 
xlabel('n')
ylabel('x[n] = s[n] + w[n]')

% Apply a 5-point moving MA filter to the sequence {x[n]}
% and generate the output sequence {y[n]}. Plot {s[n]} and {y[n]}
% on the same (labeled!) axes to observe the effect of filtering.
% y[n] = (1/5)SUM(x[n-k]) | k = 0 to k = 4
% write a function for this. Could become useful later