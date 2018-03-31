function [w,r_f] = dft(r_n)
%dft evaluate dft of a signal
% 2 loop implementation
    w = linspace(-pi, pi, 10240);    
    for k = 1:length(w)
        for n = 1:length(r_n)
            temp(n) = r_n(n) * exp(-j*w(k)*n);
        end
        r_f(k) = sum(temp);
    end      
    
    save dftMat;
end
