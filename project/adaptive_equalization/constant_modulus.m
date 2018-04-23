function g_n = constant_modulus(step_size, g_n, x_n)

y_n = x_n * g_n';
e_n = abs(y_n)^2 - 1;
g_n = g_n - ((step_size*e_n)*y_n).* x_n;