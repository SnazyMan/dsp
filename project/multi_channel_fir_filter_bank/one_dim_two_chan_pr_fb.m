%%% FILTER ORDER 7 %%%
pr_fb_order = 7;
n = 0:1:1024;
f_low = 0.2*pi;
f_high = 0.7*pi;
f_p = 0.4;
x_n = cos(f_low.*n) + cos(f_high.*n);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
figure;
hold on
grid on
x_h0_n = 0.5*conv(x_n,h0);
x_h1_n = 0.5*conv(x_n,h1);
x_h0_recon = conv(x_h0_n,g0);
x_h1_recon = conv(x_h1_n,g1);
x_recon = x_h0_recon + x_h1_recon;
[x_ejw, w] = freqz(x_n);
plot(w/pi,mag2db(abs(x_ejw)), '*');
[x_ejw_low, w] = freqz(x_h0_n);
plot(w/pi,mag2db(abs(x_ejw_low)));
[x_ejw_high, w] = freqz(x_h1_n);
plot(w/pi,mag2db(abs(x_ejw_high)));
[x_ejw_reconstructed, w] = freqz(x_recon);
plot(w/pi,mag2db(abs(x_ejw_reconstructed)), '.');

xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
legend('x(e^{jw})', 'x(e^{jw})_{lp}', 'x(e^{jw})_{hp}', 'x(e^{jw})_{re}');
title('Two Channel PR Filter Bank: Filter Order = 7');


%%% FILTER ORDER 11 %%%
pr_fb_order = 11;
n = 0:1:1024;
f_low = 0.2*pi;
f_high = 0.7*pi;
f_p = 0.4;
x_n = cos(f_low.*n) + cos(f_high.*n);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
figure;
hold on
grid on
x_h0_n = 0.5*conv(x_n,h0);
x_h1_n = 0.5*conv(x_n,h1);
x_h0_recon = conv(x_h0_n,g0);
x_h1_recon = conv(x_h1_n,g1);
x_recon = x_h0_recon + x_h1_recon;
[x_ejw, w] = freqz(x_n);
plot(w/pi,mag2db(abs(x_ejw)), '*');
[x_ejw_low, w] = freqz(x_h0_n);
plot(w/pi,mag2db(abs(x_ejw_low)));
[x_ejw_high, w] = freqz(x_h1_n);
plot(w/pi,mag2db(abs(x_ejw_high)));
[x_ejw_reconstructed, w] = freqz(x_recon);
plot(w/pi,mag2db(abs(x_ejw_reconstructed)), '.');

xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
legend('x(e^{jw})', 'x(e^{jw})_{lp}', 'x(e^{jw})_{hp}', 'x(e^{jw})_{re}');
title('Two Channel PR Filter Bank: Filter Order = 9');

%%% FILTER ORDER 19 %%%
pr_fb_order = 19;
n = 0:1:1024;
f_low = 0.2*pi;
f_high = 0.7*pi;
f_p = 0.4;
x_n = cos(f_low.*n) + cos(f_high.*n);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
figure;
hold on
grid on
x_h0_n = 0.5*conv(x_n,h0);
x_h1_n = 0.5*conv(x_n,h1);
x_h0_recon = conv(x_h0_n,g0);
x_h1_recon = conv(x_h1_n,g1);
x_recon = x_h0_recon + x_h1_recon;
[x_ejw, w] = freqz(x_n);
plot(w/pi,mag2db(abs(x_ejw)), '*');
[x_ejw_low, w] = freqz(x_h0_n);
plot(w/pi,mag2db(abs(x_ejw_low)));
[x_ejw_high, w] = freqz(x_h1_n);
plot(w/pi,mag2db(abs(x_ejw_high)));
[x_ejw_reconstructed, w] = freqz(x_recon);
plot(w/pi,mag2db(abs(x_ejw_reconstructed)), '.');

xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
legend('x(e^{jw})', 'x(e^{jw})_{lp}', 'x(e^{jw})_{hp}', 'x(e^{jw})_{re}');
title('Two Channel PR Filter Bank: Filter Order = 19');

%%% FILTER ORDER 19 %%%
pr_fb_order = 21;
n = 0:1:1024;
f_low = 0.2*pi;
f_high = 0.7*pi;
f_p = 0.4;
x_n = cos(f_low.*n) + cos(f_high.*n);

[h0,h1,g0,g1] = firpr2chfb(pr_fb_order, f_p);
figure;
hold on
grid on
x_h0_n = 0.5*conv(x_n,h0);
x_h1_n = 0.5*conv(x_n,h1);
x_h0_recon = conv(x_h0_n,g0);
x_h1_recon = conv(x_h1_n,g1);
x_recon = x_h0_recon + x_h1_recon;
[x_ejw, w] = freqz(x_n);
plot(w/pi,mag2db(abs(x_ejw)), '*');
[x_ejw_low, w] = freqz(x_h0_n);
plot(w/pi,mag2db(abs(x_ejw_low)));
[x_ejw_high, w] = freqz(x_h1_n);
plot(w/pi,mag2db(abs(x_ejw_high)));
[x_ejw_reconstructed, w] = freqz(x_recon);
plot(w/pi,mag2db(abs(x_ejw_reconstructed)), '.');

xlabel('Normalized Frequency');
ylabel('Magnitude_{dB}');
legend('x(e^{jw})', 'x(e^{jw})_{lp}', 'x(e^{jw})_{hp}', 'x(e^{jw})_{re}');
title('Two Channel PR Filter Bank: Filter Order = 21');