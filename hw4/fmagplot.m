function fmagplot(xa, dt)
%fmagplot (xa,dt)
%  xa - the "analog' ct signal"
%  dt - the sampling interval for the simulation of 
%      the CT signal , xa(t)

    L = length(xa);
    Nfft = round (2 .^ round(log2(5*L)));
    Xa = fft(xa, Nfft);
    range = 0:(Nfft/4);
    ff = range/Nfft/dt;
    figure;
    plot(ff/1000, abs(Xa(1:length(range))));
    title('ctft magnitude');
    xlabel('frequency (khz)'), grid
    print -depsc fourierCont

end

