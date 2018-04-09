%http://ieeexplore.ieee.org/document/1164962/
pr_fb_order = 21;

f_p = 0.4;

img_man = im2double(imread('man.gif'));
[man_row, man_col] = size(img_man);
w = -pi:pi/(0.5*man_row):pi-pi/(0.5*man_row);
demod_exp = exp(-j*(1-f_p)*pi*w);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);

%DEMODULATION WORK IN PROGRESS
%x_ll_n = imresize(0.25*conv2(h0,h0,img_man,'same'),0.5);
%x_hh_n = imresize(0.25*demod_exp.*conv2(h1,h1,img_man,'same'),0.5);
%temp_x_lh_n = 0.25*conv2(h1,h0,img_man, 'same');
%x_hl_n = imresize(0.25*conv2(1,demod_exp,conv2(h0,h1,img_man, 'same'),'same'),0.5);

x_ll_n = 0.25*conv2(h0,h0,img_man,'same');
x_hh_n = 0.25*conv2(h1,h1,img_man,'same');
x_lh_n = 0.25*conv2(h1,h0,img_man, 'same');
x_hl_n = 0.25*conv2(h0,h1,img_man, 'same');

%x_recon = conv2(g0,g0,imresize(x_ll_n,2),'same') + conv2(g1,g1,imresize(x_hh_n,2),'same') ...
%    + conv2(g1,g0,imresize(x_lh_n,2), 'same') + conv2(g0,g1,imresize(x_hl_n,2), 'same');
x_recon = conv2(g0,g0,x_ll_n,'same') + conv2(g1,g1,x_hh_n,'same') + conv2(g1,g0,x_lh_n, 'same') ...
    + conv2(g0,g1,x_hl_n, 'same');

x_ejw = fft2(img_man);
x_ll_ejw = fft2(x_ll_n);
x_hh_ejw = fft2(x_hh_n);
x_lh_ejw = fft2(x_lh_n);
x_hl_ejw = fft2(x_hl_n);
x_recon_ejw = fft2(x_recon);

figure;
subplot(2,2,1);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ll_ejw))));
colormap(gray);

subplot(2,2,2);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hh_ejw))));
colormap(gray);

subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_lh_ejw))));
colormap(gray);

subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_hl_ejw))));
colormap(gray);

figure;
subplot(2,2,1);
imshow(4.*x_ll_n);
subplot(2,2,2);
imshow(4.*x_hh_n);
subplot(2,2,3);
imshow(4.*x_lh_n);
subplot(2,2,4);
imshow(4.*x_hl_n);

figure;
subplot(2,2,1);
imshow(img_man);
subplot(2,2,2);
imshow(x_recon);
subplot(2,2,3);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_ejw))));
colormap(gray);
subplot(2,2,4);
imagesc([-1,1],[-1,1],100*log(1+ abs(fftshift(x_recon_ejw))));
colormap(gray);

err = immse(img_man,x_recon);
