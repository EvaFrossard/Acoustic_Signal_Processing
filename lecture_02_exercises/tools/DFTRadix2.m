function [X,w] = DFTRadix2(x, bLoop)
%DFTRADIX2 One iteration of the Radix-2 decimation in time algorithm.
%
%USAGE
%   [X,w] = dftRadix2(x)
%   [X,w] = dftRadix2(x,bLoop)
%
%INPUT ARGUMENTS
%       x : length-N input signal (N x 1 | 1 x N) 
%           (x must be a vector and N must be a power of two)
%   bLoop : binary flag (default, bLoop = false)
%           if true  => DFT is computed using two for-loops
%           if false => DFT is computed using complex matrix multiplication
%
%OUTPUT ARGUMENTS
%   X : complex DFT spectrum [N x 1]
%   w : frequency vector in radians/sample [N x 1]
%
%   dftRadix2(...) plots the DFT in a new figure.
%
%   ***********************************************************************

%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 1 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 2 || isempty(bLoop); bLoop = false; end

% Check if input is a vector
if any(size(x) == 0)
    error('Input signal x is an empty array.')
elseif min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Number of samples
    N = length(x);
end

% Check if N is a power of 2 ...
if rem(log2(N),1) ~= 0
    error('The length of the input signal must be a power of two.')
end

%% RADIX-2: DECIMATION IN TIME
% 
% Split x into its even and odd-numbered components (Eq. 16)
x_e = x(2:2:N); % par
x_o = x(1:2:N); % impar

if bLoop
    % ===============================
    % Compute DFT using two for-loops
    % ===============================
    %
    % (Column) Array for complex signal spectrum
    X = zeros(N,1);
    
    % Loop over the number of frequencies
    for k = 0 : (N/2) - 1

        % Reset even and odd spectral elements
        X_e = 0; % par
        X_o = 0; % impar

        % Loop over the number of samples      
        for m = 0 : (N/2) - 1

            % Exponential basis function for N/2-point DFT
            wNHalf = exp(-1j * 2 * pi / (N / 2) * k * m);
            
            % DFT sum
            X_e = X_e + x_e(m+1) * wNHalf;
            X_o = x_o + x_o(m+1) * wNHalf;
    
    
        end

        % Exponential basis functions for N-point DFT
        wN = exp(-1j * 2 * pi / N * k);

        % Apply wN to Xo according to the butterfly simplification
        X_o = X_o * wN;
        
        % Combine both N/2-point DFT
        X(k+1) = X_e + X_o;

        % Take advantage of the periodic property knowing that:
        % 1) X_e[k + N/2] = X_e[k] and X_o[k + N/2] = X_o[k]
        % 2) wN[k + N/2] = -W[k] (applies for the complete signal)
        % 3) X[k] = X_e + X_o * wN
        % 4) X[k + N/2] = X_e + X_o * (-wN) (because of step 2)
        X(k+1 + (N/2)) = X_e - X_o;
    end
else
    % ===============================================
    % Compute DFT using complex matrix multiplication
    % ===============================================
    %     
    % 
    % Frequency vector
    kHalf = (0 : N/2-1)'; 

    % Exponential basis functions for N/2-point DFT
    wNHalf = exp(-1j*2*pi/(N/2)*(kHalf * kHalf'));
    
    % Compute two N/2-point DFTs (Eq. 17)
    Xe = sum(repmat(x_e(:)',[N/2 1]) .* wNHalf,2);
    Xo = sum(repmat(x_o(:)',[N/2 1]) .* wNHalf,2);
    
    % Exponential basis functions for N-point DFT
    % (only required for k=0,1,...,N/2-1)
    wN = exp(-1j*2*pi/N*kHalf);
        
    % Apply wN to Xo according to the butterfly simplification
    Xo = Xo .* wN;
    
    % Combine both N/2-point DFTs (Eq. 18)
    X = [Xe + Xo; Xe - Xo];
end

% Frequency axis
w = 2 * pi .* (0:N-1) / N;

%% PLOT SPECTRUM
%
% If no output is specified
if nargout == 0
    
    % Normalized frequency axis
    wNorm = w / pi;
    
    figure;
    hold on;
    plot(wNorm,abs(X),'color',[0 0.3895 0.9712],'linewidth',1.5)
    legend({'DFT'})
    xlabel('$\omega_{k} / \pi$','interpreter','latex')
    ylabel('$|X[k]|$','interpreter','latex')
    grid on;
    xlim([0 wNorm(end)])
end
