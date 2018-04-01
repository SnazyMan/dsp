function w_n = least_mean_square(step_size, w_n, d_n, x_n, iters)

for i = 1:iters
    y_n = w_n .* x_n;
    e_n = d_n - y_n;
    w_n = w_n + step_size*(e_n.*x_n);
end