% % Audio Signal Processing
% % Peng Zhang      Tsinghua Univ.    2009.02.15
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function  varargout= audioprocess(varargin)

% ---------------------------------------------------------------

function  varargout= audioprocess(varargin)
% % % % % % % % % % % % % % % % % % 
% pick up arguments from inputs
if isnumeric(varargin{1})                    
    if nargin==5 || nargin==6
        ifile = [];                                  
        x = varargin{1};                           
        fs = varargin{2};                         
        nbit = varargin{3};                      
        procname = varargin{4};            
        procparam = varargin{5};           
        if nargin==6
            ofilecfg = varargin{6};              
        else
            ofilecfg = [];
        end
    else
        error('Unsupported number of input arguments for PCM samples input');
    end
elseif ischar(varargin{1}) || iscell(varargin{1}) 
    if nargin==3 || nargin==4
        ifile = varargin{1};
        procname = varargin{2};             
        procparam = varargin{3};            
        if nargin==4
            ofilecfg = varargin{4};
        else
            ofilecfg = [];
        end
    else
        error('Unsupported number of input arguments for wav file input');
    end
else
    error('Input audio must be PCM samples or wav file(s)');
end

if ~iscell(procparam)
    procparam = {procparam};
elseif length(procparam)>2
    error('Too many cell elements for input argument ''procparam''');
end
param_value = procparam{1};

if iscell(ifile)
    multifile = 1;
elseif isempty(ifile)
    multifile = 0;
else                                                        
    ifile = {ifile};
    multifile = 0;
end

% % % % % % % % % % % % % % % % % % 
% generate output file config
if iscell(ofilecfg) && length(ofilecfg)==2
    dest_dir = ofilecfg{1};                      
    ofilename_template = ofilecfg{2};   
    
    if iscell(ifile)
        ofile = cell(size(ifile));
        for ii=1:length(ifile)                        
            ofile{ii} = attacked_filename_gen(ifile{ii}, dest_dir, ofilename_template, param_value);
        end
    else
        ofile{1} = attacked_filename_gen(ifile, dest_dir, ofilename_template, param_value);
        ofile{1} = [ofile{1}, '.wav'];
    end
elseif isempty(ofilecfg)
    ofile = [];
else
    error('Input argument ''ofilecfg'' must be string cell array with two elements');
end

% % % % % % % % % % % % % % % % % % 
% process audio
if isempty(ofilecfg)                    
    if nargout~=3
        error('Unsupported number of output arguments for PCM samples output');
    end
    if isempty(ifile)                      
        [y, yfs, ynbit] = feval(['audioprocess_', lower(procname)], x, fs, nbit, procparam);
    elseif length(ifile)==1            
        [y, yfs, ynbit] = feval(['audioprocess_', lower(procname)], ifile{1}, procparam);
    else                                        
        error('Output file config must be specified with multiple wav files input');
    end
else                                             
    if nargout~=1
        if length(ifile)>1                       
            error('Unsupported number of output arguments for multiple wav files output');
        elseif nargout<3 || nargout>4
            error('Unsupported number of output arguments for wav file output');
        end
    end
    
    if isempty(ifile)                       
        if nargout==1
            feval(['audioprocess_', lower(procname)], x, fs, nbit, procparam, ofile{1});
        else
            [y, yfs, ynbit] = feval(['audioprocess_', lower(procname)], x, fs, nbit, procparam, ofile{1});
        end
    else                                         % wav file(s) input
        if nargout==1 || length(ifile)>1
            for ii=1:length(ifile)
            	feval(['audioprocess_', lower(procname)], ifile{ii}, procparam, ofile{ii});
            end
        else
            [y, yfs, ynbit] = feval(['audioprocess_', lower(procname)], ifile{1}, procparam, ofile{1});
        end
    end    
    if multifile==0
        ofile = ofile{1};
    end           
end

% % % % % % % % % % % % % % % % % %
% generate output arguments
if nargout==1
    varargout{1} = ofile;
else
    varargout{1} = y;
    varargout{2} = yfs;
    varargout{3} = ynbit;
    varargout{4} = ofile;
