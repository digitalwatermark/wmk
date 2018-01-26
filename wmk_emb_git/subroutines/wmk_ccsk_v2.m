
function varargout = wmk_ccsk_v2(varargin)

if strcmpi(varargin{end}, 'embed')
    if ischar(varargin{1})                       % file input
        [x, fs, nbit] = wavread(varargin{1}, 'double');
        x = single(x);
        
        wmk = varargin{2};
        key = varargin{3};
        if nargin==6
            cover_filename = varargin{4};
            stego_filename = varargin{5};
        elseif nargin==4
            cover_filename = [];
            stego_filename = [];
        else
            error('Unsupported number of input arguments for embeding in wav file.');
        end
    else                                                    % PCM samples input
        x = varargin{1};
        fs = varargin{2};
        nbit = varargin{3};
        wmk = varargin{4};
        key = varargin{5};
        if nargin==8
            cover_filename = varargin{6};
            stego_filename = varargin{7};
        elseif nargin==6
            cover_filename = [];
            stego_filename = [];
        else
            error('Unsupported number of input arguments for embeding in PCM vector.');
        end
    end
        
    [wmk_embed, cover_pcm, stego_pcm, param] = wmk_core_ccsk_v2(x, fs, nbit, wmk, key, 'embed');

    warning off
    data_class = class(cover_pcm);
    if ~isempty(cover_filename)
        if strcmpi(data_class, 'single') || strcmpi(data_class, 'double')
            wavwrite(cover_pcm, fs, nbit, cover_filename);
        elseif strcmpi(data_class, 'int16');      % 16-bit
            wavwrite(double(cover_pcm)/32768, fs, nbit, cover_filename);
        elseif strcmpi(data_class, 'uint8');      % 8-bit
            wavwrite(double(cover_pcm)/128-1, fs, nbit, cover_filename);
        elseif strcmpi(data_class, 'int32');      % 24-bit
            wavwrite(double(cover_pcm)/2^23, fs, nbit, cover_filename);      
        else
            error('Unsupported data type.');
        end       
    end
    
    data_class = class(stego_pcm);
    if ~isempty(stego_filename)
        if strcmpi(data_class, 'single') || strcmpi(data_class, 'double')
            wavwrite(stego_pcm, fs, nbit, stego_filename);
        elseif strcmpi(data_class, 'int16');      % 16-bit
            wavwrite(double(stego_pcm)/32768, fs, nbit, stego_filename);
        elseif strcmpi(data_class, 'uint8');      % 8-bit
            wavwrite(double(stego_pcm)/128-1, fs, nbit, stego_filename);
        elseif strcmpi(data_class, 'int32');      % 24-bit
            wavwrite(double(stego_pcm)/2^23, fs, nbit, stego_filename);        
        else
            error('Unsupported data type.');
        end 
    end
    warning on
    
    varargout{1} = wmk_embed;
    varargout{2} = cover_pcm;
    varargout{3} = stego_pcm;
    varargout{4} = param;
    
elseif strcmpi(varargin{end}, 'extract')
    if ischar(varargin{1})                       % file input
        [x, fs, nbit] = wavread(varargin{1}, 'double');
        x = single(x);
        
        key = varargin{2};
        if nargin~=3
            error('Unsupported number of input arguments for extracting from wav file.');
        end
    else                                                    % PCM samples input
        x = varargin{1};
        fs = varargin{2};
        nbit = varargin{3};
        key = varargin{4};
        if nargin~=5
            error('Unsupported number of input arguments for extracting from PCM vector.');
        end
    end

    [wmk_extract, param] = wmk_core_ccsk_v2(x, fs, nbit, [], key, 'extract');
    
    varargout{1} = wmk_extract;
    varargout{2} = param;
else
    error('Type must be ''embed'' or ''extract''.');
end
     