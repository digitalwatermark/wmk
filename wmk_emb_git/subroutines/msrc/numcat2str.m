% % Concatenate numbers and convert to formatted string
% % Peng Zhang    Tsinghua Univ.    2009.02.11
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function outstrcell = numcat2str(x, str_prefix, str_suffix, str_cat)
% 
% ---------------------------------------------------------------

function outstrcell = numcat2str(x, str_prefix, str_suffix, str_cat)

if ~iscell(x)
    cell_enable = 0;
else
    cell_enable = 1;
end

if isnumeric(x)
    x = num2cell(x);    
elseif ischar(x)
    error('Use cell array for string input');
end

outstrcell = cell(size(x,1),1);

for ii=1:size(x,1)
    outstrcell{ii} = num2str(x{ii, 1});  
    for jj=2:size(x,2)
        outstrcell{ii} = [outstrcell{ii}, str_cat, num2str(x{ii, jj})]; 
    end
    outstrcell{ii} = [str_prefix, outstrcell{ii}, str_suffix]; 
end

if length(outstrcell)==1 && ~cell_enable
    outstrcell = outstrcell{1};   
end
