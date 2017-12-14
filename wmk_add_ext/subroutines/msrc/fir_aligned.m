% % 1-D FIR filter
% % Peng Zhang     Tsinghua Univ.    2009.12.09
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = fir_aligned(x, h)
% 

%--------------------------------------------------------------------------

function y = fir_aligned(x, h)

nrow = size(x,1);
if (nrow == 1)   
    x = x(:);
end

if mod(length(h), 2)==0
    warning('Even number of filter coefficients is not supported.');
end

group_delay = floor((length(h)-1)/2);
y = filter(h,1,[x; zeros(group_delay, size(x,2))]);     
y = y(group_delay+1:end, :);                                    

if nrow==1
    y = y.';
end

return