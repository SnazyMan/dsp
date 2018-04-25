function x_in  = generate_input_b(K, L)
% generate_input
% input K - length of generated sequence
% input L - vector of frequencies present in output
% ouput x_d - sequence of length K with L frequencies

% generate L sine waves of length K
n = 1:K;
for i = 1:length(L)
    temp(i,:) = sin(2*pi*L(i).*n);
end

% sum all sines to obtain sequence consisting of L frequencies
x_in = sum(temp);

end

