%% ESE531 DSP Tyler Olivieri HW7
% 

clc;clear;close all;

load('./nspeech2.mat');

fftLen = 1024;
freqVec = linspace(-pi, pi, fftLen);
N = [21 101];
for i = 1:length(N)
    h = LPFtrunc(N(i));
    H = fft(h, fftLen);
    H = fftshift(H);
    magH = abs(H);
    dbMag = 20*log10(magH);
    
    % -- the old plot
    str = sprintf("Frequency response magnitude N = %d", N(i));
    strPrint = sprintf('mag%d', N(i));
    fig = figure;
    plot(freqVec, magH)
    title(str);
    xlabel('frequency (radians)');
    ylabel('Magnitude');
    print(fig, strPrint,'-depsc');    
    
    strDB = sprintf("Frequency response Magnitude (dB) N = %d", N(i));
    strPrintDB = sprintf('magDB%d', N(i));
    fig2 = figure;
    plot(freqVec, dbMag)
    title(strDB);
    xlabel('frquency (radians)');
    ylabel('Magnitude (dB)');
    print(fig2, strPrintDB,'-depsc');
    
    % apply filters to speech signal
    filtSpeech{i} = conv(nspeech2, h);
end


%%
%

clc;clear;close all;

fftLen = 1024;
N = 23;
freqVec = linspace(-pi, pi, fftLen);

middle = ones([1 307]);
high = zeros([1 358]);
low = zeros([1 359]);
hd = horzcat([low middle]);
hd = horzcat([hd high]);

wc = .3*pi;
n = -(N-1)/2:1:(N-1)/2;
h = (wc/pi).*sinc(wc.*n./pi);

% rectangular window (effectively no window)
H = fft(h, fftLen);
H = fftshift(H);
magH = abs(H);
phaseH = angle(H);
mse_rect = (1/length(magH)) .* sum((hd - magH).^2);

% barlett window
bart = bartlett(N);
bart_h = bart' .* h;
bart_H = fft(bart_h, fftLen);
bart_H = fftshift(bart_H);
bart_magH = abs(bart_H);
bart_phaseH = angle(bart_H);
mse_bart = (1/length(bart_magH)) .* sum((hd - bart_magH).^2);

% hanning window
hanning = hann(N);
hann_h = hanning' .* h;
hann_H = fft(hann_h, fftLen);
hann_H = fftshift(hann_H);
hann_magH = abs(hann_H);
hann_phaseH = angle(hann_H);
mse_hann = (1/length(hann_magH)) .* sum((hd - hann_magH).^2);

% hamming window
hamm = hamming(N);
hamm_h = hamm' .* h;
hamm_H = fft(hamm_h, fftLen);
hamm_H = fftshift(hamm_H);
hamm_magH = abs(hamm_H);
hamm_phaseH = angle(hamm_H);
mse_hamm = (1/length(hamm_magH)) .* sum((hd - hamm_magH).^2);

% blackman window
black = blackman(N);
black_h = black' .* h;
black_H = fft(black_h, fftLen);
black_H = fftshift(black_H);
black_magH = abs(black_H);
black_phaseH = angle(black_H);
mse_black = (1/length(black_magH)) .* sum((hd - black_magH).^2);

figure;
subplot(3,1,1)
stem(n, h)
title('impulse response (rectangular window)');
ylabel('amplitude');
xlabel('samples (n)');
subplot(3,1,2)
plot(freqVec, magH)
title('magnitude response');
ylabel('magnitude');
xlabel('frequency (radian)');
ylim([0 1.1])
subplot(3,1,3)
plot(freqVec, phaseH)
title('phase response');
ylabel('phase');
xlabel('frequency (radians)');
print -depsc rect

figure;
subplot(3,1,1)
stem(n, bart_h)
title('impulse response (bartlett window)');
ylabel('amplitude');
xlabel('samples (n)');
subplot(3,1,2)
plot(freqVec, bart_magH)
title('magnitude response');
ylabel('magnitude');
xlabel('frequency (radian)');
ylim([0 1.1])
subplot(3,1,3)
plot(freqVec, bart_phaseH)
title('phase response');
ylabel('phase');
xlabel('frequency (radians)');
print -depsc bart

figure;
subplot(3,1,1)
stem(n, hann_h)
title('impulse response (hanning window)');
ylabel('amplitude');
xlabel('samples (n)');
subplot(3,1,2)
plot(freqVec, hann_magH)
title('magnitude response');
ylabel('magnitude');
xlabel('frequency (radian)');
ylim([0 1.1])
subplot(3,1,3)
plot(freqVec, hann_phaseH)
title('phase response');
ylabel('phase');
xlabel('frequency (radians)');
print -depsc hann

figure;
subplot(3,1,1)
stem(n, hamm_h)
title('impulse response (hamming window)');
ylabel('amplitude');
xlabel('samples (n)');
subplot(3,1,2)
plot(freqVec, hamm_magH)
title('magnitude response');
ylabel('magnitude');
xlabel('frequency (radian)');
ylim([0 1.1])
subplot(3,1,3)
plot(freqVec, hamm_phaseH)
title('phase response');
ylabel('phase');
xlabel('frequency (radians)');
print -depsc hamm

figure;
subplot(3,1,1)
stem(n, black_h)
title('impulse response (blackman window)');
ylabel('amplitude');
xlabel('samples (n)');
subplot(3,1,2)
plot(freqVec, black_magH)
title('magnitude response');
ylabel('magnitude');
xlabel('frequency (radian)');
ylim([0 1.1])
subplot(3,1,3)
plot(freqVec, black_phaseH)
title('phase response');
ylabel('phase');
xlabel('frequency (radians)');
print -depsc blackman

figure;
plot(freqVec, magH)
hold on
plot(freqVec, bart_magH)
plot(freqVec, hann_magH)
plot(freqVec, hamm_magH)
plot(freqVec, black_magH)
legend('rect', 'bart', 'hann', 'hamm', 'black');
print -depsc windows

%%
%

clc;clear;close all;

fftLen = 1024;
N = 23;
freqVec = linspace(-pi, pi, fftLen);

% parks-mcclellan lowpass - 
% w_p = 1.8
% w_s = 2.2
f = [1.8 2.2];
fs = 2*pi;

% desired amplitude in pass 1; stop - 0
a = [1 0];

% allowable ripple
% delta_p = .05
% delta_s = .005
dev = [.05 .005];

[n,f0,a0,w] = firpmord(f,a,dev,fs);
h = firpm(n+3,f0,a0,w);

% analyze frequency domain of filter
H = fftshift(fft(h, fftLen));
Hmag = abs(H);
Hmag_db = 20*log10(Hmag);

N = -(ceil(n/2)):1:(n-1)/2;

figure;
plot(freqVec,Hmag_db)
title('Filter order 28 in dB');
xlabel('frequency (radians)');
ylabel('magnitude (dB)');
print -depsc pmdb

figure;
plot(freqVec,Hmag);
title('Filter order 28');
xlabel('frequency (radians)');
ylabel('magnitdue ');
print -depsc pm