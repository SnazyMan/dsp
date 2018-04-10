%http://ieeexplore.ieee.org/document/1164962/
%Assumes equal dimension input and pr_fb equa order for all filters
pr_fb_order = 21;

f_p = 0.4;

img_man = im2double(imread('man.gif'));
[man_row, man_col] = size(img_man);
w = 0:pi/(0.5*man_row):2*pi-pi/(0.5*man_row);
n = 1:1:man_row;
demod_exp = exp(j*pi*n);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
[ignore, M] = size(h0);
h0 = padarray(h0',(man_row - M)/ 2,0,'both')';
h1 = padarray(h1',(man_row - M)/ 2,0,'both')';
g0 = padarray(g0',(man_row - M)/ 2,0,'both')';
g1 = padarray(g1',(man_row - M)/ 2,0,'both')';

%Very close solution. Reduce error more by getting a better convolution.
x_ll_n = imresize(0.25*conv2(h0,h0,img_man,'same'),0.5);
x_hh_n = imresize(0.25*(demod_exp).*((demod_exp).*conv2(h1,h1,img_man,'same'))',0.5);
x_lh_n = imresize(0.25*(demod_exp).*conv2(h1,h0,img_man, 'same')',0.5);
x_hl_n = imresize(0.25*(demod_exp).*conv2(h0,h1,img_man, 'same'),0.5);

norm_ll_n = 0.25*conv2(h0,h0,img_man,'same');
norm_hh_n = 0.25*conv2(h1,h1,img_man,'same');
norm_lh_n = 0.25*conv2(h1,h0,img_man, 'same');
norm_hl_n = 0.25*conv2(h0,h1,img_man, 'same');

y_ll_n = conv2(g0,g0,imresize(x_ll_n,2),'same');
y_hh_n = conv2(g1,g1,demod_exp.*(demod_exp.*imresize(x_hh_n,2))','same');
y_lh_n = conv2(g1,g0,demod_exp'.*imresize(x_lh_n,2), 'same');
y_hl_n = conv2(g0,g1,demod_exp.*imresize(x_hl_n,2), 'same');
x_recon = y_ll_n + y_hh_n + y_lh_n + y_hl_n;
%x_recon = conv2(g0,g0,x_ll_n,'same') + conv2(g1,g1,x_hh_n,'same') + conv2(g1,g0,x_lh_n, 'same') ...
%   + conv2(g0,g1,x_hl_n, 'same');

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
