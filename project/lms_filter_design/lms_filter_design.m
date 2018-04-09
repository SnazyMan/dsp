%% Filter Design using LMS Algorithm
% Tyler Olivieri & Eric Stahl
% ESE531 DSP Final Project

clc;clear;close all;

M = 129; % desired filter length
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
    %h_lms = h_lms + mu * x_in(i-M+1:i) * err(i);
    % below enforces symmetry (which enforces linear phase)
    h_lms(1:ceil(M/2)) = h_lms(1:ceil(M/2)) + mu * x_in(i-M+1:i-floor(M/2)) * err(i);
    h_lms(ceil(M/2)+1:M) = fliplr(h_lms(1:floor(M/2)));
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
H_ang = fftshift(angle(fft(x_in,K*2)));
figure;
subplot(2,1,1)
plot(w,H);
title('Magnitude response of input signal');
xlabel('frequency (radians)');
ylabel('amplitude');
subplot(2,1,2)
plot(w,H_ang);
title('phase response of input signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response of desired signal
w = linspace(-pi, pi, K*2);
H = fftshift(abs(fft(x_d,K*2)));
H_ang = fftshift(angle(fft(x_d,K*2)));
figure;
subplot(2,1,1)
plot(w,H);
title('Magnitude response of desired signal');
xlabel('frequency (radians)');
ylabel('amplitude');
subplot(2,1,2)
plot(w,H_ang);
title('phase response of desired signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response of learned fitler
w = linspace(-pi, pi, K*10);
H = fftshift(abs(fft(h_lms,K*10)));
H_ang = fftshift(angle(fft(h_lms,K*10)));
figure;
subplot(2,1,1)
plot(w,H);
title('Magnitude response of learned filter');
xlabel('frequency (radians)');
ylabel('amplitude');
subplot(2,1,2)
plot(w,H_ang);
title('phase response of learned filter');
xlabel('frequency (radians)');
ylabel('angle');

% plot error as a function of iterations
figure;
plot(err)
title('Error as a function of round')
xlabel('round')
ylabel('loss on each round')

n = -floor(M/2):floor(M/2);
[gd, w] = gdel(h_lms, n, M*100);
[gd,w] = grpdelay(h_lms,1, M*100);
figure;
plot(w,gd)
title('Group delay of learned filter');
xlabel('frequency');
ylabel('delay');



%% Part b
% different desired frequency response

clc;clear;close all;

M = 129; % desired filter length
K = 1000; % length of input sequence
L = linspace(0, .5, 100); % number of frequencies in input sequence
h_lms = zeros([1,M]); % initial settings for h_lms
mu = .0001; % learning rate for gradient descent 

% generate input and desired signals
x_in = generate_input(K, L);
x_d = generate_desired_b(K, L);

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
    %h_lms = h_lms + mu * x_in(i-M+1:i) * err(i);
    % below enforces symmetry (which enforces linear phase)
    h_lms(1:ceil(M/2)) = h_lms(1:ceil(M/2)) + mu * x_in(i-M+1:i-floor(M/2)) * err(i);
    h_lms(ceil(M/2)+1:M) = fliplr(h_lms(1:floor(M/2)));
end

% plot impulse response
figure;
stem(imag(h_lms));
title('learned impulse response (imaginary portion)');
xlabel('taps');
ylabel('amplitude');

% compute and plot frequency response of original signal
w = linspace(-pi, pi, K*2);
H = fftshift(abs(fft(x_in,K*2)));
figure;
subplot(2,1,1)
plot(w,H);
title('Magnitude response of input signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response of desired signal
w = linspace(-pi, pi, K*2);
H = fftshift(abs(fft(x_d,K*2)));
subplot(2,1,2)
plot(w,H);
title('Magnitude response of desired signal');
xlabel('frequency (radians)');
ylabel('amplitude');

% compute and plot frequency response of learned fitler
w = linspace(-pi, pi, K*10);
H = fftshift(abs(fft(h_lms,K*10)));
H_ang = fftshift(angle(fft(h_lms,K*10)));
figure;
subplot(2,1,1)
plot(w,H);
title('Magnitude response of learned filter');
xlabel('frequency (radians)');
ylabel('amplitude');
subplot(2,1,2)
plot(w,H_ang);
title('phase response of learned filter');
xlabel('frequency (radians)');
ylabel('angle');

%n = -floor(M/2):floor(M/2)
%[gd, w] = gdel(h_lms, n, M*100);
[gd,w] = grpdelay(h_lms,1, M*100);
%w = linspace(-pi,pi,M*10)
%h_ejw = fft(h_lms,M*10);
%gd = polyfit(w,unwrap(angle(h_ejw)),1);

figure;
plot(w,gd)
title('Group delay of learned filter');
xlabel('frequency');
ylabel('delay');

