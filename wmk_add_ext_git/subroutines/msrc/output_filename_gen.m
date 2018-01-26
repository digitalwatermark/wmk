% % Generate output filename according to input filename, destination directory and output filename template
% % Peng Zhang    Tsinghua Univ.    2009.02.10
% % % % % % % % % % % % % % % % % % %
% Prototype:
% function ofilename = output_filename_gen(src_file, dest_dir, filename_template)
%
% ---------------------------------------------------------------
function ofilename = output_filename_gen(src_file, dest_dir, filename_template)

if ischar(filename_template)
    filename_template = {filename_template};
elseif ~iscell(filename_template)
    error('Output filename template must be string or string cell array.');        
end

if  isempty(src_file)
    src_file = {''};
    cell_enable = 0;
elseif ischar(src_file)
    src_file = {src_file};
    cell_enable = 0;
elseif iscell(src_file)
    cell_enable = 1;
else
    error('Source filename must be string or string cell array.');
end

filename_template = filename_template(:);
src_file = src_file(:);

ofilename = cell(size(src_file));
for n=1:length(src_file)
    [src_path_temp, dest_filename, ext, versn_temp] = fileparts(src_file{n});
    
    for ii=1:length(filename_template)
        star_pos = strfind(filename_template{ii}, '*'); 
        if isscalar(star_pos)
            if star_pos==1                                                  
                dest_filename = [dest_filename, filename_template{ii}(2:end)];
            elseif star_pos==length(filename_template{ii})  
                dest_filename = [filename_template{ii}(1:end-1), dest_filename];          
            else
                error('Wildcard character ''*'' in output filename template must be prefixed or suffixed.');
            end
        else                                                            
            error('Output filename template must contain one and only one wildcard character ''*''.');        
        end 
    end
    ofilename{n} = fullfile(dest_dir, [dest_filename, ext]);
end

if cell_enable==0            
    ofilename = ofilename{1};
end