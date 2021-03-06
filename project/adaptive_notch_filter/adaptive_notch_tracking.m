%% Part b - track a chirp signal
%

clc;clear;close all;

%load('speech.mat');
%load('speech_fs.mat');

mu = .0005; % learning rate
f_d = .1;  % desired frequency(s)
l = 1000; %length(data); % length of signals
r = .90; % rejection bandwidth
a = zeros([1 l]); % a = -2cosf_i(w)

n = 1:l;
% generate desired signal (for now a simple sine wave)
x_d = awgn(sin(2*pi*f_d*n),0);

% generate interference signal (very low signal to interference ratio)
f0 = .3;
f1 = .35;
t = 1:l;
t1 = l;
x_ispeech = 30*chirp(t,f0,t1,f1);
%x_n = (data'/2) + x_ispeech;

% mix signals
x_i = 30*chirp(t,f0,t1,f1);
x_n = x_d + x_i;

%initialize output vector
y_n = zeros([1 length(x_n)]);

% learn adaptive notch filter
for i = 3:length(x_n)
    
    % calculate intermediate sample
    e_n = x_n(i) + a(i)*x_n(i-1) + x_n(i-2);
    
    % calculate output sample
    y_n(i) = e_n - r*a(i)*y_n(i-1) - (r^2)*y_n(i-2);
    
    % update parameter a
    a(i+1) = a(i) - mu*y_n(i)*x_n(i-1);
    
    % reset a to 0 if outside -2 <= a <= 2 bound
    if (a(i+1) <= -2)
        a(i+1) = 0;
    end
    if (a(i+1) >= 2)
        a(i+1) = 0;
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
b = [1 a 1];
aa = [1 r*a r*r];
[H,w] = freqz(b,aa,l*2);
figure;
plot(w/(2*pi),abs(H))
title('Magnitude of learned filter');
xlabel('frequency (radians)');
ylabel('magnitude');
print -depsc track_inout

% plot a which is frequncy of notch filter (to observe how well it adapts)
figure;
plot(acos(a/-2));
title('adaptive filter frequency');
xlabel('time samples (n)');
ylabel('frequency where notch filter is ... notched');
print -depsc track_a
