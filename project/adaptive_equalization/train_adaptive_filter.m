function w_n = train_adaptive_filter(step_size, d_n, x_n, af_length, iters)

w_n = zeros(1,af_length); % initialize your adaptive filter

%iterate over the training sequence for more training
%we did not utilize this for our project
for i = 1:iters
    w_n = least_mean_square(step_size, w_n, d_n, x_n, af_length); %run lms on sequence
end