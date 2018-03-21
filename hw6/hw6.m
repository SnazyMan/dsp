%% Tyler Olivieri - DSP ESE 531 - HW6
%
clc;clear;

% observe effects of group delay

% create shifted unit impulse signal
n = -64:1:63;
length = 128;
x = zeros([1,length]);
x(length/2 - 4) = 1;
%x(length/2 + 5) = 1;

% compute group delay of signal
[gd, w] = gdel(x, n, 1024);

figure;
subplot(2,1,1);
stem(n, x)
title('input signal');
xlabel('n samples');
ylabel('amplitude');
subplot(2,1,2);
plot(w, gd)
title('group delay');
xlabel('frequency');
ylabel('amplitude');
ylim([-10 0]);
print -depsc signal1

%%
% 

clc;clear;

% define impluse
n = -64:1:63;
n_length = 128;
N_fft = 512;
x = zeros([1,n_length]);
x(n_length/2) = 1;

b = [1];
a = [1 -.77];
y = filter(b, a, x);
    
% Take the fourier transform. 
FT = fft(y, N_fft);

% compute and plot group delay
[gd, w] = gdel(y, n, N_fft);

figure;
subplot(3,1,1);
stem(n, y);
title('impulse response; pole at z = .77');
xlabel('n samples');
ylabel('amplitude');
subplot(3,1,2);
plot(w, abs(fftshift(FT)));
xlabel('frequency')
ylabel('Magnitude');
title('FFT');
subplot(3,1,3);
plot(w, gd);
title('group delay');
xlabel('frequency');
ylabel('amplitude');
print -depsc z77

a = [1 -.95];
y = filter(b, a, x);

% Take the fourier transform. The fftshift will duplicate our FT for
% negative frequencies. (Plot is centered at zero)
FT = fft(y, N_fft);

% compute and plot group delay
[gd, w] = gdel(y, n, N_fft);

figure;
subplot(3,1,1);
stem(n, y);
title('impulse response; pole at z = .95');
xlabel('n samples');
ylabel('amplitude');
subplot(3,1,2);
plot(w, abs(fftshift(FT)));
xlabel('frequency')
ylabel('Magnitude');
title('FFT');
subplot(3,1,3);
plot(w, gd);
title('group delay');
xlabel('frequency');
ylabel('amplitude');
print -depsc z95

%%
%

clc;clear;

% define impluse
n = -64:1:63;
n_length = 128;
N_fft = 512;
x = zeros([1,n_length]);
x(n_length/2) = 1;

b = [1];
a = [1 -.95];
y = filter(b, a, x);
y = fliplr(y);
    
% Take the fourier transform. 
FT = fft(y, N_fft);

% compute and plot group delay
[gd, w] = gdel(y, n, N_fft);

figure;
subplot(3,1,1);
stem(n, y);
title('impulse response; pole at z = .95, time reversed');
xlabel('n samples');
ylabel('amplitude');
subplot(3,1,2);
plot(w, abs(fftshift(FT)));
xlabel('frequency')
ylabel('Magnitude');
title('FFT');
subplot(3,1,3);
plot(w, gd);
title('group delay');
xlabel('frequency');
ylabel('amplitude');
print -depsc z95anti
