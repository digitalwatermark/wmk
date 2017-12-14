% % m-sequence generator
% % Peng Zhang     Tsinghua Univ.    2008.10.20
% % % % % % % % % % % % % % % % % % % 

function [out, deg] = msequence(genpoly, initstate, shift)

errchck(genpoly, initstate, shift);            

genpoly = genpoly(:);
initstate = initstate(:);

if sum(genpoly==0)+sum(genpoly==1)==length(genpoly) 
    deg = length(genpoly)-1;                  
else                                                     
    deg = max(genpoly);
    temp = zeros(deg+1,1);
    temp(deg-genpoly+1) = 1;                 
    genpoly = temp;
end

LFSR = initstate;        
out = zeros(2^deg-1,1);                        
for k=1:2^deg-1
    out(k) = LFSR(end);
    fb = mod(LFSR(:).'*genpoly(2:end), 2);  
    LFSR(2:end) = LFSR(1:end-1);       
    LFSR(1) = fb;                              
end

if shift~=0                                      
    out = circshift(out(:), shift);           
end

return
% EOF --- msequence.m

% % % % % % % % % 
%  Error checks
function errchck(genpoly, initstate, shift)

% Check generator polynomial
len_gp = length(genpoly);
if ~isvector(genpoly) || ~isreal(genpoly) || ~isnumeric(genpoly) || sum(genpoly>=0)<len_gp || sum(ceil(genpoly)==genpoly)<len_gp
    error('Generator polynomial vector must contain non-negative integers');
end

genpoly = genpoly(:);
initstate = initstate(:);

if sum(genpoly==0)+sum(genpoly==1)==len_gp  
    if ~genpoly(1) || ~genpoly(end)
        error('The first and last entries of generator polynomial must be 1 in coefficient expression');
    end
    deg = length(genpoly)-1;                           
else                                                                 
    if genpoly(end)
        error('The last entry of generator polynomial must be 0 in exponent expression');
    end
    deg = max(genpoly);                      
    temp = zeros(deg+1,1);
    temp(genpoly+1) = 1;         
    genpoly = temp;
end

if ~isprimitive(bin2dec(int2str(genpoly.'))) 
    error('Not a primitive polynomial');
end

% Check initial state
if length(initstate)~=deg
    error('The length of the initial states vector must equal the degree of the generator polynomial');
end
if  sum(initstate==0)+sum(initstate==1)~=length(initstate)
    error('All elements of the initial states vector must be binary numbers');
end
if ~sum(initstate)
    error('Initial states vector must contain at least one 1');
end

% Check shift
if ~isscalar(shift) || ~isreal(shift) || ~isnumeric(shift) || ceil(shift)~=shift
    error('Shift value must be integer');
end

% EOF --- errchck.m