rng('default');
%%%
%SETUP
%%%
SNR = 30; %SNR of additive white noise in dB
s_length = 100000;
step_size = .001; %range 0.005 - ??? - dependent on s_length (inf at > 0.005)
M = 16;
N = 7;
NFFT = 1024;
w = 0:2*pi/NFFT: 2*pi - 2*pi/NFFT;

h_n = [0.3 1 0.7 0.2 0.3 0.4 0.1 zeros(1,M-N)];
h_ejw = fft(h_n, NFFT);
s_n = randi([0 1], 1, s_length); %generate random binary sequence
s_n(~s_n) = -1; %replace all 0s with -1s

s_n_window = zeros(1,M);
x_n = zeros(1,M);
y_n = zeros(1,M);
g_n = ones(1,M);
corrected_signal = zeros(1,s_length);
for i = 1:s_length
    s_n_window = [ s_n(i) s_n_window(1:M-1)];
    x_n = [s_n_window*h_n' x_n(1:M-1)];
    corrected_signal(i) = x_n*g_n'; %not sure if sign is needed here
    g_n = constant_modulus(step_size, g_n, x_n);
end
g_ejw = fft(g_n, NFFT);
apprx_delay_g = polyfit(w, unwrap(angle(g_ejw)),1);
apprx_delay_h = polyfit(w, unwrap(angle(h_ejw)),1);


%delay = abs(floor(apprx_delay_g(1) + apprx_delay_h(1))) + 1;
delay = 17;

aligned_cs = corrected_signal(delay:end);
aligned_sn = s_n(1:end-delay+1);
fprintf("Error found to be %f\n", immse(aligned_cs, aligned_sn));
subplot(5,1,1);
stem(aligned_cs(s_length-delay-100:end));
subplot(5,1,2);
stem(aligned_sn(s_length-delay-100:end));
subplot(5,1,3);
stem(g_n);
subplot(5,1,4);
plot(w, abs(h_ejw));
subplot(5,1,5);
plot(w, abs(g_ejw));
