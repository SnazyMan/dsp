function [x_w] = psinc(w, L)
%psinc - evaluate periodic sinc function on a frequency grid
%   using the formula psinc(w, L) = sin(1/2 * w * L) / sin((1/2) * w)

    for n = 1:length(w)
        if w(n) == 0
            % check if 0 (will blow up funcion)
            w(n) = inf;
        elseif mod(w(n), 2*pi) == 0
            % check if multiple of 2*pi (will blow up function)
            w(n) = inf;
        else
            % evaluate
            x_w(n) = sin((1/2)*w(n)*L) / sin((1/2)*w(n));
        end 
    end
end

