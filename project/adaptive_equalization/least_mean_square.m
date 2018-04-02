function w_n = least_mean_square(step_size, w_n, d_n, x_n, M)
[ignore, x_n_length] = size(x_n);

for i = 1:x_n_length-M
    y_n = w_n * fliplr(x_n(i:M-1 + i))';
    e_n = d_n(i) - y_n;
    w_n = w_n + (step_size*e_n).* fliplr(x_n(i:M-1 + i));
end