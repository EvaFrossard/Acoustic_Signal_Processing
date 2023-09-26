clear
close all
clc

% Random signal duration
Nx = ceil(1E3 * rand(1));

% Signal creation
x = randn(Nx,1);

% Window size
N = 8;

M = 16;

fs = 100;

% Step size
R = 4;

% Overlap
O = N - R;

% Compute the number of frames
L = ceil((Nx - O) / R);

% Zero-padd input such that it can be divided into an integer number of
% frames 
x = cat(1,x,zeros(round((O + L * R) - Nx),1));
%%

w = [1 1 1 1 1 1 1 1];
% 2D array
% # of columns =  # of frames (L)
% # of rows = # of samples per frame (M),
X = zeros(M, L);

% Loop over the number of frames
for ii = 0 : L - 1
    
    % Sample indices
    idx = (1:N) + ii * R;
    
    % Time segmentation
    xHat = x(idx);
    
    % Windowing & zero-padding
    X_k = xHat(:) .* w(:);

    X_k = cat(1, X_k, zeros(M-N,1));
    
    % DFT
    X_k = fft(X_k, M);

    % Save in 2D array
    X(:, ii+1) = X_k(:);
    
end

tSec = ((0:L-1)*R+N)/fs;
fHz = (0:N-1)*(N/fs);

plotSTFT(tSec, fHz, 20*log10(abs(X)), fs, true);
