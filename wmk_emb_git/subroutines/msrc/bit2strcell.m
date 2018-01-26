
% % Convert bits to string cell
% % Peng Zhang     Tsinghua Univ.    2011.04.08
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function strcel = bit2strcell(bitvec, nchar_per_line, char_format)
% 

function strcel = bit2strcell(bitvec, nchar_per_line, char_format)
% default
if nargin==1
    nbit_per_char = 1;
    nchar_per_line = 1;
elseif nargin==2
    nbit_per_char = 1;
else
    if strcmpi(char_format, 'bin')                 
        nbit_per_char = 1;
    elseif strcmpi(char_format, 'hex')         
        nbit_per_char = 4;
    else
        nbit_per_char = 1;
        warning('Character format must be ''bin'' (default) or ''hex''.');
    end
end

bitvec = bitvec(:);
nchar = floor(length(bitvec)/nbit_per_char);     
len_bitvec = nchar*nbit_per_char;        
tmp = reshape(bitvec(1:len_bitvec), nbit_per_char, nchar);
charvec = dec2hex(bin2dec(int2str(tmp.')));         
nline = ceil(length(charvec)/nchar_per_line); 
charvec = [charvec; zeros(nline*nchar_per_line-length(charvec), 1)]; % padding the last line if it is not full
charmat = reshape(charvec, nchar_per_line, nline);
strcel = num2cell(charmat.', 2);
