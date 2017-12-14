% % Peng Zhang     Tsinghua Univ.    2011.04.06
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [nerr, ber] = biterr_min(xbit, ybit)
% 

function [nerr, ber, pos] = biterr_min(xbit, ybit)

xbit = xbit(:);
ybit = ybit(:);

% method 1 (accurate; no truncation)
y = 1-2*ybit;
Ly = length(ybit);

xbit_rep = repmat(xbit, ceil(Ly/length(xbit))+1, 1);  

r = linxcorr_fft(1-2*xbit_rep, y);
r = r(Ly:end-Ly+1);        % length(r)==length(x_rep)-Ly+1

[max_temp, pos] = max(r);
pos = mod(pos-1, length(xbit))+1;           
[nerr, ber] = biterr(ybit, xbit_rep(pos:pos-1+Ly));
