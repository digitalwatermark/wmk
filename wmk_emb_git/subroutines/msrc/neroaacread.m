% % Read AAC file
% % Peng Zhang     Tsinghua Univ.    2009.01.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [y, fs, nbit] = neroaacread(filename)
% 
% ---------------------------------------------------------------

function [y, fs, nbit] = neroaacread(filename)

[pathstr, name, ext, versn] = fileparts(which('neroAacDec.exe'));  

temp_file = fullfile(pathstr,'temp.wav');        

log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];

% dos([pathstr,'\neroAacDec >/NULL 2>&1 -if ', filename, ' -of ', temp_file]);  
dos([pathstr,'\neroAacDec >', log_file, ' 2>&1 -if ', filename, ' -of ', temp_file]);  

[y, fs, nbit] = wavread(temp_file);              

delete(temp_file);
delete(log_file);

return