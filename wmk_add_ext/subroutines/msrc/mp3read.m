% % Read MP3 file
% % Peng Zhang     Tsinghua Univ.    2009.01.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [y, fs, nbit] = mp3read(filename)
% 
% ---------------------------------------------------------------

function [y, fs, nbit] = mp3read(filename)

[pathstr, name, ext, versn] = fileparts(which('mpg123.exe')); 

temp_file = fullfile(pathstr,'temp.wav');                 

log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];

% dos([pathstr,'\mpg123 >NULL 2>&1 -q  -w ', temp_file, ' ', filename]);  

dos([pathstr,'\mpg123 >', log_file, ' 2>&1 -q  -w ', temp_file, ' ', filename]);  

[y, fs, nbit] = wavread(temp_file);                    

delete(temp_file);
delete(log_file);

return