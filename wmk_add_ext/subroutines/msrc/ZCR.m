
function r = ZCR(x)

if size(x, 1)==1
    x = x(:);
end

r = sum(abs(diff(x>0)))/size(x,1); 