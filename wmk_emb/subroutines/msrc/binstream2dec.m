
% % Convert binary stream to decimal vector
% % Peng Zhang     Tsinghua Univ.    2008.12.21
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = binstream2dec(x, m, order)
% 

function y = binstream2dec(x, m, order)

if (sum(x<0)+sum(x>1) +sum(x~=ceil(x))~= 0)
    error('Elements of x must be binary');
end

if length(x)/m~=ceil(length(x)/m)
    error('Length of x must be multiple of m');
end

x = x(:);

temp = reshape(x, m, length(x)/m);
        
if strncmpi(order, 'msb', 3)                 
    y = temp'*2.^[m-1:-1:0]';
    
elseif strncmpi(order, 'lsb', 3)            
    y = temp'*2.^[0:m-1]';
   
else
    error('order must be ''msb'' or ''lsb''');
end

return
