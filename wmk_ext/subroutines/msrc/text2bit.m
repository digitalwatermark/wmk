% % Read text file and convert ASCII characters to bits, with sync word as line delimiter
% % Peng Zhang     Tsinghua Univ.    2009.12.12
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [x, syncbit, txtcell] = text2bit(ifile, syncword, ofile, N)
% 

function [x, syncbit, txtcell] = text2bit(ifile, syncword, ofile, N)

Default_Linedlm = '0D0A';

if nargin==1 || isempty(syncword)
    syncword = Default_Linedlm;
end
syncword = hex2dec(syncword(:));
syncbit = dec2bin(syncword).';
syncbit = syncbit(:)-'0';       

if nargin<4 || ~isscalar(N)
    read_all = 1;
else
    read_all = 0;
end
    
if ischar(ifile)
    fid = fopen(ifile, 'r');
    if fid==-1
        error('Input text file not found.');
    end
    if read_all
        txtcell = textscan(fid, '%s', 'Delimiter', '\n');
    else
        txtcell = textscan(fid, '%s', N, 'Delimiter', '\n');
    end
    fclose(fid);
    txtcell = txtcell{:};
elseif iscell(ifile)
    if read_all
        txtcell = ifile(:);
    else
        txtcell = ifile(1:min(N,length(ifile)));
        txtcell = txtcell(:);
    end
end

x = [];
for ii=1:length(txtcell)
    str = txtcell{ii};
    b = dec2base(uint8(str.'), 2, 8).';
    b = b(:)-'0';                          
    x = [x; syncbit; b];
end

if nargin>=3 && ~isempty(ofile)
    save(ofile, 'x');
end
