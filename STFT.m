function [X, t, f] = STFT(x,fs,w,R,M)
%STFT Short-Time Fourier-Transform
%
%USAGE
%   [X,w] = STFT(x)
%   [X,w] = STFT(x,fs,w,R,M)
%
%INPUT ARGUMENTS
%    x : length-Nx discrete-time input signal (Nx x 1 | 1 x Nx)
%   fs : sampling frequency
%    w : length-N analysis window (N x 1 | 1 x N)
%    R : shift between adjacent windows
%    M : DFT size after zero-padding
%
%OUTPUT ARGUMENTS
%   X : complex DFT spectrum [Nx x 1]
%   w : frequency vector in radians/sample [Nx x 1]
%
%   ***********************************************************************

%% CHECK INPUT ARGUMENTS
%
% Check for proper input argumetns
if nargin < 1 || nargin > 5
    help(mfilename);
    error('Wrong number of input arguments!')
end
% Set default values
 
%% COMPUTE STFT
% 
% Length of input signal
Nx = length(x);

% Length of window size
N = length(w);

% O = overlap between adjacent windows (O = N − R)
O = N - R;

% L = number of frames L = [(Nx − O)/R]
L = ceil((Nx - O)/R);

% Zero pad input with O + LR - Nx zeros at the end
x = cat(1, x(:), zeros(round(O + L*R - Nx),1));

% Create 2D array (N x L) (L = # of frames, M = samples in each frame)
X = zeros(M, L);

% λ : frame index, λ ∈ {0, 1, . . . , L − 1}
% k : frequency bin index, k ∈ {0, 1, . . . , M − 1}
% Loop over the number of frames (λ)
for ii = 0 : L - 1 

    % Sample indices with a step of R
    idx = (1:N) + R * ii;
    
    % Time segmentation (get a part of the original signal)
    xHat = x(idx);
    
    % Windowing
    X_k = xHat(:) .* w(:);

    % Zero-padding with M - N zeros (end up being an array of size M) 
    X_k = cat(1, X_k, zeros(M-N,1));
    
    % DFT
    X_k = fft(X_k, M);

    % Save in 2D array
    X(:, ii+1) = X_k(:);   
end

t = (N + (0:L-1)*R)/fs;
f = fs/M * (0:M-1);

% X = X(1:(M/2+1),:);
% t = (((0:L-1)*R)/fs); % time in sec
% f = ((0:M/2)*(fs/M)) ; % frequency in hertz    

% f = ((0:L-1)*R+N)*(fs/M);

% t = ((0:L-1)*R+N)/fs; 
% f = (0:N-1)*(N/fs);
end
