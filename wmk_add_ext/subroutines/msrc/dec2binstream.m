
% % Convert decimal vector to binary stream
% % Peng Zhang     Tsinghua Univ.    2008.12.21
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = dec2binstream(x, m, order)
% 

function y = dec2binstream(x, m, order)

if (sum(x<0)+sum(x>2^m-1) +sum(x~=ceil(x))~= 0)
    error('Elements of x must be integers in the interval of [0, 2^m-1]');
end

x = x(:);

temp = dec2bin(x, m)-'0'; 
temp = temp.';

if strncmpi(order, 'msb', 3)        
    y = temp(:);
    
elseif strncmpi(order, 'lsb', 3) 
    temp = temp(end:-1:1,:);
    y = temp(:);
   
else
    error('order must be ''msb'' or ''lsb''');
end

return
