function [w, r_f,time ] = matmulDFT( r_n )
% one loop dft
    % frequency vector
    w = linspace(-pi, pi, 10240); 

    % precalculate exp matrix
    for k = 1:length(w)
        for n = 1:length(r_n)
            dftmatrix(n,k) = exp(-j*w(k)*n);
        end
    end
    
    start = tic;
    r_f = r_n * dftmatrix;
    time = toc(start);
    
    save matmuldftMat;
end

