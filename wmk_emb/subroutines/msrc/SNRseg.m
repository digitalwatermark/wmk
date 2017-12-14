
% Segmental Signal to Noise Ratio (dB) of signal and estimated signal
% Peng Zhang     E.E. Dept. @ Tsinghua Univ.   2007-08-08
% function sn_ratio = SNRseg(s, s_est, seglen, threshold)

function sn_ratio = SNRseg(s, s_est, seglen, threshold)

% if ~isvector(s)
%     warning('Only the first columns are used for matrices input');
% end

seglen = round(seglen);
segnum = floor(length(s)/seglen);
s = s(1:seglen*segnum,1);
n = s-s_est(1:seglen*segnum,1);

s = reshape(s,seglen,segnum);
n = reshape(n,seglen,segnum);
s_energy_seg = sum(abs(s).*abs(s));
n_energy_seg = sum(abs(n).*abs(n));
% sel = (s_energy_seg>threshold*seglen*ones(1,segnum));         
% sn_ratio = 10/sum(sel)*log10(s_energy_seg./n_energy_seg)*sel';   
sel = find(s_energy_seg>threshold*seglen*ones(1,segnum));         
sn_ratio = 10*mean(log10(s_energy_seg(sel)./n_energy_seg(sel)));

return;