% % Time Scale Modification of Audio
% % Peng Zhang     Tsinghua Univ.    2009.02.18
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = tsm_pvoc(x, ratio)
%
% ---------------------------------------------------------------

function y = tsm_pvoc(x, ratio)

r = 1/ratio;

for ii=1:size(x, 2)
    y(:,ii) = pvoc(x(:, ii), r, 512);
end
