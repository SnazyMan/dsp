%http://ieeexplore.ieee.org/document/1164962/
%Assumes equal dimension input and pr_fb equa order for all filters
clc;
clear all;

pr_fb_order = 9; %pr_fb order
f_p = 0.4; %passband edge
n_levels = 3; %used for threshold

img_man = im2double(imread('man.gif')); %input
[man_row, man_col] = size(img_man); %dimensions
w = 0:pi/(0.5*man_row):2*pi-pi/(0.5*man_row);
n_down = 1:1:man_row*2;
demod_exp_down = exp(j*pi*n_down); %demodulation to baseband
n_up = 1:1:man_row;
demod_exp_up = exp(j*pi*n_up); %modulation to normal band

n_down_oct = 1:1:man_row;
demod_exp_down_oct = exp(j*pi*n_down_oct); %demodulation on subsampled image
n_up_oct = 1:1:man_row/2;
demod_exp_up_oct = exp(j*pi*n_up_oct); %modulation on upsampled image

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
[ignore, M] = size(h0);

%%% Zero Padding for Convolution %%%
h0 = padarray(h0',(man_row - M)/ 2,0,'both')';
h1 = padarray(h1',(man_row - M)/ 2,0,'both')';
g0 = padarray(g0',(man_row - M)/ 2,0,'both')';
g1 = padarray(g1',(man_row - M)/ 2,0,'both')';

h0_oct = h0(man_row/4 : man_row - man_row/4 - 1);
h1_oct = h1(man_row/4 : man_row - man_row/4 - 1);
g0_oct = g0(man_row/4 : man_row - man_row/4 - 1);
g1_oct = g1(man_row/4 : man_row - man_row/4 - 1);

h0 = [h0 0];
h1 = [h1 0];
g0 = [g0 0];
g1 = [g1 0];

h0_oct = [h0_oct 0];
h1_oct = [h1_oct 0];
g0_oct = [g0_oct 0];
g1_oct = [g1_oct 0];

%%%SHORTHAND%%%
T = man_row/2 + 1;
U = man_row;
V = man_row + man_row/2;
W = man_row + man_row/2 - 1;
X = man_row - man_row/2;
%%%

%%%SHORTHAND%%%
T1 = man_row/4 + 1;
U1 = man_row/2;
V1 = man_row/2 + man_row/4;
W1 = man_row/2 + man_row/4 ;
X1 = man_row/2 - man_row/4 + 1;
%%%

%Apply the first filter to decompose the signal and demodulate to BB
x_ll_temp = 0.25*conv2(h0,h0,img_man);
x_hh_temp = (demod_exp_down).*((demod_exp_down).*conv2(h1,h1,img_man))';
x_lh_temp = (demod_exp_down).*conv2(h1,h0,img_man)';
x_hl_temp = (demod_exp_down).*conv2(h0,h1,img_man);

%Downsample the signal
x_ll_n = imresize(x_ll_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hh_n = imresize(x_hh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_lh_n = imresize(x_lh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hl_n = imresize(x_hl_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);

%Determine a 3 Level Threshold
thresh_hh = multithresh(abs(x_hh_n),n_levels-1);
thresh_lh = multithresh(abs(x_lh_n),n_levels-1);
thresh_hl = multithresh(abs(x_hl_n),n_levels-1);

%Apply a 3 Level Threshold
x_hh_n = (imquantize(abs(x_hh_n), thresh_hh)-1)/((n_levels-1)*4);
x_lh_n = (imquantize(abs(x_lh_n), thresh_lh)-1)/((n_levels-1)*4);
x_hl_n = (imquantize(abs(x_hl_n), thresh_hl)-1)/((n_levels-1)*4);

%Apply the first filter to decompose the signal and demodulate to BB
x_ll_ll_temp = 0.25*conv2(h0_oct,h0_oct,x_ll_n);
x_ll_hh_temp = (demod_exp_down_oct).*((demod_exp_down_oct).*conv2(h1_oct,h1_oct,x_ll_n))';
x_ll_lh_temp = (demod_exp_down_oct).*conv2(h1_oct,h0_oct,x_ll_n)';
x_ll_hl_temp = (demod_exp_down_oct).*conv2(h0_oct,h1_oct,x_ll_n);

%Downsample the signal
x_ll_ll_n = imresize(x_ll_ll_temp(T1-M/4:V1-M/4, T1-M/4:V1-M/4), 0.5);
x_ll_hh_n = imresize(x_ll_hh_temp(T1-M/4:V1-M/4, T1-M/4:V1-M/4), 0.5);
x_ll_lh_n = imresize(x_ll_lh_temp(T1-M/4:V1-M/4, T1-M/4:V1-M/4), 0.5);
x_ll_hl_n = imresize(x_ll_hl_temp(T1-M/4:V1-M/4, T1-M/4:V1-M/4), 0.5);

%Determine a 3 Level Threshold
thresh_ll_hh = multithresh(abs(x_ll_hh_n),n_levels-1);
thresh_ll_lh = multithresh(abs(x_ll_lh_n),n_levels-1);
thresh_ll_hl = multithresh(abs(x_ll_hl_n),n_levels-1);

%Apply a 3 Level Threshold
x_ll_hh_n = (imquantize(abs(x_ll_hh_n), thresh_ll_hh)-1)/((n_levels-1)*8);
x_ll_lh_n = (imquantize(abs(x_ll_lh_n), thresh_ll_lh)-1)/((n_levels-1)*8);
x_ll_hl_n = (imquantize(abs(x_ll_hl_n), thresh_ll_hl)-1)/((n_levels-1)*8);

%Upsample the image and modulate to normal band
y_ll_ll_temp = conv2(g0_oct,g0_oct,imresize(x_ll_ll_n,2));
y_ll_hh_temp = conv2(g1_oct,g1_oct,demod_exp_up_oct.*(demod_exp_up_oct.*imresize(x_ll_hh_n,2))');
y_ll_lh_temp = conv2(g1_oct,g0_oct,demod_exp_up_oct'.*imresize(x_ll_lh_n,2));
y_ll_hl_temp = conv2(g0_oct,g1_oct,demod_exp_up_oct.*imresize(x_ll_hl_n,2));

%Region of image that does not contain zero-padding
y_ll_ll_n = y_ll_ll_temp(X1+M/4:W1+M/4, X1+M/4:W1+M/4);
y_ll_hh_n = y_ll_hh_temp(X1+M/4:W1+M/4, X1+M/4:W1+M/4);
y_ll_lh_n = y_ll_lh_temp(X1+M/4:W1+M/4, X1+M/4:W1+M/4);
y_ll_hl_n = y_ll_hl_temp(X1+M/4:W1+M/4, X1+M/4:W1+M/4);

%Reconstruct LL Band
x_ll_n = y_ll_ll_n + y_ll_hh_n + y_ll_hl_n + y_ll_lh_n;

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
x_ll_ll_ejw = fft2(x_ll_ll_n);
x_ll_hh_ejw = fft2(x_ll_hh_n);
x_ll_lh_ejw = fft2(x_ll_lh_n);
x_ll_hl_ejw = fft2(x_ll_hl_n);

y_ll_ll_ejw = fft2(y_ll_ll_n);
y_ll_hh_ejw = fft2(y_ll_hh_n);
y_ll_lh_ejw = fft2(y_ll_lh_n);
y_ll_hl_ejw = fft2(y_ll_hl_n);

x_ejw = fft2(img_man);
x_recon_ejw = fft2(x_recon);
x_ll_ejw = fft2(x_ll_n);

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_ll_ejw))));
colormap(gray);
title({'SubBand LL-LL After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_hh_ejw))));
colormap(gray);
title({'SubBand LL-HH After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_lh_ejw))));
colormap(gray);
title({'SubBand LL-LH After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_hl_ejw))));
colormap(gray);
title({'SubBand LL-HL After', 'Upsampling & Modulation'});
xlabel('Normalized Frequency w_{col}');
ylabel('Normalized Frequency w_{row}');

print -depsc pr_fb_oct_two_bit_4L_upsampling_modulation

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
print -depsc pr_fb_oct_two_bit_4L_comparison

err_two_bit = immse(img_man,x_recon);
