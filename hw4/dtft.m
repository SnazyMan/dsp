function [w, r_f] = dtft(r_n)
    % evaluate "dtft" of a signal
    w = linspace(-pi, pi, 2048);
    for q = 1:length(w)
        for n = 1:length(r_n)
            temp(n) = r_n(n) * exp(-j*w(q)*n);
        end
        r_f(q) = sum(temp);
    end      
end