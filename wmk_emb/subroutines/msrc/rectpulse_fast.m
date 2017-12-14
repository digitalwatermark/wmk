% Fast rectangular pulse shaping (for vector only)
% % Peng Zhang     Tsinghua Univ.    2009.03.06
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = rectpulse_fast(x, nsamp)
% 
% ---------------------------------------------------------------

function y = rectpulse_fast(x, nsamp)

if ~isvector(x)
    error('Matrix input not supported.Use rectpulse instead.');
end

y = repmat(x(:), 1, nsamp);
y = y.';
y = y(:);

if size(x, 1)==1
    y = y.';
end
