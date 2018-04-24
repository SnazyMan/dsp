function g_n = constant_modulus(step_size, g_n, x_n)

y_n = x_n * g_n'; %convolve input sequence with filter
e_n = abs(y_n)^2 - 1; %determine error with constant modulus
g_n = g_n - ((step_size*e_n)*y_n).* x_n; %update filter coefficients