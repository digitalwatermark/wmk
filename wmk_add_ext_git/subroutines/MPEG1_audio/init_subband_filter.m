% Initialize windows and matrices of analysis and synthesis subband filter used in MPEG-1 audio
% Peng Zhang, Tsinghua Univ., 2010-03-02
% see also:
% References:
% [1] Information technology -- Coding of moving pictures and associated
%      audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%      British standard. BSI, London. October 1993. Implementation of ISO/IEC
%      11172-3:1993. BSI, London. First edition 1993-08-01.
%-------------------------------------------------------------------------------

function [C_anawin, M_anamat, D_synwin, N_synmat] = init_subband_filter()

C_anawin = analysis_window();   
[kk, ii] = meshgrid(0:63, 0:31);
M_anamat = cos((2*ii+1).*(kk-16)*pi/64);  

D_synwin = synthesis_window();          
[kk, ii] = meshgrid(0:31, 0:63);
N_synmat = cos((2*kk+1).*(ii+16)*pi/64);  

