% % Write variable assignment clauses to file
% % Zhang Peng    Tsinghua Univ.    2009.02.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function fprintf_var(fid, var_name, var_content)
% 
% ---------------------------------------------------------------

function fprintf_var(fid, var_name, var_content)

if ischar(var_content)
    fprintf(fid, [var_name, ' = ''%s'';\n'], var_content);
elseif isnumeric(var_content)
    fprintf(fid, [var_name, ' = ', mat2str(var_content), ';\n']);     
elseif iscell(var_content)
    fprintf(fid, [var_name, ' = {']);
    for ii=1:size(var_content,1)        
        for jj=1:size(var_content,2)
            if ischar(var_content{ii, jj})
                fprintf(fid, ['''%s'' '], var_content{ii, jj});
            elseif isnumeric(var_content{ii, jj})
                fprintf(fid, [mat2str(var_content{ii, jj}), ' ']); 
            end            
        end
        fprintf(fid, '; ');
    end
    fprintf(fid, '};\n');
end
        
