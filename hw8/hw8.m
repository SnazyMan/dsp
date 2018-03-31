%% Tyler Olivieri
% ESE 531 DSP HW8

clc;clear;close all;

x_time = -pi:.01:pi;
x = sin(x_time);

% time dft 
start = tic;
[w,X] = dft(x);
time = toc(start);

% calculate flops
profile on
[w,X] = dft(x);
profileStruct = profile('info');
[flopTotal,Details] = FLOPS('dft','dftMat',profileStruct);

%%
% fft

clc;clear;close all;

x_time = -pi:.01:pi;
x = sin(x_time);

% time fft
start = tic;
[X] = fft(x,10240);
time = toc(start);

% calculate flops
profile on
X = fft(x,1024);
profileStruct = profile('info');
save fftMat
[flopTotal,Details] = FLOPS('fft','fftMat',profileStruct);

%%
% one loop dft
% compute dft sing one loop over k
% taking inner product over n

clc;clear;close all;

x_time = -pi:.01:pi;
x = sin(x_time);

% time oneloopDFT
[w,r_f, time] = oneLoopDFT(x);

% calculate flops
profile on
[X] = oneLoopDFT(x);
profileStruct = profile('info');
[flopTotal,Details] = FLOPS('oneLoopDFT','oneLoopdftMat',profileStruct);

%%
% No-loop dft

clc;clear;close all;

x_time = -pi:.01:pi;
x = sin(x_time);

% time oneloopDFT
[w,r_f,time] = matmulDFT(x);

% calculate flops
profile on
[X] = matmulDFT(x);
profileStruct = profile('info');
[flopTotal,Details] = FLOPS('matmulDFT','matmuldftMat',profileStruct);
