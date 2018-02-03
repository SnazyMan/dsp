% ESE 531 DSP HW2 
%
% Tyler Olivieri

clc; clear;

% Create finite length (L) unit pulse (r)
figidx = 0;
L = [12 15];
for i = 1:length(L)
    n = 0:1:L(i);
    for p = 1:L(i)
        r_n(p) = 1;
    end
    
    % Take the 'dtft'
    [w, r_f] = dtft(r_n);
    
    fig = figure;
    subplot(2,1,1)
    plot(w, real(r_f));
    str = sprintf('L = %d, Real portion of DFTF', L(i)); 
    title(str);
    xlabel('Frequency (w)');
    ylabel('DTFT of signal');    
    subplot(2,1,2)
    plot(w, imag(r_f));
    str = sprintf('L = %d, Imaginary portion of DFTF', L(i)); 
    title(str);
    xlabel('Frequency (w)');
    ylabel('DTFT of signal'); 
    figstr = sprintf('fig%d', figidx);
    print(fig, figstr, '-deps');
    figidx = figidx + 1;
    
    fig = figure;
    subplot(2,1,1)
    plot(w, abs(r_f));
    str = sprintf("L = %d, Magnitude of DFTF", L(i)); 
    title(str);
    xlabel('Frequency (w)');
    ylabel('magnitude of dtft'); 
    subplot(2,1,2)
    plot(w, angle(r_f))
    title('Phase');
    xlabel('Frequency (w)');
    ylabel('magnitude of dtft'); 
    figstr = sprintf('fig%d', figidx);
    print(fig, figstr, '-deps');
    figidx = figidx + 1;
    
end


%%
% Question 2

clc; clear;

% evaluate dtft of finte pulse
L = 12;
w = linspace(-pi, pi, 2048);
x_w = psinc(w, L);

figure;
plot(w, abs(x_w));
str = sprintf("psinc((w, L=%d)", L);
title(str);
xlabel('w');
ylabel('magnitude of w');
print -deps fig10


%%
% Question 3

clc; clear;

% signal x[n] = (.9)^n * u[n] (so n is causual)
% X(z) = 1 / (1 - .9*z^-1)
b = [1];
a = [1 -.9];

numPoints = 2048;
[h, w] = freqz(b, a, 'whole', numPoints);
hMag = abs(h);
hPhase = angle(h);

%shift to -pi to pi
hMag = circshift(hMag, numPoints/2);
hPhase = circshift(hPhase, numPoints/2);
w = w - pi;

% Hand derived magnitude
theta = linspace(-pi, pi, numPoints);
H_zmag = 1 ./ sqrt(1.81 - 1.8.*cos(theta));

%hand derived phase
H_zphase = atan(-.9.*sin(theta) ./ (1 - .9.*cos(theta)));

figure;
subplot(2,1,1)
plot(w, hMag)
title('Magnitude of X(z) = 1 / (1 - .9*z^-1)');
xlabel('frequency (radians)')
ylabel('Magnitude');
subplot(2,1,2)
plot(w, hPhase)
title('Phase of X(z) = 1 / (1 - .9*z^-1)');
xlabel('frequency (radians)')
ylabel('phase');
print -deps fig20

figure;
subplot(2,1,1)
plot(w, H_zmag)
title('Hand derived Magnitude of X(z) = 1 / (1 - .9*z^-1)');
xlabel('frequency (radians)')
ylabel('Magnitude');
subplot(2,1,2)
plot(w, H_zphase)
title('Hand derived Phase of X(z) = 1 / (1 - .9*z^-1)');
xlabel('frequency (radians)')
ylabel('phase');
print -deps fig30


% We know magnitude and frequency response is even and odd respectively 
% if signal is real
% We can see the magnitude of frequency response is even 
% because it is symmetric across the y axis
%
% Similarly it is odd because the phase has both x and y axis symmetry
%
% Will check if I need to show a proof of this 
%
% Because signal is real, it will have even frequency response and odd
% phase
% from table ** in book chpt 3


