function y = convolve(x, h)
%convolve   Linear convolution of two vectors in the time domain.
% 
%USAGE
%   y = convolve(x,h)
% 
%INPUT ARGUMENTS
%   x : input sequence [N x 1 | 1 x N]
%   h : impulse response [M x 1 | 1 x M]
% 
%OUTPUT ARGUMENTS
%   y : output sequence [N + M - 1 x 1]
%
%   ***********************************************************************

%% CHECK INPUT ARGUMENTS
%
% Check for proper input arguments
if nargin ~= 2
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Get dimensions (rows and columns of the array)
xDim = size(x); 
hDim = size(h);

% Check if x and h are vectors
if min(xDim) > 1 || min(hDim) > 1
    error('x and h must be vectors.')
else
    % Ensure column vectors
    x = x(:);
    h = h(:);
    
    % Dimensionality of x and h
    N = max(xDim);
    M = max(hDim);
end

%% DIRECT IMPLEMENTATION OF CONVOLUTION SUM
%
% Length of output sequence
L = N + M - 1;

% (Column) Array for the output sequence
y = zeros(L, 1);

% Loop over the number of output sequence
for n = 0:L - 1

    % Loop over the number of overlapping samples
    for m = 0:n

        % Calculate convolution sum for indices where x[mm] and h[nn-mm]
        % overlap by at least one element
        if((m >= 0 && m <= N -1) && (n-m >= 0 && n-m <= M-1))
            y(n + 1) = y(n + 1) + x(m + 1) .* h((n-m) + 1); 
        end
    end
end

%% PLOT OUTPUT SEQUENCE
%
% If no output is specified
if nargout == 0
    figure;
    hold on;
    n = (0:1:length(y)-1);
    stem(n, y, 'color', [0 0.3895 0.9712],'linewidth',1.5)
    xlabel('Index')
    ylabel('n')
    title('y[n]')
    grid on
end