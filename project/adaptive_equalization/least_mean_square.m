function w_n = least_mean_square(step_size, w_n, d_n, x_n, M)
[ignore, x_n_length] = size(x_n);
x_n = [zeros(1,floor((M-1)/2)) x_n zeros(1,ceil((M-1)/2))]; %zero pad input for convolution

for i = 1:x_n_length
    y_n = w_n * fliplr(x_n(i:M-1 + i))'; %convolve filter with input signal
    e_n = d_n(i) - y_n; %measure point error
    w_n = w_n + (step_size*e_n).* fliplr(x_n(i:M-1 + i)); %update filter coefficients to minimize err
end