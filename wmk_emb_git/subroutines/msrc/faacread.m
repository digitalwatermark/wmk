% % Read AAC file
% % Zhang Peng    Tsinghua Univ.    2009.01.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [y, fs, nbit] = faacread(varargin)
% 
% ---------------------------------------------------------------

function [y, fs, nbit] = faacread(varargin)

if nargin<1 || nargin>2
    error('Unsupported number of input arguments') 
end

filename = varargin{1};
if nargin==2
    option = varargin{2};
else
    option= '';
end

[pathstr, name, ext, versn] = fileparts(which('faad.exe'));       

temp_file = fullfile(pathstr,'temp.wav');                                     

log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];

% dos([pathstr,'\faad  >/NULL 2>&1', filename, ' -o ', temp_file, ' ', option]);   
dos([pathstr,'\faad  >' log_file, ' 2>&1', filename, ' -o ', temp_file, ' ', option]); 

[y, fs, nbit] = wavread(temp_file);                                            

delete(temp_file);
delete(log_file);

return