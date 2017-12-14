
% % Convert binary or hexadecimal string cell to bits
% % Peng Zhang     Tsinghua Univ.    2011.04.09
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% bitvec = strcell2bit(strcel, char_format)
% 

function bitvec = strcell2bit(strcel, char_format)

% default
if nargin==1
    char_format = 'bin';
elseif ~strcmpi(char_format, 'bin') && ~strcmpi(char_format, 'hex')
    char_format = 'bin';
    warning('Character format must be ''bin'' (default) or ''hex''.');
end

charmat = cell2mat(strcel);

tmp = charmat.';
tmp = tmp(:);
if strcmpi(char_format, 'bin')         
    bitvec = tmp-'0';             
elseif strcmpi(char_format, 'hex')     
    bitmat = dec2bin(hex2dec(tmp));
    bitmat = bitmat.';
    bitvec = bitmat(:)-'0';
end