end
% --- EOF : audioprocess


% ---------------------------------------------------------------
% --- Add white Gaussian noise
% --- Peng Zhang    Tsinghua Univ.    2009.02.14

function varargout = audioprocess_awgn(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
y = awgn(x, param_value, 'measured');
yfs = fs;
ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_awgn
    

% ---------------------------------------------------------------
% --- Amplitude Scaling
% --- Peng Zhang    Tsinghua Univ.    2009.02.15

function varargout = audioprocess_as(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
y = x*10^(param_value/20);
yfs = fs;
ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_as
    
% ---------------------------------------------------------------
% --- Filtering
% --- Peng Zhang    Tsinghua Univ.    2009.02.15

function varargout = audioprocess_filter(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Processing option not specified');
end

% % filter parameter example
% filter_type = 'lpf';
% if strcmpi(filter_type, 'lpf')
%     fcuts = [10, 12]*1e3;             % LPF 
% elseif strcmpi(filter_type, 'bpf')
%     fcuts = [3, 5, 8, 10]*1e3;      % BPF
% elseif strcmpi(filter_type, 'hpf')
%     fcuts = [8, 10]*1e3;               % HPF
% end
% % end of example

filter_type = param_option;
fcuts = param_value*1e3;    % cutoff frequencies in Hz
Astop = -40;                           % stopband attenuation in dB
Rpass = 0.05;                        % passband ripple
h = kaiser_fir(fcuts, fs, Rpass, Astop, filter_type);       % Kaiser FIR filter design
% [a,freq] = freqz(h);figure; plot(freq/pi*fs/2/1e3,20*log10(abs(a))); grid;xlim([0 fs/2/1e3]);xlabel('Frequency (kHz)');

y = filter(h, 1, x);            % filtering
yfs = fs;
ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_filter

% ---------------------------------------------------------------
% --- MP3 Compression
% --- Peng Zhang    Tsinghua Univ.    2009.02.16

function varargout = audioprocess_mp3(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
%     [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Processing option not specified');
end
bitrate = param_value;
if strcmpi(param_option, 'lame')
    if isempty(ofile)
        tempmp3 = ['tempmp3_', datestr(clock,'yyyymmddTHHMMSS')];
        ofile_mp3 = fullfile(cd, [tempmp3, '.mp3']);
        ofile_wav = fullfile(cd, [tempmp3, '.wav']);
    else
        ofile_wav = ofile;
        [pathstr, name, ext, versn] = fileparts(ofile_wav);
        ofile_mp3 = fullfile(pathstr, [name, '.mp3']);
    end
        
    if isempty(ifile)                   % input from workspace
        mp3write(x, fs, nbit, ofile_mp3, bitrate);
    else                                    % input from wav file
        mp3write(ifile, ofile_mp3, bitrate);        
    end
    [y, yfs, ynbit] = mp3read(ofile_mp3);
    
    if isempty(ofile) 
        delete(ofile_mp3);
    else       
        wavwrite(y, yfs, ynbit, ofile_wav);
    end
else            % reserved for other MP3 codec
    error('Option must be ''lame''.');
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_mp3

% ---------------------------------------------------------------
% --- AAC Compression
% --- Peng Zhang    Tsinghua Univ.    2009.02.16

function varargout = audioprocess_aac(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
%     [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Processing option not specified');
end
bitrate = param_value;

if isempty(ofile)
    tempaac = ['tempaac_', datestr(clock,'yyyymmddTHHMMSS')];
    ofile_aac = fullfile(cd, [tempaac, '.aac']);
    ofile_wav = fullfile(cd, [tempaac, '.wav']);
else
    ofile_wav = ofile;
    [pathstr, name, ext, versn] = fileparts(ofile_wav);
    ofile_aac = fullfile(pathstr, [name, '.aac']);
end

if strcmpi(param_option, 'faac')                   % FAAC/FAAD
    if isempty(ifile)                   % input from workspace
        faacwrite(x, fs, nbit, ofile_aac, bitrate);
    else                                     % input from wav file
        faacwrite(ifile, ofile_aac, bitrate);   
    end
    [y, yfs, ynbit] = faacread(ofile_aac);

elseif strcmpi(param_option, 'nero')            % Nero-AAC
    if isempty(ifile)                   % input from workspace
        neroaacwrite(x, fs, nbit, ofile_aac, bitrate);
    else                                     % input from wav file
        neroaacwrite(ifile, ofile_aac, bitrate);        
    end
    [y, yfs, ynbit] = neroaacread(ofile_aac);
    
else            % reserved for other AAC codec
    error('Option must be ''faac'' or ''nero''.');
end

if isempty(ofile)
    delete(ofile_aac);
else       
    wavwrite(y, yfs, ynbit, ofile_wav);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_aac

% ---------------------------------------------------------------
% --- Resampling
% --- Peng Zhang    Tsinghua Univ.    2009.02.17

function varargout = audioprocess_resamp(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
    if isempty(param_option)
        param_option = 'recover';               % input []
    end
else
    param_option = 'norecover';               % no option input
end

fs_new = param_value*1e3;                   % new sampling rate in Hz
x_new = resample(x, fs_new, fs);           % resampling to target sampling rate

if strcmpi(param_option, 'norecover')
    y = x_new;
    yfs = fs_new;
elseif strcmpi(param_option, 'recover')
    y = resample(x_new, fs, fs_new);        % resampling to original sampling rate
    yfs = fs;
else
    error('Option must be ''recover'' or ''norecover''.');
end

ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_resamp

% ---------------------------------------------------------------
% --- Echo
% --- Peng Zhang    Tsinghua Univ.    2009.02.17

function varargout = audioprocess_echo(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
% if length(param)==2
%     param_option =  param{2};
% else
% end

ini_vol = param_value(1);              % initial volume in dB
delay = param_value(2);                % delay in ms
attenuation = param_value(3);      % volume attenuation in dB

if ini_vol>0
    error('Initial volume of echo must be no larger than 0 dB.');
elseif attenuation>0
    error('Volume attenuation of echos must be no larger than 0 dB.');
end

audiable_atten = -60;                      % maximum audiable attenuation

if attenuation< -1
    num_audiable_echo = max(0, ceil((audiable_atten-ini_vol)/attenuation));
else
    num_audiable_echo = ceil((audiable_atten-ini_vol)/-1);
end

ini_vol = 10^(ini_vol/20);                      % initial volume
delay = delay*1e-3;                              % delay in second
attenuation = 10^(attenuation/20);      % volume attenuation

num_echo = min(ceil(length(x)/fs/delay)-1, num_audiable_echo);

len_delay = round(fs*delay);

echo_sig = x;
total_echo = zeros(size(x));
for ii=1:num_echo
    echo_sig(ii*len_delay+1:end,:) = echo_sig((ii-1)*len_delay+1:end-len_delay,:)*attenuation;
    echo_sig(1:ii*len_delay,:) = 0;
    total_echo = total_echo+echo_sig;
end
y = x+total_echo*ini_vol;

yfs = fs;
ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_echo

% ---------------------------------------------------------------
% --- Cropping
% --- Peng Zhang    Tsinghua Univ.    2009.02.17

function varargout = audioprocess_crop(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Option must be ''random'' or ''burst''.');
end

ntotal = param_value(1);    % number of samples per segment
ncrop = param_value(2);   % remove ncrop samples every ntotal samples periodically

nseg = floor(length(x)/ntotal);     % number of segments
nres = ntotal-ncrop;                    % residual samples per segment
y = zeros(nseg*nres, size(x,2));
for ii=1:nseg
    temp_x = x((ii-1)*ntotal+1:ii*ntotal, :);
    shift = randint(1,1,[0 ntotal-1]);
    pattern = errpattern(ntotal, ncrop, shift, param_option);     % cropping pattern
    y((ii-1)*nres+1:ii*nres, :) = temp_x(find(pattern==0), :);      % cropped segment
end
xres = x(nseg*ntotal+1:end, :);         %  residual uncropped samples
shift = randint(1,1,[0 ntotal-1]);
pattern = errpattern(ntotal, ncrop, shift, param_option); 
xres(find(pattern(1:length(x)-nseg*ntotal)==1), :) = [];
y = [y; xres];

yfs = fs;
ynbit = nbit;
if ~isempty(ofile)   
    wavwrite(y, yfs, ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_crop

% ---------------------------------------------------------------
% --- Time Scale Modification
% --- Peng Zhang    Tsinghua Univ.    2009.02.18

function varargout = audioprocess_tsm(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
%     [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Option must be ''pvoc'' or ''wsola''.');
end

% time stretch ratio; >1 for time stretch (playback slow down), 
% and <1 for time compression (playback speed up), 
ratio = param_value(1);            

if strcmpi(param_option, 'pvoc')                   % TSM using Phase Vocoder
    if ~isempty(ifile)
        [x, fs, nbit] = wavread(ifile);                    % read WAV file
    end
    y = tsm_pvoc(x, ratio);
    yfs = fs;
    ynbit = nbit;
    if ~isempty(ofile)   
        wavwrite(y, yfs, ynbit, ofile);
    end
elseif strcmpi(param_option, 'wsola')           % TSM using WSOLA
    if isempty(ifile)                                           % temporary intput wav file
        ifilewav = fullfile(cd, ['tempifile_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']);
        wavwrite(x, fs, nbit, ifilewav);
    else
        ifilewav = ifile;
    end
    if isempty(ofile)                                            % temporary output wav file
        ofilewav = fullfile(cd, ['tempofile_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']);
    else
        ofilewav = ofile;
    end
        
    [pathstr, name, ext, versn] = fileparts(which('WSOLA.v3.exe'));    % locate WSOLA.exe  

    dos([pathstr,'\WSOLA.v3 ', ifilewav, ' ', ofilewav, ' ', num2str(ratio)]); % execute WSOLA
    [y, yfs, ynbit] = wavread(ofilewav);
    if isempty(ifile)
        delete(ifilewav);
    end
    if isempty(ofile)         
        delete(ofilewav);
    end
      
else            % reserved for other TSM methods
    error('Option must be ''pvoc'' or ''wsola''.');
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_tsm

% ---------------------------------------------------------------
% --- Pitch Shifting
% --- Peng Zhang    Tsinghua Univ.    2009.02.18

function varargout = audioprocess_ps(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
%     [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
if length(param)==2
    param_option =  param{2};
else
    error('Option must be ''pvoc'' or ''wsola''.');
end

% time stretch ratio; >1 for time stretch (playback slow down), 
% and <1 for time compression (playback speed up), 
ratio = param_value(1);            

if strcmpi(param_option, 'pvoc')                   % TSM using Phase Vocoder
    if ~isempty(ifile)
        [x, fs, nbit] = wavread(ifile);                    % read WAV file
    end
    y = tsm_pvoc(x, ratio);
%     y = resample(y, length(x),length(y));          % resample
    y = resample(y, 1e3, round(1e3*ratio));          % resample
    
    yfs = fs;
    ynbit = nbit;
    if ~isempty(ofile)   
        wavwrite(y, yfs, ynbit, ofile);
    end
elseif strcmpi(param_option, 'wsola')           % TSM using WSOLA
    if isempty(ifile)                                           % temporary intput wav file
        ifilewav = fullfile(cd, ['tempifile_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']);
        wavwrite(x, fs, nbit, ifilewav);
    else
        ifilewav = ifile;
    end
    if isempty(ofile)                                            % temporary output wav file
        ofilewav = fullfile(cd, ['tempofile_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']);
    else
        ofilewav = ofile;
    end
        
    [pathstr, name, ext, versn] = fileparts(which('WSOLA.v3.exe'));    % locate WSOLA.exe  

    dos([pathstr,'\WSOLA.v3 ', ifilewav, ' ', ofilewav, ' ', num2str(ratio)]); % execute WSOLA
    [y, yfs, ynbit] = wavread(ofilewav);

    y = resample(y, 1e3, round(1e3*ratio));          % resample
    
    if isempty(ifile)
        delete(ifilewav);
    end
    if isempty(ofile)         
        delete(ofilewav);
    else
        wavwrite(y, yfs, ynbit, ofile);
    end
      
else            % reserved for other PS methods
    error('Option must be ''pvoc'' or ''wsola''.');
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_ps

% ---------------------------------------------------------------
% --- Requantization
% --- Peng Zhang    Tsinghua Univ.    2009.05.19

function varargout = audioprocess_requantz(varargin)

% pick up input arguments
if isnumeric(varargin{1})                   % input from workspace
    x = varargin{1};                              % input PCM samples
    fs = varargin{2};                             % sampling frequency
    nbit = varargin{3};                          % number of bits per sample
    param = varargin{4};                     % processing parameters and options
    ifile = [];
    if nargin==5
        ofile = varargin{5};                     % output directory and filename template
    else
        ofile = [];
    end    
elseif ischar(varargin{1})                  % input from WAV file
    ifile = varargin{1};
    [x, fs, nbit] = wavread(ifile);           % read WAV file
    param = varargin{2};                     % processing parameters and options
    if nargin==3
        ofile = varargin{3};                     % output directory and filename template
    else 
        ofile = [];
    end
end

% process audio signal
param_value = param{1};
yfs = fs;
ynbit = param_value;

if ynbit<1 || ynbit~=ceil(ynbit)
    error('Number of requantization bits must be a positive integer.');
end
if ynbit>32
    warning('Number of requantization bits is too large. Use 32-bit instead.');
    ynbit = 32;
end

y = x*2^(nbit-1); 
y = floor(y/2^(nbit-ynbit))/2^(ynbit-1);

if ~isempty(ofile)
    if ynbit==8 || ynbit==16 || ynbit==24 || ynbit==32
        supported_ynbit = ynbit;
    else                               % find the least supported nbit that is no less than target nbit
        if ynbit<8
            supported_ynbit = 8;
            warning('Unsupported number of bits specified. Use 8-bit when writing to wav file.');
        elseif ynbit<16
            supported_ynbit = 16;
            warning('Unsupported number of bits specified. Use 16-bit when writing to wav file.');
        elseif ynbit<24
            supported_ynbit = 24;
            warning('Unsupported number of bits specified. Use 24-bit when writing to wav file.');
        elseif ynbit<32
            supported_ynbit = 32;
            warning('Unsupported number of bits specified. Use 32-bit when writing to wav file.');
        end
    end
    wavwrite(y, yfs, supported_ynbit, ofile);
end

% output
varargout{1} = y;
varargout{2} = yfs;
varargout{3} = ynbit;

% --- EOF : audioprocess_requantz


% % invoke stirmark
% [pathstr, name, ext, versn] = fileparts(which('stirmarkaudio.exe'));    % locate stirmarkaudio.exe
% if isempty(ifile)
%     src_file = fullfile(cd, ['tempsrc_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']); % temporary source file
% else
%     src_file = ifile;
% end
% if isempty(ofile)
%     dest_file = fullfile(cd, ['tempdest_', datestr(clock,'yyyymmddTHHMMSS'), '.wav']); % temporary destination file
% else
%     dest_file = ofile;
% end
% temp_cfgfile = fullfile(cd, ['tempcfg_', datestr(clock,'yyyymmddTHHMMSS'), '.cfg']); % temporary config file
% fid = fopen(temp_cfgfile, 'w');         % write temporary config file for stirmark
% fprintf(fid, 'SampleRate = %f\n', fs_new);
% fclose(fid);
% dos([pathstr,'\stirmarkaudio -q -p ', temp_cfgfile, ' -i ', src_file, ' -w ', 'a.wav']);   % execute stirmark
% if isempty(ifile)
%     delete(src_file);
% end
% if isempty(ofile)
%     [y, yfs, ynbit] = wavread(dest_file);
%     delete(dest_file);
% end
% % end of invoke stirmark