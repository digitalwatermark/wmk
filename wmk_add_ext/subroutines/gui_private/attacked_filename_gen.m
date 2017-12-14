% % Generate attacked filename according to input filename, destination directory, 
% % output filename template, and parameter value (in special use)
% % Peng Zhang    Tsinghua Univ.    2009.02.12
% % % % % % % % % % % % % % % % % % %


function ofilename = attacked_filename_gen(src_file, dest_dir, filename_template, param_value)

if size(param_value, 1)>1
    error('Param value must be a row vector or cell array');
end

if ischar(filename_template)
    filename_template = {filename_template};
end

%  if c is a m-by-n cell array {c{:}} is 1-by-mn cell array !!!!!!

value_str = numcat2str(param_value, '*[', ']', ',');
if ~iscell(value_str)
    value_str = {value_str};
end

ofilename = output_filename_gen(src_file, dest_dir, {filename_template{:}, value_str{1}});             
