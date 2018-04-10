%% Part 3
% cascaded adaptive notch filters

clc;clear;close all;

mu = .001; % learning rate
f_d = .1;  % desired frequency(s)
f_i = .25; % interference frequency 1
f_i2 = .4; % interference frequency 2
l = 10000; % length of signals
r = .95; % rejection bandwidth
a1 = 0; % a = -2cosf_i(w)
a2 = 0;

n = 1:l;
% generate desired signal (for now a simple sine wave)
x_d = sin(2*pi*f_d*n);

% generate interference signals (very low signal to interference ratio)
x_i = 5*sin(2*pi*f_i*n);
x_i2 = 5*sin(2*pi*f_i2*n);

% mix signals
x_n = x_d + x_i + x_i2;

%initialize output vector and intermediate 
y_n = zeros([1 length(x_n)]);
u_n = zeros([1 length(x_n)]);

% learn cascaded adaptive notch filter
for i = 3:length(x_n)
    
    % ----------- Notch 1 ----------------------
    % calculate intermediate sample
    e_n = x_n(i) + a1*x_n(i-1) + x_n(i-2);
    
    % calculate output sample
    u_n(i) = e_n - r*a1*u_n(i-1) - (r^2)*u_n(i-2);
    
    % update parameter a
    a1 = a1 - mu*u_n(i)*x_n(i-1);
    
    % reset a to 0 if outside -2 <= a <= 2 bound
    if (a1 <= -2)
        a1 = 0;
    end
    if (a1 >= 2)
        a1 = 0;
    end
    
    % ----------- Notch 2 ----------------------
      % calculate intermediate sample
    e_n = u_n(i) + a2*u_n(i-1) + u_n(i-2);
    
    % calculate output sample
    y_n(i) = e_n - r*a2*y_n(i-1) - (r^2)*y_n(i-2);
    
    % update parameter a
    a2 = a2 - mu*y_n(i)*u_n(i-1);
    
    % reset a to 0 if outside -2 <= a <= 2 bound
    if (a2 <= -2)
        a2 = 0;
    end
    if (a2 >= 2)
        a2 = 0;
    end
    
end

% plot frequency response of input signal
% w = linspace(-pi,pi,l*2);
% H = abs(fftshift(fft(x_d, l*2)));
% figure;
% plot(w,H)
% title('Magnitude of input signal');
% xlabel('frequency (radians)');
% ylabel('magnitude');

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

% frequency response of learned filter ** normalized so freq appears 0 to
% .5
b = [1 a1 1];
aa = [1 r*a1 r*r];
[H,w] = freqz(b,aa,l*2);
figure;
subplot(2,1,1)
plot(w/(2*pi),abs(H))
title('Magnitude of learned filter');
xlabel('frequency (radians)');
ylabel('magnitude');

b = [1 a2 1];
aa = [1 r*a2 r*r];
[H,w] = freqz(b,aa,l*2);
subplot(2,1,2)
plot(w/(2*pi),abs(H))
title('Magnitude of learned filter');
xlabel('frequency (radians)');
ylabel('magnitude');
