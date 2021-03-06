%% 
% Tyler Olivieri ESE531 DSP HW3

clc; clear;

% Aliasing sinusoids
% Plot simple sampled sine wave
fs = 8000;
f0 = 300;
T = 1/fs;
n_time = 0:T:.01;
for n=1:length(n_time)
    x_n(n) = sin(2*pi*(f0/fs)*n);
end

figure(1);
stem(n_time, x_n);
title('300 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
print -depsc sin
%%
% (b)

% Plot a series of sinusoidal frequencies from 100Hz to 475Hz in steps of
% 125Hz

clc; clear;

fs = 8000;
f0 = 100:125:475;
T = 1/fs;
n_time = 0:T:.01;
for i = 1:length(f0)
    for n = 1:length(n_time)
        x_n(n,i) = sin(2*pi*(f0(i)/fs)*n);
    end
end

figure(2);
subplot(4,1,1)
stem(n_time, x_n(:,1));
title('100 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,2)
stem(n_time, x_n(:,2));
title('225 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,3)
stem(n_time, x_n(:,3));
title('350 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,4)
stem(n_time, x_n(:,4));
title('475 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
print -depsc sinnoalias

%%
% (c)

% same thing as (b) except vary frequency from 7525Hz to 7900Hz

clc; clear;

fs = 8000;
f0 = 7525:125:7900;
T = 1/fs;
n_time = 0:T:.01;
for i = 1:length(f0)
    for n = 1:length(n_time)
        x_n(n,i) = sin(2*pi*(f0(i)/fs)*n);
    end
end

figure(3);
subplot(4,1,1)
stem(n_time, x_n(:,1));
title('7525 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,2)
stem(n_time, x_n(:,2));
title('7650 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,3)
stem(n_time, x_n(:,3));
title('7775 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,4)
stem(n_time, x_n(:,4));
title('7900Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
print -depsc sinalias

%%
%

% (d) vary frequencies from 32100 to 32475

clc; clear;

fs = 8000;
f0 = 32100:125:32475;
T = 1/fs;
n_time = 0:T:.01;
for i = 1:length(f0)
    for n = 1:length(n_time)
        x_n(n,i) = sin(2*pi*(f0(i)/fs)*n);
    end
end

figure(4);
subplot(4,1,1)
stem(n_time, x_n(:,1));
title('32100 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,2)
stem(n_time, x_n(:,2));
title('32225 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,3)
stem(n_time, x_n(:,3));
title('32350 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');
subplot(4,1,4)
stem(n_time, x_n(:,4));
title('32475 Hz sine wave sampled at 8KHz');
xlabel('time');
ylabel('amplitude');

%%
% Aliasing a chirp signal (linear frequency modulated)

clc;clear;

fs = 8000;
T = 1/fs;
time = 0:T:.05;
f1 = 4000;
mu = 600000;

% If total time duration of the chirp is 50ms, determine the frequency
% range that is covered by the chirp
% instantaneous frequency found by taking derivative
f_start = mu*0 + 4000;
f_end = mu*.05 + 4000;
f_total = f_end - f_start;

for i = 1:length(time)
    c_n(i) = cos(pi*mu*(time(i)^2) + 2*pi*f1*time(i));
end

figure(5);
plot(time, c_n);
hold on
stem(time, c_n);
title('Chirp signal, f1 = 4Khz mu = 600KHz/s, fs = 8KHz');
xlabel('time');
ylabel('amplitude');
print -depsc chirpalias

%%
% Being lazy and copy pasta lol

clc;clear;

fs = 70000;
T = 1/fs;
time = 0:T:.05;
f1 = 4000;
mu = 600000;

% If total time duration of the chirp is 50ms, determine the frequency
% range that is covered by the chirp
% instantaneous frequency found by taking derivative
f_start = mu*0 + 4000;
f_end = mu*.05 + 4000;
f_total = f_end - f_start;

for i = 1:length(time)
    c_n(i) = cos(pi*mu*(time(i)^2) + 2*pi*f1*time(i));
end

figure(6);
plot(time, c_n);
hold on
stem(time, c_n);
title('Chirp signal, f1 = 4Khz mu = 600KHz/s, fs = 70KHz');
xlabel('time');
ylabel('amplitude');
print -depsc chirp