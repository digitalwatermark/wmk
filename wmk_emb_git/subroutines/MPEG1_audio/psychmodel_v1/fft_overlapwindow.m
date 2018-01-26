% % Overlapped-Windowed FFT
% % Peng Zhang     Tsinghua Univ.    2009.03.02
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function X = fft_overlapwindow(x, offset, h, nfft, noverlap)
% 
% Syntax:
% X = fft_overlapwindow(x, offset, h, nfft, noverlap)
% 
% I/O Arguments:
% x : vector : input sequence
% offset : integer : start index of the first non-overlapped sample
% h : vector : window applied before FFT
% nfft : integer : number of FFT points
% noverlap : integer : number of overlapped samples between adjacent segment;
%                                  total number of overlapped samples are 2*noverlap
% X : vector : output spectrum of x
% 
% Note:
% 1) time alignment is as below:
% x... |          (overlapped)           |                      (new)                      |           (overlapped)        | ...
%      offset-noverlap      offset-1 offset     offset+nfft-2*noverlap-1     offset+nfft-noverlap-1
%       |                                                            FFT window                                                         |
% 2) zeros will be padded if there is lack of samples

% Example:
% Algorithm:
% Revision:
% See also:
% References:
% Computational cost:
% Profile report:

%-------------------------------------------------------------------------------

function X = fft_overlapwindow(x, offset, h, nfft, noverlap)

x = x(:);
N = length(x);

if N<nfft
    error('Input vector is too short.');
end

% Pad zeros if there is lack of samples
if (offset<noverlap+1)                      % pad prefixed zeros
    s = [zeros(noverlap-offset+1, 1); x(1:offset+nfft-noverlap-1)];
elseif (N<offset-noverlap+nfft-1)    % pad suffixed zeros
    s = [x(offset-noverlap:N); zeros(offset+nfft-noverlap-N-1, 1)];
else
    s = x(offset-noverlap: offset+nfft-noverlap-1); 
end

% Windowed FFT
X = fft(s .* h, nfft);

