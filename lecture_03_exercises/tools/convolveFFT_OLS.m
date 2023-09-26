function final_y = convolveFFT_OLS(x, h, N, bZeroPad)
    % overlap-save method
    % x = input signal of dimension [Nx x 1]
    % h = impulse response of dimension [M x 1]
    % N = DFT size which should, by default, be determined by minimizing Eq. (24)
    % bZeroPad = a binary flag indicating if x should be padded with M − 1 zeros

    Nx = length(x);         % Input signal length
    M = length(h);          % Length of impulse response
    L = N - M + 1;          % Length of blocks  (# of samples per block) 
    Ny = Nx;                % Length of output signal
    nBlocks = ceil(Nx/L);   % Number of blocks

    % 1) Zero-pad h[n] to length N = L + M - 1
    h = cat(1, h(:), zeros(N-M, 1));

    % 2) DFT of h[n]
    H = fft(h, N);

    % 3.1) Zero-pad x[n] with M - 1 at the start
    % (el valor de M no cambia, siempre es el original)
    x = cat(1, zeros(M-1, 1), x(:));
    Nx = length(x);

    % 3.2) Check for bZeroPad to zero-pad x[n] at the end
    if bZeroPad
        x = cat(1, x(:), zeros(M-1, 1));
        temp_Nx = length(x);
        nBlocks = ceil(temp_Nx/L);
        Ny = Nx;
    end

    % 3.3) Append zeros such that an integer number of blocks can 
    % be processed (may not be necessary to add more zeros)
    % x = cat(1, x(:), zeros(floor(nBlocks*L-Nx), 1));
    x = cat(1, x(:), zeros(nBlocks * L - Nx,1));
    % Ny = length(x);

    % Allocate memory
    % y = zeros(N, nBlocks); % whole block 
    % clean_y = zeros(L, nBlocks); % last l values of the block (N = L + M-1)
    final_y = zeros(Ny,1);

    % 4) Segmentation of x[n] in nBlocks
    for ii = 0 : nBlocks - 1
        % Sample indeces (for each block)
        idx = (1:N) + ii * L;

        % Time segmentation
        xHat = x(idx);
        
        % 5) Filtering each block
        % DFT of xHat
        X = fft(xHat, N);
        
        % Convolution in frequency domain
        Y = X .* H;

        % IDFT of Y
        y_m = ifft(Y,N);

        % Append the last L samples of each y_m block
        % y(:, ii + 1) = y_m;
        % clean_y(:, ii+1) = y_m(M-1+1:end,1);

        % Sample indeces for output signal
        start = 1 + (ii*L);
        finish = L + (ii*L);
        final_y(start:finish,1) = y_m(M-1+1:end,1);
    end
    final_y = final_y(1:Ny);
