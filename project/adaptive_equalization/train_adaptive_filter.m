function w_n = train_adaptive_filter(step_size, d_n, x_n, af_length, iters)
[ignore, x_length] = size(x_n);
w_n = zeros(1,af_length);

for i = 0:floor(x_length/af_length)-1
    w_n = least_mean_square(step_size, w_n ... 
                            ,d_n((i*af_length + 1):((i+1)*af_length)) ...
                            ,x_n((i*af_length + 1):((i+1)*af_length)) ...
                            ,iters);
end