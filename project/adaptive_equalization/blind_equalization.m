clc;
clear all;
rng('default');
%%%
%SETUP
%%%

%Change these parameters
SNR = 30; %SNR of additive white noise in dB
s_length = 50000;
step_size = .001; %sgd step size
M = 16; %AF Filter Size
N = 5; %Channel Unit-Sample Response Size
n = 0:1:M-1;

%Useful constants
NFFT = 1024;
w = -1:1/(0.5*NFFT):1 - 1/NFFT;

%Channel Definition and Analysis
h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
h_ejw = fftshift(fft(h_n, NFFT));

%Generate Input Data
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

%Initialize Arrays we will be interested in
s_n_window = zeros(1,M); %window of input signal
x_n = zeros(1,M); %output of noisy channel
corrected_signal = zeros(1,s_length); %store results of blind equalization

%In order for CM to converge, initialize filter with a non-zero value
g_n = ones(1,M);

%Run blind equalization over an optimal length first to show convergence
for i = 1:s_length
    s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
    x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
    corrected_signal(i) = x_n*g_n'; %store history for analysis of error
    g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
end

g_ejw = fftshift(fft(g_n, NFFT));

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
print -depsc channel_characteristics_blind_eq

figure;
subplot(2,1,1);
stem(n,g_n);
title('Impulse Response of Adaptive Filter');
xlabel('Samples');
ylabel('Amplitude');
subplot(2,1,2);
plot(w,mag2db(abs(g_ejw)));
title('Frequency Response of Adaptive Filter');
xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
print -depsc af_characteristics_blind_eq


%Generate Input Data
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s
%add noise
x_n = awgn(conv(s_n, h_n, 'same'), SNR);

fprintf("Uncorrected Error found to be %f\n", immse(s_n, x_n));

%After Convergence
corrected_signal = conv(x_n, g_n, 'same'); 

delay = finddelay(s_n, sign(corrected_signal)); %estimate the system lag

%align corrected signal with input signal to determine error
aligned_cs = corrected_signal(delay+1:end);
aligned_sn = s_n(1:end-delay);
fprintf("Corrected Error found to be %f\n", immse(aligned_cs, aligned_sn));

h_n_noisy = awgn(h_n,SNR);
equalized_channel = conv(g_n, h_n_noisy,'same');
equalized_channel_ejw = fftshift(fft(equalized_channel, NFFT));

figure;
subplot(2,1,1);
stem(n,equalized_channel);
title('Impulse Response of Equalized Channel');
xlabel('Samples');
ylabel('Amplitude');

subplot(2,1,2);
plot(w,mag2db(abs(equalized_channel_ejw)));
title('Frequency Response of Equalized Channel');
xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
print -depsc equalized_characteristics_blind_eq

err = zeros(1,100);

%Change Step Size
for step_size=0.0001:0.0001:0.01
h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
    %Initialize Arrays we will be interested in
    s_n_window = zeros(1,M); %window of input signal
    x_n = zeros(1,M); %output of noisy channel
    corrected_signal = zeros(1,s_length); %store results of blind equalization

    %In order for CM to converge, initialize filter with a non-zero value
    g_n = ones(1,M);

    %Run blind equalization over an optimal length first to show convergence
    for i = 1:s_length
        s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
        x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
        corrected_signal(i) = x_n*g_n'; %store history for analysis of error
        g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
    end
    
    %After Convergence
    delay = finddelay(s_n, corrected_signal); %estimate the system lag

    %align corrected signal with input signal to determine error
    aligned_cs = corrected_signal(delay+1:end);
    aligned_sn = s_n(1:end-delay);
    err(int16(step_size*10000)) = immse(aligned_cs, aligned_sn);
    
end

figure;

plot([0.0001:0.0001:0.01],err);

title('Effects of LMS Step Size');
xlabel('Step Size');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
print -depsc lms_ss_effects_blind_eq
step_size=0.001; %Reset to Default

err = zeros(1,14);

%Change Filter Order
for M = 5:1:19
    h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
    %Initialize Arrays we will be interested in
    s_n_window = zeros(1,M); %window of input signal
    x_n = zeros(1,M); %output of noisy channel
    corrected_signal = zeros(1,s_length); %store results of blind equalization

    %In order for CM to converge, initialize filter with a non-zero value
    g_n = ones(1,M);

    %Run blind equalization over an optimal length first to show convergence
    for i = 1:s_length
        s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
        x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
        corrected_signal(i) = x_n*g_n'; %store history for analysis of error
        g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
    end
    
    %After Convergence
    delay = finddelay(s_n, corrected_signal); %estimate the system lag

    %align corrected signal with input signal to determine error
    aligned_cs = corrected_signal(delay+1:end);
    aligned_sn = s_n(1:end-delay);
    err(M-4) = immse(aligned_cs, aligned_sn);
    
