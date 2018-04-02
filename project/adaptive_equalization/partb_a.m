rng('default');
%%%
%SETUP
%%%
SNR = 30; %SNR of additive white noise in dB
s_length = 1000;
t_delay = 2; %units of delay for adaptive filter
step_size = .001;
lms_iters = 1;
M = 23;

h_n = [0.3 1 0.7 0.3 .02];
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

%need to clarify if the signal is circshifted or zero padded
%d_n = circshift(s_n, t_delay);
d_n = [zeros(1,t_delay) s_n(1:end-t_delay)];

%%%For testing purposes, let's ignore SNR
%x_n = awgn(conv(s_n, h_n, 'same'), SNR); %awgn expects our signals to be
%in dB
x_n = conv(s_n, h_n, 'same');

%Training
w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);

corrected_signal = sign(conv(x_n, w_n, 'same')); %not sure if sign is needed here
fprintf("Error found to be %f\n", immse(corrected_signal, d_n));
subplot(2,1,1);
stem(corrected_signal(100:120));
subplot(2,1,2);
stem(d_n(100:120));