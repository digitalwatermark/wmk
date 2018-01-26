
% Revised by Peng Zhang, Tsinghua Univ., 2009-02-27
% accelerated (2~3 times faster); the sample order in the buffer reversed
% see also: analysis_window
%-------------------------------------------------------------------------------

%   old version: Analysis_subband_filter(Input, n, C)
%   Returns the 32 subband samples S(i) defined in [1, pp. 67, 78]
%   n is the index in Input where the 32 `new'samples are located.
%   C is the analysis window defined in [1, pp.68--69].
%   Author: Fabien A. P. Petitcolas

function [S,test] = subband_filter_mpeg(x, index, C, M)
%S = Analysis_subband_filter(x, n, C)
%   Returns the 32 subband samples S defined in [1, pp. 67, 78]

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%   [2] Analysis_subband_filter.m, Fabien A. P. Petitcolas, Computer Laboratory,
%           University of Cambridge, www.cl.cam.ac.uk/~fapp2/software/mpeg/

% Error checks
if (index+31>length(x) || index<1)
   error('Unexpected analysis index.');
end
if ~isvector(x)
    error('Input signal must be a vector.');
end

% Build an input vector X of 512 elements. The most recent sample
% is at position 1 while the oldest element is at position 512.
% Pad with zeroes if the input signal does not exist.

x = x(:);
X = x(index+31:-1:max(1, index-480));
X = [X; zeros(512-length(X), 1)];

% Window vector X by vector C. This produces the Z buffer.
Z = X.*C;

% Partial calculation: 64 Yi coefficients
Y = sum(reshape(Z, 64, 8), 2);         % more than 100 times faster than for-statements

% Calculate the analysis filter bank coefficients
% [kk, ii] = meshgrid(0:63, 0:31);
% M = cos((2*ii+1).*(kk-16)*pi/64);       % more than 20 times faster than for-statements

% Calculate the 32 subband samples Si
% more than 500 times faster than for-statements
S = M*Y(:);       % old version is wrong

test = S(:);

% --- EOF: subband_filter_mpeg

