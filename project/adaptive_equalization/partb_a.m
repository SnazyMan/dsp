clc;
clear all;
rng('default');
%%%
%SETUP
%%%

%Change these parameters
SNR = 25; %SNR of additive white noise in dB
s_length = 2000;
t_delay = 2; %units of delay for adaptive filter
step_size = .01;
lms_iters = 1;
M = 25; %AF Filter Size
N = 5; %Channel Unit-Sample Response Size

%Useful constants
n = 0:1:N-1;
m = 0:1:M-1;
w = -1:1/512:1 - 1/1024;

%Channel Definition and Analysis
h_n = [0.3 1 0.7 0.3 .02];
h_zeros = roots(h_n);
h_ejw = fftshift(fft(h_n, 1024));

%Generate Input Data
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

%desired signal is time delayed
d_n = [zeros(1,t_delay) s_n(1:end-t_delay)];

%add noise
x_n = awgn(conv(s_n, h_n, 'same'), SNR);

%Training
w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
w_ejw = fftshift(fft(w_n, 1024));

figure;
subplot(3,1,1);
stem(n,h_n);
title('Impulse Response of Noisy Channel');
xlabel('Samples');
ylabel('Amplitude');
subplot(3,1,2);
plot(w,mag2db(abs(h_ejw)));
title('Frequency Response of Noisy Channel');
xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
subplot(3,1,3);
zplane(h_n,1);
title('Pole-Zero Plot of Noisy Channel');
print -depsc channel_characteristics
figure;
subplot(2,1,1);
stem(m,w_n);
title('Impulse Response of Adaptive Filter');
xlabel('Samples');
ylabel('Amplitude');
subplot(2,1,2);
plot(w,mag2db(abs(w_ejw)));
title('Frequency Response of Adaptive Filter');
xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
print -depsc af_characteristics
%Generate Input Data
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

%desired signal is time delayed
d_n = [zeros(1,t_delay) s_n(1:end-t_delay)];

%add noise
x_n = awgn(conv(s_n, h_n, 'same'), SNR);
 
fprintf("Uncorrected Error found to be %f\n", immse(x_n, d_n));

%After Convergence
corrected_signal = conv(x_n, w_n, 'same'); 
fprintf("Corrected Error found to be %f\n", immse(corrected_signal, d_n));

h_n_noisy = awgn(h_n,SNR);
equalized_channel = conv(w_n, h_n_noisy,'same');
equalized_channel_ejw = fftshift(fft(equalized_channel, 1024));

figure;
subplot(2,1,1);
stem(m,equalized_channel);
title('Impulse Response of Equalized Channel');
xlabel('Samples');
ylabel('Amplitude');

subplot(2,1,2);
plot(w,mag2db(abs(equalized_channel_ejw)));
title('Frequency Response of Equalized Channel');
xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
print -depsc equalized_characteristics
err = zeros(1,20);

%Change Filter Order
for M = 10:1:30
    w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
    corrected_signal = conv(x_n, w_n, 'same'); 
    err(M-9) = immse(corrected_signal, d_n);
end
figure;
plot([10:1:30],err,'o');
title('Effects of Adaptive Filter Order');
xlabel('Adaptive Filter Order');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
M = 25; %Reset to Default
print -depsc af_order_effects

err = zeros(1,29);

%Change Step Size
for step_size=0.001:0.001:0.029
    w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
    corrected_signal = conv(x_n, w_n, 'same'); 
    err(int16(step_size*1000)) = immse(corrected_signal, d_n);
end
figure;
plot([0.001:0.001:0.029], err);
title('Effects of LMS Step Size');
xlabel('Step Size');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
step_size=0.01; %Reset to Default
print -depsc lms_ss_effects

err = zeros(1,296);

%Change input length
for s_length=50:10:3000
    s_n = randi([0 1], 1, s_length); %generate random binary sequence
    s_n(~s_n) = -1; %replace all 0s with -1s
    
    d_n = [zeros(1,t_delay) s_n(1:end-t_delay)];
    x_n = awgn(conv(s_n, h_n, 'same'), SNR);
    
    w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
    corrected_signal = conv(x_n, w_n, 'same'); 
    err(s_length/10 - 4) = immse(corrected_signal, d_n);
end
figure;
plot([50:10:3000],err);
title('Effects of Training Length');
xlabel('Input Signal s[n] Length');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});

s_length = 2000; %Reset to Default
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s
    
d_n = [zeros(1,t_delay) s_n(1:end-t_delay)];
x_n = awgn(conv(s_n, h_n, 'same'), SNR);
print -depsc training_length_effects

err = zeros(1,15);

%Change SNR
for SNR=20:1:35
    x_n = awgn(conv(s_n, h_n, 'same'), SNR);
    
    w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
    corrected_signal = conv(x_n, w_n, 'same'); 
    err(SNR - 19) = immse(corrected_signal, d_n);
end
figure;
plot([20:1:35],err, 'o');
title('Effects of SNR');
xlabel('SNR (dB)');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});

SNR = 25; %Reset to Default
print -depsc snr_effects
err = zeros(1,7);

%Change Unit Sample Response
for N=1:1:7
    h_n = rand([1,N]);
    w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
    corrected_signal = conv(x_n, w_n, 'same'); 
    err(N) = immse(corrected_signal, d_n);
end
figure;
plot([1:1:7],err, 'o');
title('Effects of Unit Sample Response Order');
xlabel('Unit Sample Response Order');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
print -depsc sample_response_order_effects
h_n = [0.3 1 0.7 0.3 .02]; %Reset to Default

