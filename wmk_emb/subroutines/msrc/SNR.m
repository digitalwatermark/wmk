
% Signal to Noise Ratio (dB) of signal and received signal
% Peng Zhang     E.E. Dept. @ Tsinghua Univ.   2007-08-07
% function sn_ratio = SNR(s, s_rx)


function sn_ratio = SNR(s, s_rx)

% if ~isvector(s)
%     warning('Only the first columns are used for matrices input');
% end
if ~isequal(size(s), size(s_rx))
    error('Two signals must be of the same size.');
end

if size(s,1)==1
    s = s(:);
    s_rx = s_rx(:);
else
    s = s(:,1);
    s_rx = s_rx(:,1);
end
n= s-s_rx;
sn_ratio = 10*log10((sum(abs(s).*abs(s)))/(sum(abs(n).*abs(n))+eps)+eps);

return;