% % Error pattern
% % Peng Zhang     Tsinghua Univ.    2008.12.23
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [pattern, prob] = errpattern(L, N, shift, type, T)
% 

function [pattern, prob] = errpattern(L, N, shift, type, T)

if (L<=0 || L~=ceil(L) || N<0 || N~=ceil(N))
    error('L and N must be an positive integer');
end
if N>L
    error('N must be no greater than L');
end

if strncmpi(type, 'burst', 5)                        
%     if mod(shift, L)>L-N
%         error('shift must be no greater than L-N for busrt error pattern');
%     end
    y = [ones(N,1); zeros(L-N,1)];
   shift = mod(shift, L-N+1);                      
   
elseif strncmpi(type, 'periodic', 8)           
    if isequal(T, [])                                      
        T = floor(L/N);
    elseif (T<=0 || T~=ceil(T))
        error('T must be an positive integer');
    elseif T>floor(L/N)
        error('T must be no greater than floor(L/N) for periodic error pattern');
    end
    
    tmp = [ones(1,N); zeros(T-1,N)];        
    tmp= tmp(:);
    y = [tmp; zeros(L-length(tmp), 1)];  

    shift = mod(shift, L-T*(N-1));               
    
elseif strncmpi(type, 'random', 6)           
    y = zeros(L, 1);    
    pos = randperm(L);                             
    y(pos(1:N)) = 1;
 
%     % method 2
%     y = randerr(1, L, N);                         
%     y = y(:);

%    %method 3: choose one and delete (overhead depends on N, maxmum N/2)
%     pos = zeros(N,1);
%     tmp = 1:L;
%     for ii=1:N
%         p = randint(1,1, [1, L-ii+1]);
%         pos(ii) = tmp(p);
%         tmp(p) = [];                                  
%     end
%     y = zeros(L,1);
%     y(pos) = 1;

else
    error('type must be ''burst'', ''periodic'' or ''random''');
end

pattern = circshift_vec(y, shift);          
prob = N/L;

return

% % % % % % EOF ---- errpattern.m


function y = circshift_vec(x, shiftlen)
if ~isvector(x)
    error('Matrix is not supported. Please refer to circshift');
end
ort = size(x,1);    
if ort==1
    x = x(:);
end
pos = mod(shiftlen, length(x));
if pos~=0
    y = [x(end-pos+1:end); x(1:end-pos)];      
else
    y = x;
end
if ort==1
    y = y(:).';
end
return
% % % % % % EOF ---- circshift_vec.m
