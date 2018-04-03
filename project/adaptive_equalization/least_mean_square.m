function w_n = least_mean_square(step_size, w_n, d_n, x_n, M)
[ignore, x_n_length] = size(x_n);
x_n = [zeros(1,floor((M-1)/2)) x_n zeros(1,ceil((M-1)/2))];

for i = 1:x_n_length
    y_n = w_n * fliplr(x_n(i:M-1 + i))';
    e_n = d_n(i) - y_n;
    w_n = w_n + (step_size*e_n).* fliplr(x_n(i:M-1 + i));
end