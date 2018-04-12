%http://ieeexplore.ieee.org/document/1164962/
%Assumes equal dimension input and pr_fb equa order for all filters
clc;
clear all;

pr_fb_order = 9;

f_p = 0.4;

img_man = im2double(imread('man.gif'));
[man_row, man_col] = size(img_man);
w = 0:pi/(0.5*man_row):2*pi-pi/(0.5*man_row);
n_down = 1:1:man_row*2;
demod_exp_down = exp(j*pi*n_down);
n_up = 1:1:man_row;
demod_exp_up = exp(j*pi*n_up);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
[ignore, M] = size(h0);
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

x_ll_temp = 0.25*conv2(h0,h0,img_man);
x_hh_temp = 0.25*(demod_exp_down).*((demod_exp_down).*conv2(h1,h1,img_man))';
x_lh_temp = 0.25*(demod_exp_down).*conv2(h1,h0,img_man)';
x_hl_temp = 0.25*(demod_exp_down).*conv2(h0,h1,img_man);

x_ll_n = imresize(x_ll_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hh_n = imresize(x_hh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_lh_n = imresize(x_lh_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);
x_hl_n = imresize(x_hl_temp(T-M/2:V-M/2, T-M/2:V-M/2), 0.5);

norm_ll_n = 0.25*conv2(h0,h0,img_man,'same');
norm_hh_n = 0.25*conv2(h1,h1,img_man,'same');
norm_lh_n = 0.25*conv2(h1,h0,img_man, 'same');
norm_hl_n = 0.25*conv2(h0,h1,img_man, 'same');

y_ll_temp = conv2(g0,g0,imresize(x_ll_n,2));
y_hh_temp = conv2(g1,g1,demod_exp_up.*(demod_exp_up.*imresize(x_hh_n,2))');
y_lh_temp = conv2(g1,g0,demod_exp_up'.*imresize(x_lh_n,2));
y_hl_temp = conv2(g0,g1,demod_exp_up.*imresize(x_hl_n,2));

y_ll_n = y_ll_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_hh_n = y_hh_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_lh_n = y_lh_temp(X+M/2:W+M/2, X+M/2:W+M/2);
y_hl_n = y_hl_temp(X+M/2:W+M/2, X+M/2:W+M/2);

x_recon = y_ll_n + y_hh_n + y_lh_n + y_hl_n;

x_ejw = fft2(img_man);
x_ll_ejw = fft2(x_ll_n);
x_hh_ejw = fft2(x_hh_n);
x_lh_ejw = fft2(x_lh_n);
x_hl_ejw = fft2(x_hl_n);

norm_ll_ejw = fft2(norm_ll_n);
norm_hh_ejw = fft2(norm_hh_n);
norm_lh_ejw = fft2(norm_lh_n);
norm_hl_ejw = fft2(norm_hl_n);

y_ll_ejw = fft2(y_ll_n);
y_hh_ejw = fft2(y_hh_n);
y_lh_ejw = fft2(y_lh_n);
y_hl_ejw = fft2(y_hl_n);

x_recon_ejw = fft2(x_recon);

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_ll_ejw))));
colormap(gray);

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_hh_ejw))));
colormap(gray);

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_lh_ejw))));
colormap(gray);

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(y_hl_ejw))));
colormap(gray);

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(norm_ll_ejw))));
colormap(gray);

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(norm_hh_ejw))));
colormap(gray);

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(norm_lh_ejw))));
colormap(gray);

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(norm_hl_ejw))));
colormap(gray);

figure;
subplot(2,2,1);
imshow(4.*abs(x_ll_n));
subplot(2,2,2);
imshow(4.*abs(x_hh_n));
subplot(2,2,3);
imshow(4.*abs(x_lh_n));
subplot(2,2,4);
imshow(4.*abs(x_hl_n));

figure;
subplot(2,2,1);
imshow(img_man);
subplot(2,2,2);
imshow(abs(x_recon));
subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ejw))));
colormap(gray);
subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_recon_ejw))));
colormap(gray);

err = immse(img_man,x_recon);
