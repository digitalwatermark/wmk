
% % Read and Execute Matlab expression from text file (line-by-line)
% % Peng Zhang    Tsinghua Univ.    2010.07.18
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function var_name = readeval(ifile)
% 
% ---------------------------------------------------------------

function var_name = readeval(ifile)

fid = fopen(ifile);

nn = 1;
var_name = {};
while ~feof(fid)
    tline = fgetl(fid);
    if ~isempty(tline) &&  ~isequal(tline(1), '%')
        if ~isscalar(strfind(tline, '='))
            error('Each non-comment line must have one and only one ''=''. ');
        end
        evalin('caller', tline);        
    
        token = strtrim(strtok(tline, '='));  

        if ~all((token>='0' & token<='9') | (token>='a' & token<='z') | (token>='A' & token<='Z') | token=='_')
            error('Variable name must contain only numbers, letters, or underline.');
        end
        var_name{nn} = token;
        nn = nn+1;
    end
end

fclose(fid);

% ASCII
% 0~9: 48~57
% a~z: 97~122
% A~Z: 65~90
% _: 95
