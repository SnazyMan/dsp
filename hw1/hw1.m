% dsp hw1 
% Tyler Olivieri

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

% Apply a 5-point moving MA filter to the sequence {x[n]}
% and generate the output sequence {y[n]}. Plot {s[n]} and {y[n]}
% on the same (labeled!) axes to observe the effect of filtering.
% y[n] = (1/5)SUM(x[n-k]) | k = 0 to k = 4
% write a function for this. Could become useful later
window_size = 5;
b = (1 / window_size) * ones(1, window_size);
a = 1;
y_n = filter(b, a, x_n);

% Instead of noise, generate an interfence frequency
% w_int[n] = cos(2*pi*fn) for n = 0,1, ..., 100 with f = .2. 
% x_int[n] = s[n] + w_int[n]
f = .2;
w_int = cos(2 * pi * f .*n);
x_int = s_n + w_int;

% Filter x_int[n] with an M-point MA filter for M = 4, 5, and 6.
window_size = 4;
b = (1 / window_size) * ones(1, window_size);
a = 1;
y_int4 = filter(b, a, x_n);

window_size = 5;
b = (1 / window_size) * ones(1, window_size);
a = 1;
y_int5 = filter(b, a, x_n);

window_size = 6;
b = (1 / window_size) * ones(1, window_size);
a = 1;
y_int6 = filter(b, a, x_n);

% Plot the discrete time signals {s[n]}, {w[n]}
% and {x[n]}. Label axis
figure(1);
subplot(3, 1, 1)
stem(n, s_n)
title('Signal s[n]')
xlabel('n')
ylabel('s[n] = 2n * (.9)^n')
ylim([-5 10])
subplot(3, 1, 2)
stem(n, w_n);
title('Gaussian white noise N(0,1), w[n]')
xlabel('n')
ylabel('w[n] N(0,1)')
ylim([-5 10])
subplot(3, 1, 3)
stem(n, x_n)
title('Signal x[n]') 
xlabel('n')
ylabel('x[n] = s[n] + w[n]')
ylim([-5 10])

% plot s[n] and y[n] to observe the effects of filtering
figure(2);
subplot(2, 1, 1)
stem(n, s_n)
title('Signal s[n]')
xlabel('n')
ylabel('s[n] = 2n * (.9)^n')
ylim([-5 10])
subplot(2, 1, 2)
stem(n, y_n)
title('Signal y[n]')
xlabel('n')
ylabel('5-point moving MA of x[n]')
ylim([-5 10])

% plot results MA filter, y_int[n]
figure(3);
subplot(2, 2, 1)
stem(n, x_int)
title('Signal x-int[n]')
xlabel('n')
ylabel('x-int[n] = s[n] + w-int[n]')
subplot(2, 2, 2)
stem(n, y_int4);
title('Signal y-int[n] MA 4')
xlabel('n')
ylabel('y-int[n]')
subplot(2, 2, 3)
stem(n, y_int5)
title('Signal y-int[n] MA 5')
xlabel('n')
ylabel('y-int[n]')
subplot(2, 2, 4)
stem(n, y_int6)
title('Signal y-int[n] MA 6')
xlabel('n')
ylabel('y-int[n]')

% Is the interference completely removed?
% No it is not completely removed or y-int6[n] = s[n] 
% We would have to use a Nulling filter to remove the frequency
%