function x = fade(x, Nin, Nout, option)
%fade   Apply a raised cosine window for fade in and fade out
% 
%USAGE
%   y = fade(x, Nin, Nout)
%  
%INPUT ARGUMENTS
%         x : input signal [N x 1]
%   Nfadein : number of samples to fade in
%  Nfadeout : number of samples to fade out
% 
%OUTPUT ARGUMENTS
%   x : signal with raised cosine window applied [N x 1]

%% CHECK INPUT ARGUMENTS
%
% Check for proper input arguments
if nargin < 1 || nargin > 4
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 4 || isempty(option); option = 0; end
if nargin < 3 || isempty(Nout); Nout = 10; end
if nargin < 2 || isempty(Nin);  Nin  = 10; end

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    x = x(:);
end


%% WINDOWING 
% 
% Dimensionality
N = numel(x);

% Reduce abrupt discontinuities at signal start and end, by fading in over
% number of samples specified by Nin and Nout.

% Create raised cosine windows for fade in and out
% -- ADD YOUR CODE HERE --------------------------------------------------
if option == 0
    wIn = hann(2*Nin); % fade in (use first half)
    wOut = hann(2*Nout); % fade out (use second half)

    % Apply window
    x(1:Nin) = x(1:Nin) .* wIn(1:Nin);
    x(N-Nout+1:N) = x(N - Nout + 1 : N) .* wOut(Nout+1 : Nout*2);

elseif option == 1
    nin = (0 : Nin-1);
    nout = (0 : Nout-1);

    wIn = 0.5 * (1 - cos(pi * nin/(Nin-1)));
    wOut = 0.5 * (1 + cos(pi * nout/(Nout-1)));
    
    x(1:Nin) = x(1:Nin) .* wIn(:);
    x(N-Nout+1:N) = x(N-Nout+1:N) .* wOut(:);
end
