% % Peng Zhang     Tsinghua Univ.    2009.12.13
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [txtcell, syncbit] = bit2text(x, syncword, ofile)
% 

function [txtcell, syncbit] = bit2text(x, syncword, ofile)

Default_Linedlm = '0D0A';
txtcell = {};

if nargin==1 || isempty(syncword)
    syncword = Default_Linedlm;
end
syncword = hex2dec(syncword(:));
syncbit = dec2bin(syncword).';
syncbit = syncbit(:)-'0';                  

x = x(:);
sync_idx = binvecfind(x, syncbit);         

if isempty(sync_idx)
    return
end


% sync_dist = diff(sync_idx);                       
% start_idx = find(mod(sync_dist, 8)==0, 1, 'first'); 
start_idx = 1;


sync_idx = sync_idx(mod(sync_idx-sync_idx(start_idx), 8)==0);       

end_idx = sync_idx(end)+length(syncbit)+floor((length(x)-(sync_idx(end)+length(syncbit)-1))/8)*8;
sync_idx = [sync_idx; end_idx];             

txtcell = cell(length(sync_idx)-1,1);
for ii=1:length(sync_idx)-1                      
    b = x(sync_idx(ii)+length(syncbit):sync_idx(ii+1)-1);
    b = reshape(b(:), 8, length(b)/8);
    str = char(bin2dec(char(b.'+'0')));
    txtcell{ii} = str.';
end

if nargin==3 && ~isempty(ofile)             
    fid = fopen(ofile, 'w');
    for ii=1:length(txtcell)
        fprintf(fid, '%s\r\n', txtcell{ii});
    end
    fclose(fid);
end








