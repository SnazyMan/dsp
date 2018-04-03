%% Filter Design using LMS Algorithm
% Tyler Olivieri & Eric Stahl
% ESE531 DSP Final Project

clc;clear;close all;

M = 128; % desired filter length
K = 1000; % length of input sequence
L = linspace(0, .5, 100); % number of frequencies in input sequence
h_lms = zeros([1,M]); % initial settings for h_lms
mu = .0001; % learning rate for gradient descent 

% generate input and desired signals
x_in = generate_input(K, L);
x_d = generate_desired(K, L);

% pad for convolution - ensure desired and output are matched
x_in = [zeros(1,floor((M-1)/2)) x_in zeros(1,ceil((M-1)/2))];

% LMS algorithm to find coeficients h_lms that approximate
% desired filter
for i = (M+1):(length(x_in)-M-1)
     
    % calculate output of filter 
    y = h_lms * x_in(i-M+1:i)';
    
    % compute error wrt to desired
    err(i) = (x_d(i-M+1) - y);
    
    % update coefficients
    h_lms = h_lms + mu * x_in(i-M+1:i) * err(i);
end

% plot impulse response
figure;
stem(h_lms);
title('learned impulse response');
xlabel('taps');
ylabel('amplitude');

% compute and plot frequency response of original signal
w = linspace(-pi, pi, K*2);
H = fftshift(abs(fft(x_in,K*2)));
figure;
plot(w,H);
title('Magnitude response of input signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response of desired signal
w = linspace(-pi, pi, K*2);
H = fftshift(abs(fft(x_d,K*2)));
figure;
plot(w,H);
title('Magnitude response of desired signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response
w = linspace(-pi, pi, K*10);
H = fftshift(abs(fft(h_lms,K*10)));
figure;
plot(w,H);
title('Magnitude response of learned filter');
xlabel('frequency (radians)');
ylabel('amplitude');

% plot error as a function of iterations
figure;
plot(err)



