% % Write AAC file
% % Zhang Peng    Tsinghua Univ.    2009.01.07
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function faacwrite(varargin)
% 
% ---------------------------------------------------------------

function faacwrite(varargin)

if ~ischar(varargin{1})        
    if nargin<4 || nargin>6
        error('Unsupported number of input arguments') 
    end

    y = varargin{1};                
    fs = varargin{2};       
    nbit = varargin{3};   
    ofile = varargin{4};                      

    default_abr = 128;                       
    if nargin>5
        bitrate = varargin{5};               
    elseif nargin==5
        if isequal(varargin{5}, [])
            bitrate = default_abr;           
        else
            bitrate = varargin{5};
        end
    else
        bitrate = default_abr;
    end
    bitrate = num2str(bitrate);

    if nargin>=6
        if isequal(bitrate, [])
            option = varargin{6};         
        else
            option = [' -b ', bitrate, ' ', varargin{6}];
        end
    else
        option = [' -b ', bitrate];
    end

    [pathstr, name, ext, versn] = fileparts(which('faac.exe'));  

    temp_file = fullfile(pathstr,'temp.wav');             

    wavwrite(y, fs, nbit, temp_file);
    
    log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];
    
%     dos([pathstr,'\faac >/NULL 2>&1 ', temp_file, ' -o ', ofile, ' ', option]);       
    dos([pathstr,'\faac >', log_file, ' 2>&1 ', temp_file, ' -o ', ofile, ' ', option]);
    
    delete(temp_file);
    delete(log_file);
else                                               
    if nargin<2 || nargin>4
        error('Unsupported number of input arguments') 
    end

    ifile = varargin{1};                 
    ofile = varargin{2};                 

    default_abr = 128;                  
    if nargin>3
        bitrate = varargin{3};          
    elseif nargin==3
        if isequal(varargin{3}, [])
            bitrate = default_abr;       
        else
            bitrate = varargin{3};
        end
    else
        bitrate = default_abr;
    end
    bitrate = num2str(bitrate);

    if nargin>=4
        if isequal(bitrate, [])
            option = varargin{4};               
        else
            option = [' -b ', bitrate, ' ', varargin{4}];
        end
    else
        option = [' -b ', bitrate];
    end
    
    [pathstr, name, ext, versn] = fileparts(which('faac.exe'));  
    
    log_file = ['templog', datestr(now, 'yyyymmddTHHMMSS')];
    
%     dos([pathstr,'\faac >/NULL 2>&1 ', ifile, ' -o ', ofile, ' ', option]);               
    dos([pathstr,'\faac >', log_file, ' 2>&1 ', ifile, ' -o ', ofile, ' ', option]);  
    
    delete(log_file);
end

return