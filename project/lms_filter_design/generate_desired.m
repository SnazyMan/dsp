function x_d  = generate_desired(K, L)
% generate_desired
% input K - length of generated sequence
% input L - vector of frequencies present in output
% ouput x_d - filtered sequence of length K with L frequencies

% generate L sine waves of length K
n = 1:K;
for i = 1:length(L)
    temp(i,:) = sin(2*pi*L(i).*n);
end

% generate desired signal using desired magnitude response
%                       { 2, for .00 <= |f| <= .15
%  |Hd(exp(j*2*pi*f)| = { 0, for .15 <= |f| <= .3
%                       { 1, for .30 <= |f| <= .5
% Using eigenfunction property of LTI system, we can scale each frequency
% individually, sum result
for i = 1:length(L)
    
    if (L(i) <= .15)
        x(i,:) =  temp(i,:) .* 2;
        
    elseif (L(i) > .15 && L(i) <= .3)
        x(i,:) = temp(i,:) .* 0;
        
    else
        x(i,:) = temp(i,:) .* 1;        
    end          
end

% sum all sines to obtain sequence consisting of L frequencies
x_d = sum(x);

end

