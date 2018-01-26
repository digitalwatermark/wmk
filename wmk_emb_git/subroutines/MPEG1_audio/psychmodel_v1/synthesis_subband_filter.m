% Synthesis subband filter for MPEG-1 audio
% Peng Zhang, Tsinghua Univ., 2010-03-01
% Returns 384 temporal samples x for each 384 subband samples,
% and shift buffer V
% Note:
% stereo not supported

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.

% Vbuff :1024 vector

function [x, Vbuff] = synthesis_subband_filter(S, Vbuff, D, N)
Nsb = 32;
Nsamp_sb = 12;
Nsamp = Nsb*Nsamp_sb;

if mod(numel(S), Nsamp)
    error(['Number of elements in S must be multiple of ', num2str(Nsamp), '.']);
end

S = S(:);
Nseg = length(S)/Nsamp;

b = repmat(1:32, 8, 1);
idx1_L = b+repmat((0:64:448).', 1, 32);
idx1_R = b+repmat((0:128:896).', 1, 32);
idx1_L = idx1_L(:);
idx1_R = idx1_R(:);
U = zeros(1, 512);
x = zeros(length(S), 1);

for nn=1:Nseg
    y = zeros(32, 12);
    S_seg = reshape(S((nn-1)*384+1:nn*384), 12, 32);
   for kk=1:12
        Vbuff(65:1024) = Vbuff(1:960);
        Vbuff(1:64) = N*S_seg(kk,:).';
        
        U(idx1_L) = Vbuff(idx1_R);
        U(idx1_L+32) = Vbuff(idx1_R+96);
                
        W = U(:).*D(:);
        y(:,kk) = sum(reshape(W(:), 32, 16), 2);
   end

   x((nn-1)*Nsamp+1:nn*Nsamp) = y(:);
end

