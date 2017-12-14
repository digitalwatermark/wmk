% % Write AAC file
% % Peng Zhang     Tsinghua Univ.    2009.01.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function neroaacwrite(varargin)
% 
% ---------------------------------------------------------------

function neroaacwrite(varargin)

if ~ischar(varargin{1})             
    if nargin<4 || nargin>6
        error('Unsupported number of input arguments') 
    end

    y = varargin{1};          
    fs = varargin{2};          
    nbit = varargin{3};       
    ofile = varargin{4};       

    if nargin>=5
        bitrate = varargin{5}*1000;  
        if isequal(bitrate, [])
            bitrate = 128000;
        end
    else
        bitrate = 128000;                   
    end
    bitrate = num2str(bitrate);

    if nargin>=6
        option = varargin{6};           
    else
        option = [];
    end

    [pathstr, name, ext, versn] = fileparts(which('neroAacEnc.exe')); 

    temp_file = fullfile(pathstr,'temp.wav');             

    wavwrite(y, fs, nbit, temp_file);
    
    log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];
    
%     dos([pathstr,'\neroAacEnc >/NULL 2>&1 ', ' -cbr ', bitrate, ' -if ', temp_file, ' -of ', ofile, ' ', option]);   % execute neroAacEnc
    dos([pathstr,'\neroAacEnc >', log_file, ' 2>&1 ', ' -cbr ', bitrate, ' -if ', temp_file, ' -of ', ofile, ' ', option]);   % execute neroAacEnc

    delete(temp_file);
    delete(log_file);
    
else                                                
    if nargin<2 || nargin>4
        error('Unsupported number of input arguments') 
    end

    ifile = varargin{1};                 
    ofile = varargin{2};               

    if nargin>=3
        bitrate = varargin{3}*1000;   
        if isequal(bitrate, [])
            bitrate = 128000;
        end
    else
        bitrate = 128000;                 
    end
    bitrate = num2str(bitrate);

    if nargin>=4
        option = varargin{4};             
    else
        option = [];
    end

    [pathstr, name, ext, versn] = fileparts(which('neroAacEnc.exe'));   
    
    log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];
    
%     dos([pathstr,'\neroAacEnc >/NULL 2>&1 ', ' -cbr ', bitrate, ' -if ', ifile, ' -of ', ofile, ' ', option]);   % execute neroAacEnc
    dos([pathstr,'\neroAacEnc >', log_file, ' 2>&1 ', ' -cbr ', bitrate, ' -if ', ifile, ' -of ', ofile, ' ', option]);   % execute neroAacEnc
    
    delete(log_file);
end

return