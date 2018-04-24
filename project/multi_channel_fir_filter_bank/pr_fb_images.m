%http://ieeexplore.ieee.org/document/1164962/

clc;
clear all;

pr_fb_order = 9; %pr_fb order
f_p = 0.4; %passband edge

img_man = im2double(imread('man.gif')); %input
[man_row, man_col] = size(img_man); %dimensions
w = 0:pi/(0.5*man_row):2*pi-pi/(0.5*man_row);
n_down = 1:1:man_row*2;
demod_exp_down = exp(j*pi*n_down); %demodulation to baseband
n_up = 1:1:man_row;
demod_exp_up = exp(j*pi*n_up); %modulation to normal band


[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
[ignore, M] = size(h0);

%%% Zero Padding for Convolution %%%
h0 = padarray(h0',(man_row - M)/ 2,0,'both')';
h1 = padarray(h1',(man_row - M)/ 2,0,'both')';
g0 = padarray(g0',(man_row - M)/ 2,0,'both')';
g1 = padarray(g1',(man_row - M)/ 2,0,'both')';
h0 = [h0 0];
h1 = [h1 0];
g0 = [g0 0];
g1 = [g1 0];

%%%SHORTHAND%%%
T = man_row/2 + 1;
U = man_row;
V = man_row + man_row/2;
W = man_row + man_row/2 - 1;
X = man_row - man_row/2;
%%%

%Apply the first filter to decompose the signal
x_ll_norm = 0.25*conv2(h0,h0,img_man);
x_hh_norm = 0.25*conv2(h1,h1,img_man);
x_lh_norm = 0.25*conv2(h1,h0,img_man);
x_hl_norm = 0.25*conv2(h0,h1,img_man);

%Demodulation the signal to baseband
x_ll_temp = x_ll_norm;
x_hh_temp = (demod_exp_down).*((demod_exp_down).*x_hh_norm)';
x_lh_temp = (demod_exp_down).*x_lh_norm';
x_hl_temp = (demod_exp_down).*x_hl_norm;

%Downsample the signal
x_ll_n = imresize(x_ll_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hh_n = imresize(x_hh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_lh_n = imresize(x_lh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hl_n = imresize(x_hl_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);

%Upsample the image and modulate to normal band
y_ll_temp = conv2(g0,g0,imresize(x_ll_n,2));
y_hh_temp = conv2(g1,g1,demod_exp_up.*(demod_exp_up.*imresize(x_hh_n,2))');
y_lh_temp = conv2(g1,g0,demod_exp_up'.*imresize(x_lh_n,2));
y_hl_temp = conv2(g0,g1,demod_exp_up.*imresize(x_hl_n,2));

%Region of image that does not contain zero-padding
y_ll_n = y_ll_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_hh_n = y_hh_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_lh_n = y_lh_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_hl_n = y_hl_temp(X+M/2:W+M/2, X+M/2:W+M/2);

x_recon = y_ll_n + y_hh_n + y_lh_n + y_hl_n;

%%% Frequency Analysis and Graphing %%%
x_ejw = fft2(img_man);
x_ll_ejw = fft2(x_ll_n);
x_hh_ejw = fft2(x_hh_n);
x_lh_ejw = fft2(x_lh_n);
x_hl_ejw = fft2(x_hl_n);

x_ll_ejw_norm = fft2(x_ll_norm);
x_hh_ejw_norm = fft2(x_hh_norm);
x_lh_ejw_norm = fft2(x_lh_norm);
x_hl_ejw_norm = fft2(x_hl_norm);

y_ll_ejw = fft2(y_ll_n);
y_hh_ejw = fft2(y_hh_n);
y_lh_ejw = fft2(y_lh_n);
y_hl_ejw = fft2(y_hl_n);

x_recon_ejw = fft2(x_recon);

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_ejw))));
colormap(gray);
title({'SubBand LL After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_hh_ejw))));
colormap(gray);
title({'SubBand HH After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_lh_ejw))));
colormap(gray);
title({'SubBand LH After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_hl_ejw))));
colormap(gray);
title({'SubBand HL After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

print -depsc pr_fb_upsampling_modulation

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ll_ejw))));
title({'SubBand LL After', 'Downsampling & Demodulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
colormap(gray);

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hh_ejw))));
colormap(gray);
title({'SubBand HH After', 'Downsampling & Demodulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_lh_ejw))));
colormap(gray);
title({'SubBand LH After', 'Downsampling & Demodulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hl_ejw))));
colormap(gray);
title({'SubBand HL After', 'Downsampling & Demodulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
print -depsc pr_fb_downsampling_demodulation

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ll_ejw_norm))));
title({'SubBand LL After', 'Decomposition'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
colormap(gray);

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hh_ejw_norm))));
colormap(gray);
title({'SubBand HH After', 'Decomposition'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_lh_ejw_norm))));
colormap(gray);
title({'SubBand LH After', 'Decomposition'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hl_ejw_norm))));
colormap(gray);
title({'SubBand HL After', 'Decomposition'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
print -depsc pr_fb_decomposition

figure;
subplot(2,2,1);
imshow(4.*abs(x_ll_n));
title({'Spatial Domain', 'Representation of LL'});
subplot(2,2,2);
imshow(4.*abs(x_hh_n));
title({'Spatial Domain', 'Representation of HH'});
subplot(2,2,3);
imshow(4.*abs(x_lh_n));
title({'Spatial Domain', 'Representation of LH'});
subplot(2,2,4);
imshow(4.*abs(x_hl_n));
title({'Spatial Domain', 'Representation of HL'});
print -depsc pr_fb_image_decomposition

figure;
subplot(2,2,1);
imshow(img_man);
title('Original Image');
subplot(2,2,2);
imshow(abs(x_recon));
title('Reconstructed Image');
subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ejw))));
title({'Original Image', 'Frequency Components'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
colormap(gray);
subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_recon_ejw))));
colormap(gray);
title({'Reconstructed Image', 'Frequency Components'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');
print -depsc pr_fb_image_comparison

err = immse(img_man,x_recon);
