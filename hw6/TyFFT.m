%% function
%x----input function
% Fs----Fs
function FTM = TyFFT(x,Fs)

    samL = length(x);
    
    df = Fs/samL;
    NFFT = 2^nextpow2(samL);
    f = (-Fs/2) : df : (Fs/2)-df;
    
    % Take the fourier transform. The fftshift will duplicate our FT for
    % negative frequencies. (Plot is centered at zero)
    FT = fft(x)/samL;
    FTM = abs(FT);
    
    plot(f,fftshift(FTM, 2));
    xlabel('frequency')
    ylabel('Magnitude');
    title('FFT');
    ylim([0 1])