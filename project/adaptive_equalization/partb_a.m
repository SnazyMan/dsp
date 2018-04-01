%%%
%SETUP
%%%
SNR = 30; %SNR of additive white noise in dB
s_length = 1000;
t_delay = 2; %units of delay for adaptive filter
step_size = .01;
lms_iters = 1000;
M = 23;

h_n = [0.3 1 0.7 0.3 .02];
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s
d_n = circshift(s_n, t_delay);

x_n = awgn(conv(s_n, h_n, 'same'), SNR);

%Training
w_n = train_adaptive_filter(step_size, d_n, x_n, M, lms_iters);
err_sum = 0;

%AVG Err over each window
for i = 0:floor(s_length/M)-1
    err_sum = err_sum + immse(d_n((i*M + 1):((i+1)*M))...
        ,w_n.*x_n((i*M + 1):((i+1)*M)));
end
fprintf("Error found to be %f\n", err_sum/floor(s_length/M));
%subplot(3, 1, 1);
%plot(h_n);
%subplot(3, 1, 2);
%plot(s_n);
%subplot(3,1,3);
%plot(conv(s_n, h_n, 'same'));