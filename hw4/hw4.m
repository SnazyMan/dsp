%% Tyler Olivieri ESE 531 DSP Hw4
%

clc; clear;

% generate a simlated sinusoid analog signal
fsim = 80e3;
Tsim = 1 / fsim;
T = 80e3 / 1000;
t = 0:Tsim:Tsim*1000;
f0 = 1e3;
x = cos(2*pi*f0.*t);

figure(1);
plot(t, x)
title('simulated CT signal cos(2*pi*1000*t)');
xlabel('time');
ylabel('amplitude')
print -depsc originalSignal 

% plot fourier transform of 'analog' signal
fmagplot(x, Tsim);

% sample 'analog' signal
fs = 8e3;
L = fsim / fs;
for i = 1:(length(x)/L)
    xs(i) = x(i*L);
end

figure;
stem(xs);
title('Sampled cos(2*pi*1000*t)');
xlabel('n (samples)');
ylabel('amplitude')
print -depsc sampledSignal

[w, x_f] = dtft(xs);
figure;
plot(w, abs(x_f))
title('dtft of sampled cos(2*pi*1000*t)');
xlabel('frequency (rad/sample)');
ylabel('magnitude of dtft');
print -depsc dtftSampled

% Create reconstruction filter
fcut = 2*(fs/2)/fsim;
figure;
[b,a] = cheby2(9, 60, fcut);
freqz(b,a);
title('Reconstruction filter frequency response');
print -depsc filterResponse

% zero stuff
xr = upsample(xs,L);
xc = filter(b, a, xr);
figure;
plot(t(1:end-1), xc);
title('Reconstructed signal');
xlabel('time (seconds)');
ylabel('amplitude')
print -depsc reconstructedSignal

[w_c, x_c] = dtft(xc);
figure;
plot(w, abs(x_f))
title('dtft of reconstructed signal');
xlabel('frequency (rad/sample)');
ylabel('magnitude of dtft');
print -depsc dtftReconstructed