end

figure;

plot([5:1:19],err,'o');

title('Effects of Adaptive Filter Order');
xlabel('Adaptive Filter Order');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
print -depsc af_order_effects_blind_eq
M = 16; %Reset to Default

err = zeros(1,60);
%Change input length
for s_length=10000:1000:69000
    %Generate Input Data
    s_n = randi([0 1], 1, s_length); %generate random binary sequence
    s_n(~s_n) = -1; %replace all 0s with -1s
    
    h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
    %Initialize Arrays we will be interested in
    s_n_window = zeros(1,M); %window of input signal
    x_n = zeros(1,M); %output of noisy channel
    corrected_signal = zeros(1,s_length); %store results of blind equalization

    %In order for CM to converge, initialize filter with a non-zero value
    g_n = ones(1,M);

    %Run blind equalization over an optimal length first to show convergence
    for i = 1:s_length
        s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
        x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
        corrected_signal(i) = x_n*g_n'; %store history for analysis of error
        g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
    end
    
    %After Convergence
    delay = finddelay(s_n, corrected_signal); %estimate the system lag

    %align corrected signal with input signal to determine error
    aligned_cs = corrected_signal(delay+1:end);
    aligned_sn = s_n(1:end-delay);
    err(s_length/1000 - 9) = immse(aligned_cs, aligned_sn);

end

figure;
plot([10000:1000:69000],err, 'o');
title('Effects of Training Length');
xlabel('Input Signal s[n] Length');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
print -depsc training_length_effects_blind_eq

s_length = 50000;
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

err = zeros(1,15);

for SNR=20:1:35
    h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
    %Initialize Arrays we will be interested in
    s_n_window = zeros(1,M); %window of input signal
    x_n = zeros(1,M); %output of noisy channel
    corrected_signal = zeros(1,s_length); %store results of blind equalization

    %In order for CM to converge, initialize filter with a non-zero value
    g_n = ones(1,M);

    %Run blind equalization over an optimal length first to show convergence
    for i = 1:s_length
        s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
        x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
        corrected_signal(i) = x_n*g_n'; %store history for analysis of error
        g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
    end
    
    %After Convergence
    delay = finddelay(s_n, corrected_signal); %estimate the system lag

    %align corrected signal with input signal to determine error
    aligned_cs = corrected_signal(delay+1:end);
    aligned_sn = s_n(1:end-delay);
    err(SNR - 19) = immse(aligned_cs, aligned_sn);
end

plot([20:1:35],err, 'o');
title('Effects of SNR');
xlabel('SNR (dB)');
ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
SNR = 25; %Reset to Default
print -depsc snr_effects_blind_eq

err = zeros(1,7); 

for N=1:1:7
    h_n = [rand([1,N]) zeros(1,M-N)];

    %Initialize Arrays we will be interested in
    s_n_window = zeros(1,M); %window of input signal
    x_n = zeros(1,M); %output of noisy channel
    corrected_signal = zeros(1,s_length); %store results of blind equalization

    %In order for CM to converge, initialize filter with a non-zero value
    g_n = ones(1,M);

    %Run blind equalization over an optimal length first to show convergence
    for i = 1:s_length
        s_n_window = [ awgn(s_n(i), SNR) s_n_window(1:M-1)]; %right shift for new input
        x_n = [s_n_window*h_n' x_n(1:M-1)]; %right shift for channel output
        corrected_signal(i) = x_n*g_n'; %store history for analysis of error
        g_n = constant_modulus(step_size, g_n, x_n); %update AF coeficients
    end
    
    %After Convergence
    delay = finddelay(s_n, corrected_signal); %estimate the system lag

    %align corrected signal with input signal to determine error
    aligned_cs = corrected_signal(delay+1:end);
    aligned_sn = s_n(1:end-delay);    
    err(N) = immse(aligned_cs, aligned_sn);
end  
    figure;

    plot([1:1:7],err, 'o');
    title('Effects of Unit Sample Response Order');
    xlabel('Unit Sample Response Order');
    ylabel({'Mean Squared Error', ' Between Corrected and Desired'});
    print -depsc sample_response_order_effects_blind_eq
    
    h_n = [0.3 1 0.7 0.2 0.3 zeros(1,M-N)];
