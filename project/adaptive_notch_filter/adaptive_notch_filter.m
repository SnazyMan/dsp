%% Adaptive notch filter
% Tyler Olivieri & Eric Stahl
% ESE531 DSP Final Project

clc;clear;close all;

load('speech.mat');
load('speech_fs.mat');

mu = .01; % learning rate
a = 0; % a = -2cos(w)
f_d = .3;  % desired frequency(s)
f_i = .1;  % interference frequency
l = 208000; % length of signals
r = .95; % rejection bandwidth

n = 1:l;
% generate desired signal (for now a simple sine wave)
x_d = awgn(sin(2*pi*f_d*n),0);

% generate interference signal (very low signal to interference ratio)
x_i = 2*sin(2*pi*f_i*n);
n= 1:length(data);
x_ispeech = .5*sin(2*pi*f_i*n);
x_n = (data'/2) + x_ispeech;

% mix signals
%x_n = x_d + x_i;

%initialize output vector
y_n = zeros([1 length(x_n)]);

% learn adaptive notch filter
for i = 3:length(x_n)
    
    % calculate intermediate sample
    e_n = x_n(i) + a*x_n(i-1) + x_n(i-2);
    
    % calculate output sample
    y_n(i) = e_n - r*a*y_n(i-1) - (r^2)*y_n(i-2);
    
    % update parameter a
    a = a - mu*y_n(i)*x_n(i-1);
    
    % reset a to 0 if outside -2 <= a <= 2 bound
    if (a <= -2)
        a = 0;
    end
    if (a >= 2)
        a = 0;
    end
    
end

% plot frequency response of input signal
w = linspace(-pi,pi,l*2);
H = abs(fftshift(fft(x_d, l*2)));
figure;
plot(w,H)
title('Magnitude of input signal');
xlabel('frequency (radians)');
ylabel('magnitude');

% plot frequency response of corrupted signal
w = linspace(-pi,pi,l*2);
H = abs(fftshift(fft(x_n, l*2)));
figure;
subplot(2,1,1)
plot(w,H)
title('Magnitude of desired + interference signal');
xlabel('frequency (radians)');
ylabel('magnitude');

% plot frequency response of output signal
w = linspace(-pi,pi,l*2);
H = abs(fftshift(fft(y_n, l*2)));
subplot(2,1,2)
plot(w,H)
title('Magnitude of output signal');
xlabel('frequency (radians)');
ylabel('magnitude');
print -depsc adaptive_notch_inout

% frequency response of learned filter ** normalized so freq appears 0 to
% .5
b = [1 a 1];
aa = [1 r*a r*r];
[H,w] = freqz(b,aa,l*2);
figure;
plot(w/(2*pi),abs(H))
title('Magnitude of learned filter');
xlabel('Normalized frequency (radians / 2*pi)');
ylabel('magnitude');
print -depsc adaptive_notch_learned

