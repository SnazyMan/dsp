rng('default');
%%%
%SETUP
%%%
SNR = 25; %SNR of additive white noise in dB
s_length = 1000;
step_size = .01;
M = 25;

h_n = [0.3 1 0.7 0.3 .02];
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

x_n = awgn(conv(s_n, h_n, 'same'), SNR);


%Training
%w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
%Simulation
y_n = zeros(1,M);
g_n = zeros(1,M);
for i = 1:s_length
    y_n = [x_n(i) y_n(1:M-1)];
    g_n = constant_modulus(step_size, g_n, y_n);
    corrected_signal = sign(y_n*g_n'); %not sure if sign is needed here
    fprintf("Error found to be %f\n", immse(corrected_signal, s_n(i)));
end
