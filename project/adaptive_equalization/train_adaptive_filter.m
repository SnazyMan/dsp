function w_n = train_adaptive_filter(step_size, d_n, x_n, af_length, iters)

w_n = zeros(1,af_length);

for i = 1:iters
    w_n = least_mean_square(step_size, w_n, d_n, x_n, af_length);
end