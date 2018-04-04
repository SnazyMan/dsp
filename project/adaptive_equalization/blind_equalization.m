rng('default');
%%%
%SETUP
%%%
SNR = 30; %SNR of additive white noise in dB
s_length = 10000;
step_size = .00001;
M = 15;

h_n = [0.3 1 0.7 0.3 .02];
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

%x_n = awgn(conv(s_n, h_n, 'same'), SNR);
x_n = conv(s_n, h_n, 'same');
%Training
%w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
%Simulation
y_n = zeros(1,M);
g_n = ones(1,M);
corrected_signal = zeros(1,s_length);
for i = 1:s_length
    y_n = [x_n(i) y_n(1:M-1)];
    corrected_signal(i) = sign(y_n*g_n'); %not sure if sign is needed here
    g_n = constant_modulus(step_size, g_n, y_n);
end
fprintf("Error found to be %f\n", immse(corrected_signal, s_n));
subplot(2,1,1);
stem(corrected_signal(900:920));
subplot(2,1,2);
stem(s_n(900:920));
%fprintf("Error found to be %f\n", immse(cs, s_n));