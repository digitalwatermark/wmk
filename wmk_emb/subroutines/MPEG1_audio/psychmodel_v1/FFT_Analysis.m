
% Revised by Peng Zhang, Tsinghua Univ., 2009-02-27
% accelerated (slightly faster); set window h as input argument; 2 bugs fixed
%-------------------------------------------------------------------------------

function [X, Delta]  = FFT_Analysis(x, offset, h, nfft, noverlap)
%X = FFT_Analysis(x, offset, h, nfft, noverlap)
%
%   Compute the auditory spectrum using the Fast Fourier Transform.
%   The spectrum X is expressed in dB. The size of the transform si 512 and
%   is centered on the 384 samples (12 samples per subband) used for the 
%   subband analysis. The first of the 384 samples is indexed by offset:
%   ................................................
%      |       |  384 samples    |        |
%      offset-64    offset                 offset+383    offset+447
%
%   A Hanning window applied before computing the FFT.
%
%   Finaly, a normalisation  of the sound pressure level is done such that
%   the maximum value of the spectrum is 96dB; the number of dB added is 
%   stored in Delta output.
%
%   One should take care that the x is not zero at all samples.
%   Otherwise W will be -INF for all samples.
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/FFT_Analysis.m 3     7/07/01 1:27 Fabienpe $
%   $Id: FFT_Analysis.m,v 1.4 1998-07-08 11:29:26+01 fapp2 Exp $

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%
%   Legal notice:
%    This computer program is based on ISO/IEC 11172-3:1993, Information
%    technology -- Coding of moving pictures and associated audio for digital
%    storage media at up to about 1,5 Mbit/s -- Part 3: Audio, with the
%    permission of ISO. Copies of this standards can be purchased from the
%    British Standards Institution, 389 Chiswick High Road, GB-London W4 4AL, 
%    Telephone:+ 44 181 996 90 00, Telefax:+ 44 181 996 74 00 or from ISO,
%    postal box 56, CH-1211 Geneva 20, Telephone +41 22 749 0111, Telefax
%    +4122 734 1079. Copyright remains with ISO.
%-------------------------------------------------------------------------------

% Delta = [];
% X = [];
global MIN_POWER;

x = x(:);
N = length(x);
nfftshift = nfft-2*noverlap;
% Check input parameters
if (offset + nfftshift - noverlap -1 > N || offset < 1)
    pause
   error('x too short: not enough samples to compute the FFT.');
end

% Prepare the samples used for the FFT
% Add zero padding if samples are missing

% s = x(max(1, offset - noverlap):min(N, offset + nfft - noverlap - 1)); 
% if (offset - noverlap < 1)
%    s = [zeros(noverlap - offset + 1, 1); s];
% end
% if (N < offset - noverlap + nfft - 1)
%    s = [s; zeros(offset - noverlap + nfft - 1 - N, 1)];
% end
% % plot(s);drawnow;pause
% s2 = s;

% new code
if (offset<noverlap+1)
    s = [zeros(noverlap-offset+1, 1); x(1:offset+nfft-noverlap-1)];
elseif (N<offset-noverlap+nfft-1)
    s = [x(offset-noverlap:N); zeros(offset+nfft-noverlap-N-1, 1)];
else
    s = x(offset-noverlap: offset+nfft-noverlap-1); 
end

% max(abs(s2-s))

% Prepare the Hanning window
% h = sqrt(8/3) * hanning(nfft, 'periodic');        % wrong. should be h = sqrt(8/3)*0.5*(1-cos(2*pi*(0:nfft-1).'/(nfft-1))); or h = hann(nfft,'symmetric');

% Power density spectrum
% X = max(20 * log10(abs(fft(s .* h)+1e-10) / nfft), MIN_POWER);            % to avoid -inf
% X = 20 * log10(abs(fft(s .* h)+1e-10) / nfft);            % to avoid -inf warning
X = max(20 * log10(abs(fft(s .* h)) / nfft), MIN_POWER);

% Normalization to the reference sound pressure level of 96 dB
Delta = 96 - max(X);
X = X +  Delta;
