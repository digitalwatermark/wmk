% % Real-time Watermark Extractor (GUI)
% % Peng Zhang   Tsinghua Univ.    2011.4.4
% % % % % % % % % % % % % % % % % % % 

function varargout = realtime_extractor_gui(varargin)
% REALTIME_EXTRACTOR_GUI M-file for realtime_extractor_gui.fig
%      REALTIME_EXTRACTOR_GUI, by itself, creates a new REALTIME_EXTRACTOR_GUI or raises the existing
%      singleton*.
%
%      H = REALTIME_EXTRACTOR_GUI returns the handle to a new REALTIME_EXTRACTOR_GUI or the handle to
%      the existing singleton*.
%
%      REALTIME_EXTRACTOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIME_EXTRACTOR_GUI.M with the given input arguments.
%
%      REALTIME_EXTRACTOR_GUI('Property','Value',...) creates a new REALTIME_EXTRACTOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before realtime_extractor_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to realtime_extractor_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help realtime_extractor_gui

% Last Modified by GUIDE v2.5 03-Nov-2017 17:08:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @realtime_extractor_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @realtime_extractor_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before realtime_extractor_gui is made visible.
function realtime_extractor_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to realtime_extractor_gui (see VARARGIN)

% Choose default command line output for realtime_extractor_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes realtime_extractor_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear all;
globalvar_realtime_wmkextractor;

% Default parameters
AD_Polar = -1;          %1/-1; -1 for notebook Dell D830
Fs = 44100;
Input_Gain = 1;         % [0, inf)

Key = 0;
Sync_Word = '0d';
Wmk_Format = 'text';          % 'text' or 'bin'
Bit_Format = 'bin';
N_CharPerLine = 16;
Phone_Enable = 0;   % 0/1
readfileID=0;

Plot_Enable = [1 1];
BER_Enable = 0;
ReadInital=0;
Wmk_Type = 'detectable';    % extractable or detectable
Nrow_TableHeader = 1;
Nframe_SoundDelay = 2;

% not adjustable via GUI
DA_Polar = 1;
Len_SinkBit_Buffer = 1e5;
Nframes_Rx_Buffer = 3;
Hplot = [findobj('tag', 'axes_wavform'); findobj('tag', 'axes_psd'); ...
              findobj('tag', 'axes_corr'); findobj('tag', 'listbox_decoded_wmk'); ...
              findobj('tag', 'text_ber'); findobj('tag', 'text_nerr'); ...
              findobj('tag', 'text_ntot'); findobj('tag', 'text_wmk_status');...
              findobj('tag', 'slider_wavfile')];
          
% display parameters
set(findobj('tag', 'edit_emb_key'), 'string', num2str(Key));
set(findobj('tag', 'edit_input_gain'), 'string', num2str(Input_Gain));
set(findobj('tag', 'edit_wmk'), 'string', {''});   % ensure the string gotten to be a string cell (default is char array)
set(findobj('tag', 'edit_syncword'), 'string', Sync_Word);
set(findobj('tag', 'edit_disp_ncol'), 'string', num2str(N_CharPerLine));
if strcmpi(Bit_Format, 'hex')
    set(findobj('tag', 'popupmenu_disp_format'), 'value', 2);
else
    set(findobj('tag', 'popupmenu_disp_format'), 'value', 1);
end

if AD_Polar==1
    set(findobj('tag', 'popupmenu_adpolar'), 'value', 1);
elseif AD_Polar==-1
    set(findobj('tag', 'popupmenu_adpolar'), 'value', 2);
else
    error('A/D polar error.');
end

if Fs==48000
    set(findobj('tag', 'popupmenu_fs'), 'value', 1);
elseif Fs==44100
    set(findobj('tag', 'popupmenu_fs'), 'value', 2);
elseif Fs==32000
    set(findobj('tag', 'popupmenu_fs'), 'value', 3);
else
    error('Unsupported sampling frequency');
end

if strcmpi(Wmk_Format, 'text')
    set(findobj('tag', 'radiobutton_textwmk'), 'value', 1);
    set(findobj('tag', 'edit_syncword'), 'enable', 'on');
    set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'off');
    set(findobj('tag', 'edit_disp_ncol'), 'enable', 'off');    
elseif strcmpi(Wmk_Format, 'bin')
    set(findobj('tag', 'radiobutton_binwmk'), 'value', 1);
    set(findobj('tag', 'edit_syncword'), 'enable', 'off');
    set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'on');
    set(findobj('tag', 'edit_disp_ncol'), 'enable', 'on');    
elseif strcmpi(Wmk_Format, 'mat')
    set(findobj('tag', 'radiobutton_matwmk'), 'value', 1);
    set(findobj('tag', 'edit_syncword'), 'enable', 'off');
    set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'on');
    set(findobj('tag', 'edit_disp_ncol'), 'enable', 'on');
else
    error('Watermark type error.');
end

%  set(findobj('tag', 'checkbox_phone_on'), 'value', Phone_Enable);
% set(findobj('tag', 'checkbox_readfile_on'), 'value',Readfile_Enable);

set(findobj('tag', 'checkbox_pause_hplot1'), 'value', ~Plot_Enable(1));
set(findobj('tag', 'checkbox_pause_hplot2'), 'value', ~Plot_Enable(2));
set(findobj('tag', 'togglebutton_ber'), 'value', BER_Enable);
set(findobj('tag', 'togglebutton_ber'), 'enable', 'off');


h1 = findobj('tag', 'axes_wavform');
h2 = findobj('tag', 'axes_psd');
h3 = findobj('tag', 'axes_corr');
h4 = findobj('tag', 'listbox_decoded_wmk');
title(h1, 'Acquired Samples');
ylabel(h1, 'Amplitude');
title(h2, 'Power Spectrum');
xlabel(h2, 'Frequency (kHz)');
ylabel(h2, 'Power (dB)');
xlim(h2, [0 Fs/2/1000]);
title(h3, 'Normalized Cross Correlation');
ylabel(h3, 'Amplitude');
xlabel(h3, 'Sample Offset');
ylim(h3, [0, 1]);
set(h4, 'fontsize', 8, 'fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [1 1 1]);
set(h4, 'callback', 'copywmk_callback');

proc_changemode(Wmk_Type);


% --- Outputs from this function are returned to the command line.
function varargout = realtime_extractor_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
if ~isempty(Ai) || ~isempty(Ao)    
    stop([Ai, Ao]);
    delete([Ai, Ao]);
    clear Ao Ai
end

% --- Executes on button press in radiobutton_textwmk.
function radiobutton_textwmk_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_textwmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_textwmk
globalvar_realtime_wmkextractor;
set(gcbo, 'value', 1);
set(findobj('tag', 'edit_syncword'), 'enable', 'on');
set(findobj('tag', 'edit_disp_ncol'), 'enable', 'off');
set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'off');
if ~strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Text = bit2text(Ref_Wmk_Bit, Sync_Word);
    set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);       
    
    bitvec = SinkBit_Buffer(Start_SinkWord : WP_SinkBit_Buffer-1); 
    Rx_String = bit2text(bitvec, Sync_Word);       
    set(findobj('tag', 'listbox_decoded_wmk'), 'string', [Str_Buffer; Rx_String]);
    set(findobj('tag', 'listbox_decoded_wmk'), 'value', length([Str_Buffer; Rx_String]));        
end
Wmk_Format = 'text';

% --- Executes on button press in radiobutton_binwmk.
function radiobutton_binwmk_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_binwmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_binwmk
globalvar_realtime_wmkextractor;
set(gcbo, 'value', 1);
set(findobj('tag', 'edit_syncword'), 'enable', 'off');
set(findobj('tag', 'edit_disp_ncol'), 'enable', 'on');
set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'on');
if strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);
    
    bitvec = SinkBit_Buffer(Start_SinkWord : WP_SinkBit_Buffer-1);
    Rx_String = bit2strcell(bitvec, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'listbox_decoded_wmk'), 'string', [Str_Buffer; Rx_String]);
    set(findobj('tag', 'listbox_decoded_wmk'), 'value', length([Str_Buffer; Rx_String]));    
end
Wmk_Format = 'bin';

% --- Executes on button press in radiobutton_matwmk.
function radiobutton_matwmk_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_matwmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_matwmk
globalvar_realtime_wmkextractor;
set(gcbo, 'value', 1);
set(findobj('tag', 'edit_syncword'), 'enable', 'off');
set(findobj('tag', 'edit_disp_ncol'), 'enable', 'on');
set(findobj('tag', 'popupmenu_disp_format'), 'enable', 'on');
if strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);
    
    bitvec = SinkBit_Buffer(Start_SinkWord : WP_SinkBit_Buffer-1);
    Rx_String = bit2strcell(bitvec, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'listbox_decoded_wmk'), 'string', [Str_Buffer; Rx_String]);
    set(findobj('tag', 'listbox_decoded_wmk'), 'value', length([Str_Buffer; Rx_String]));        
end
Wmk_Format = 'mat';

% --- Executes on selection change in popupmenu_adpolar.
function popupmenu_adpolar_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_adpolar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_adpolar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_adpolar
globalvar_realtime_wmkextractor;
index = get(gcbo, 'value');
str = get(gcbo, 'string');
AD_Polar = str2num(str{index});

% --- Executes during object creation, after setting all properties.
function popupmenu_adpolar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_adpolar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_fs.
function popupmenu_fs_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_fs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_fs
globalvar_realtime_wmkextractor;
index = get(gcbo, 'value');
str = get(gcbo, 'string');
Fs = str2num(str{index})*1000;

if ~isempty(Ai)
    running = isrunning(Ai);
    init_snddev();
    if running
        start([Ai Ao]);
        trigger([Ai Ao]);
    end
end

% --- Executes during object creation, after setting all properties.
function popupmenu_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_emb_key_Callback(hObject, eventdata, handles)
% hObject    handle to edit_emb_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_emb_key as text
%        str2double(get(hObject,'String')) returns contents of edit_emb_key as a double
globalvar_realtime_wmkextractor;
Key = str2num(get(gcbo, 'string'));

% --- Executes during object creation, after setting all properties.
function edit_emb_key_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_emb_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_input_gain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_input_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_input_gain as text
%        str2double(get(hObject,'String')) returns contents of edit_input_gain as a double
globalvar_realtime_wmkextractor;
Input_Gain = str2num(get(gcbo, 'string'));

% --- Executes during object creation, after setting all properties.
function edit_input_gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_input_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_syncword_Callback(hObject, eventdata, handles)
% hObject    handle to edit_syncword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_syncword as text
%        str2double(get(hObject,'String')) returns contents of edit_syncword as a double
globalvar_realtime_wmkextractor;
Sync_Word = get(gcbo, 'string');
Ref_Wmk_Bit = text2bit(Ref_Wmk_Text, Sync_Word);


% --- Executes during object creation, after setting all properties.
function edit_syncword_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_syncword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_disp_ncol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disp_ncol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disp_ncol as text
%        str2double(get(hObject,'String')) returns contents of edit_disp_ncol as a double
globalvar_realtime_wmkextractor;
N_CharPerLine = str2num(get(gcbo, 'string'));
if ~strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);
end

% --- Executes during object creation, after setting all properties.
function edit_disp_ncol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disp_ncol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_disp_format.
function popupmenu_disp_format_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_disp_format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_disp_format contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_disp_format
globalvar_realtime_wmkextractor;
index = get(gcbo, 'value');
str = get(gcbo, 'string');
Bit_Format = str{index};
if ~strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);
    set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);
end

% --- Executes during object creation, after setting all properties.
function popupmenu_disp_format_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_disp_format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%{
% --- Executes on button press in pushbutton_sel_src_au.
function pushbutton_sel_src_au_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sel_src_au (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;

[filename, pathname] = uigetfile('*.wav', 'multiselect', 'on');

if isnumeric(filename)               % click 'cancel'
    return
end
if ~iscell(filename)                             % for single file input, filename is a string
    filename = {filename};
end
filename = sort(filename);      % sort the strings in ASCII dictionary order.
Files_Wav = cell(size(filename));
for ii=1:length(filename)                   % for multiple-file input, filename is a cell array
    Files_Wav{ii} = fullfile(pathname, filename{ii});
end
set(findobj('tag', 'src_audio_list'), 'string', filename);
Selected_Wav_Index = 1:length(filename);
set(findobj('tag', 'src_audio_list'), 'value', Selected_Wav_Index);
Current_Wav_Index = Selected_Wav_Index(1);
Current_Sample_Index = 1;
%}

% --- Executes on button press in pushbutton_sel_wmkfile.
function pushbutton_sel_wmkfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sel_wmkfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
max_lineread = 1e3;     % max number of lines to read (text)
max_byteread = 1e3;   % max number of bytes to read (bin)

if strcmpi(Wmk_Format, 'text')
    [filename, pathname] = uigetfile('*.txt', 'multiselect', 'off');
    if isnumeric(filename)               % click 'cancel'
        return
    end
    Files_Watermark = fullfile(pathname, filename);
    [Ref_Wmk_Bit, syncbit, Ref_Wmk_Text] = text2bit(Files_Watermark, Sync_Word, '', max_lineread);
    
elseif strcmpi(Wmk_Format, 'bin')
    [filename, pathname] = uigetfile('*.*', 'multiselect', 'off');
    if isnumeric(filename)               % click 'cancel'
        return
    end   
    Files_Watermark = fullfile(pathname, filename);    
    fid = fopen(Files_Watermark, 'r');
    dec8bit = fread(fid, max_byteread, '*uint8')';
    fclose(fid);
%     str = dec2hex(dec8bit, 2);      % display hex
% %     str = dec2bin(dec8bit, 8);       %display bin
%     Ref_Wmk_Text = mat2cell(str, ones(size(str,1),1), size(str,2));
   
    Ref_Wmk_Bit = dec2binstream(dec8bit, 8, 'msb');
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);
    
elseif strcmpi(Wmk_Format, 'mat')
    [filename, pathname] = uigetfile('*.mat', 'multiselect', 'off');
    if isnumeric(filename)               % click 'cancel'
        return
    end   
    Files_Watermark = fullfile(pathname, filename);    
    vars = whos('-file', Files_Watermark);
    if length(vars)~=1
        errordlg('Watermark file (*.mat) must contain one and only one variable.');
        return
    end
    load(Files_Watermark);
    var_name = vars(1).name;
     
    Ref_Wmk_Bit = eval(var_name);
    Ref_Wmk_Bit = Ref_Wmk_Bit(1:min(max_byteread*8, size(Ref_Wmk_Bit, 1)), :);
    nbyte_ch = ceil(size(Ref_Wmk_Bit, 1)/8);
    nchan = size(Ref_Wmk_Bit, 2);
    Ref_Wmk_Bit = [Ref_Wmk_Bit; zeros(nbyte_ch*8-size(Ref_Wmk_Bit, 1), nchan)];       % pad zeros

%     if nchan ==2
%         temp = reshape(Ref_Wmk_Bit(:), 8, nbyte_ch*nchan);
%         temp = [temp(:, 1:end/2); temp(:, end/2+1:end)];
%         temp = temp(:);
%     else
%         temp = Ref_Wmk_Bit(:);
%     end
%     dec8bit = binstream2dec(temp, 8*nchan, 'msb');
%     str = dec2hex(dec8bit, 2*nchan);      % display hex
% %     str = dec2bin(dec8bit, 8);       %display bin
%     Ref_Wmk_Text = mat2cell(str, ones(size(str,1),1), size(str,2));
    
    Ref_Wmk_Bit = Ref_Wmk_Bit(:);
    Ref_Wmk_Text = bit2strcell(Ref_Wmk_Bit, N_CharPerLine, Bit_Format);        
end

set(findobj('tag', 'edit_wmk'), 'string', Ref_Wmk_Text);
if ~isempty(Ref_Wmk_Bit)
    set(findobj('tag', 'togglebutton_ber'), 'enable', 'on');
end
% Current_Bit_Index = 1;

function edit_wmk_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wmk as text
%        str2double(get(hObject,'String')) returns contents of edit_wmk as a double
globalvar_realtime_wmkextractor;
Ref_Wmk_Text = get(gcbo, 'string');
if isempty(Ref_Wmk_Text{1})
    Ref_Wmk_Bit = [];
    set(findobj('tag', 'togglebutton_ber'), 'enable', 'off');
    BER_Enable = 0;
    set(findobj('tag', 'togglebutton_ber'), 'value', 0);
    return   
else
    set(findobj('tag', 'togglebutton_ber'), 'enable', 'on');
end

if strcmpi(Wmk_Format, 'text')
    Ref_Wmk_Bit = text2bit(Ref_Wmk_Text, Sync_Word);
%     bit2text(Ref_Wmk_Bit, Sync_Word)
elseif strcmpi(Wmk_Format, 'bin') || strcmpi(Wmk_Format, 'mat')   
%     temp = cell2mat(Ref_Wmk_Text);                % hex
%     nchan = size(temp, 2)/2;
%     if nchan==2                                              % dec
%         temp = [hex2dec(temp(1:end, 1:2)), hex2dec(temp(1:end, 3:4))];        
%     else
%         temp = hex2dec(temp);
%     end
%     temp = dec2binstream(temp, 8, 'msb'); % bin
%     Ref_Wmk_Bit = reshape(temp, length(temp)/nchan, nchan);

    Ref_Wmk_Bit = strcell2bit(Ref_Wmk_Text, Bit_Format);
end


% --- Executes during object creation, after setting all properties.
function edit_wmk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;

% get default parameters
[wmk_temp, Algorithm_Param] = wmk_core_ccsk_v2(0, Fs, [], [], Key, 'extract');

% load parameters from config file (override default)
if ~isempty(Files_Config) 
    if exist(Files_Config)==2  % use input parameters
        % read algorithm parameters from config file and override default values    
        var_name = readeval(Files_Config);    % read configs for algorithm parameters      
        for ii=1:length(var_name)           % assign parameter values
            eval(['Algorithm_Param.', var_name{ii}, ' = ', var_name{ii}, ';']);
        end
    else
        errordlg([Files_Config, ' does not exist.', sprintf('\n'), 'Use default configs.'], 'Error', 'replace');
    end
end

% update output parameters (preserve other parameters not used in the algorithm !!!)
[wmk_temp, param_out] = wmk_core_ccsk_v2(0, Algorithm_Param.fs, [], [], Algorithm_Param.key, 'extract', Algorithm_Param);
param_name = fieldnames(param_out);
for ii=1:length(param_name)
    eval(['Algorithm_Param.', param_name{ii}, ' = param_out.', param_name{ii}, ';']);
end

if ~strcmpi(Algorithm_Param.watermark_type, Wmk_Type)
    warndlg(['Unmatched watermark type. Overridden by ''', Wmk_Type, '''.'], 'Unmatched watermark type', 'replace');
    Algorithm_Param.watermark_type = Wmk_Type;
end
%open wav file
ReadInital=1;
readfileID = fopen(fileclosename, 'r');
if ~readfileID
    msgbox('打开文件错误！','警告')
end

% clear and initialize
SinkBit_Buffer = zeros(Len_SinkBit_Buffer, 1);
WP_SinkBit_Buffer = 1;
N_SinkBit = 0; 
Start_SinkWord = 1;
Rx_String = {};
Str_Buffer = {};
N_CurrentErrorBit = 0;
N_PreviousErrorBit = 0;
BER = 0;
RP_BER = 1;
count = 0;

set(findobj('tag', 'text_ber'), 'string', num2str(BER*100, '%.2f'));
set(findobj('tag', 'text_nerr'), 'string', num2str(N_PreviousErrorBit+N_CurrentErrorBit));
set(findobj('tag', 'text_ntot'), 'string', num2str(N_SinkBit));

Len_Seg = Algorithm_Param.N;

Rx_Buffer = zeros(Nframes_Rx_Buffer*Len_Seg, 2);
Nframes_In_Rx_Buffer = 0;
Rx_Buffer_Ready = 0;
Sync_State = struct('Sync_State', 'initial');
Sync_State = dsss_sync_v2(0, Algorithm_Param.pn, Sync_State, Algorithm_Param);

nstate_acq = Sync_State.Max_Acqtime;
nstate_track = Sync_State.Max_Failtime;
Transition_Matrix = zeros(nstate_acq+nstate_track, nstate_acq+nstate_track);


init_snddev();

% start(Ai);
% trigger(Ai);
% if Phone_Enable
%     start(Ao);
%     trigger(Ao);
% end


% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
if ~isempty(t)
    stop(t)
    delete(t);
    fclose(readfileID);
end
% 原始代码开始
% if ~isempty(Ai) || ~isempty(Ao)
%     stop([Ai, Ao]);
% end
% 
% if ~isempty(timerfind)
%     stop(timerfind);
%     delete(timerfind);
% end
% 原始代码结束

function init_snddev()        % initialize sound I/O devices
globalvar_realtime_wmkextractor;
t = timer('Tag', 'timer_count_utl_snd_rdy', 'Period',0.120, 'ExecutionMode','fixedRate');
t.StartDelay = 0;
% filelenght = wavread(fileclosename,'size');
[filelenght,Fs] = audioread(fileclosename);
t.TasksToExecute = floor(length(filelenght(:,1))/Algorithm_Param.N); 
set(t,'TimerFcn',{'process_acquireddata_v2',Algorithm_Param.N});
start(t);

function start_soundout()


% --- Executes on button press in checkbox_pause_hplot1.
function checkbox_pause_hplot1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pause_hplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pause_hplot1
globalvar_realtime_wmkextractor;
Plot_Enable(1) = ~get(gcbo, 'value');


% --- Executes on button press in checkbox_pause_hplot2.
function checkbox_pause_hplot2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pause_hplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pause_hplot2
globalvar_realtime_wmkextractor;
Plot_Enable(2) = ~get(gcbo, 'value');


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
str = sprintf('Real-time Audio Watermark Extractor/Detector v3.0\nPeng Zhang,  Tsinghua Univ.  Jul. 2011\nAll rights reserved.');
logofile = 'logo.gif';
if exist(logofile)==2
    [iconData, iconCmap]=imread(logofile);
    h=msgbox(str,'About','custom',iconData,iconCmap);
    set(h, 'color',[1 1 1]);
else
    helpdlg(str, 'About');
end


% --- Executes on button press in pushbutton_cfgfile.
function pushbutton_cfgfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cfgfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
[filename, pathname] = uigetfile({'*.cfg; *.txt', 'Config Files (*.cfg, *.txt)'; '*.*',  'All Files (*.*)'}, 'multiselect', 'off');
if isnumeric(filename)               % click 'cancel'
    return;
else
    Files_Config = fullfile(pathname, filename);
    set(findobj('tag', 'edit_cfgfile'), 'string', Files_Config);
end


function edit_cfgfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cfgfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cfgfile as text
%        str2double(get(hObject,'String')) returns contents of edit_cfgfile as a double
globalvar_realtime_wmkextractor;
Files_Config = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_cfgfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cfgfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_editcfg.
function pushbutton_editcfg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_editcfg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;

if ~isempty(Files_Config) 
    if exist(Files_Config)==2 
%        edit(Files_Config);   % cannot be used in standalone exe
       eval(['! notepad ', Files_Config]);
    else
        errordlg([Files_Config, ' does not exist.'], 'Error', 'replace');
    end
end


function listbox_decoded_wmk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_decoded_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of listbox_decoded_wmk as text
%        str2double(get(hObject,'String')) returns contents of listbox_decoded_wmk as a double


% --- Executes during object creation, after setting all properties.
function listbox_decoded_wmk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_decoded_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_ber.
function togglebutton_ber_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_ber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_ber
globalvar_realtime_wmkextractor;
BER_Enable = get(gcbo, 'value');



% --------------------------------------------------------------------
function menu_mode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_mode_extraction_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mode_extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
Wmk_Type = 'extractable';
proc_changemode(Wmk_Type);

% --------------------------------------------------------------------
function menu_mode_detection_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mode_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
Wmk_Type = 'detectable';
proc_changemode(Wmk_Type);


function proc_changemode(mode)   % must update Key
globalvar_realtime_wmkextractor;
if strncmpi(mode, 'detect', 6)     % for detectable watermarking
    set(findobj('tag', 'menu_mode_detection'), 'checked', 'on');
    set(findobj('tag', 'menu_mode_extraction'), 'checked', 'off');   
    set(findobj('tag', 'uipanel_wmk_setup'), 'visible', 'off');
    set(findobj('tag', 'uipanel_wmk_info'), 'visible', 'on');
    set(findobj('tag', 'uipanel_wmk_format'), 'visible', 'off');
%     set(findobj('tag', 'uipanel_wmk_ctrl'), 'visible', 'on');   
    set(findobj('tag', 'uipanel_wmk_extractable'), 'visible', 'off');
    set(findobj('tag', 'uipanel_wmk_detectable'), 'visible', 'on');
    
    set(findobj('tag', 'uipanel_wmk_status'), 'visible', 'on');
    set(findobj('tag', 'uipanel_ber'), 'visible', 'off');
    set_detectable_wmk();
elseif strncmpi(mode, 'extract', 7)    % for extractable watermarking
    set(findobj('tag', 'menu_mode_detection'), 'checked', 'off');
    set(findobj('tag', 'menu_mode_extraction'), 'checked', 'on');
    set(findobj('tag', 'uipanel_wmk_setup'), 'visible', 'on');
    set(findobj('tag', 'uipanel_wmk_info'), 'visible', 'off');
    set(findobj('tag', 'uipanel_wmk_format'), 'visible', 'on');
%     set(findobj('tag', 'uipanel_wmk_ctrl'), 'visible', 'off');   
    set(findobj('tag', 'uipanel_wmk_extractable'), 'visible', 'on');
    set(findobj('tag', 'uipanel_wmk_detectable'), 'visible', 'off');
    
    set(findobj('tag', 'uipanel_wmk_status'), 'visible', 'off');
    set(findobj('tag', 'uipanel_ber'), 'visible', 'on');
    Key = str2num(get(findobj('tag', 'edit_emb_key'), 'string'));
else
end
% --- EOF: proc_changemode(mode)    


% --- Executes on selection change in listbox_wmk.
function listbox_wmk_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_wmk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_wmk
globalvar_realtime_wmkextractor;
set_detectable_wmk();

% --- Executes during object creation, after setting all properties.
function listbox_wmk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_detectable_wmk()            % must update Key
globalvar_realtime_wmkextractor;

str = get(findobj('tag', 'listbox_wmk'), 'string');
if size(str,1)<=Nrow_TableHeader
    disp_str_info = '  No Watermark'; 
    disp_str_status = 'No watermark specified';
    set(findobj('tag', 'text_wmk_status'), 'foregroundcolor', 'r');
    Key = NaN;
else        
    idx = get(findobj('tag', 'listbox_wmk'), 'value');        
    if idx<=Nrow_TableHeader                   
        idx = Nrow_TableHeader+1;
        set(findobj('tag', 'listbox_wmk'), 'value', idx);
    end
    Key = idx;
    disp_str_info = ['  ', str{idx}];
    disp_str_status = '';
end
set(findobj('tag', 'edit_wmk_info'), 'string', disp_str_info);
set(findobj('tag', 'text_wmk_status'), 'string', disp_str_status);

% --- EOF: set_detectable_wmk()


% --- Executes on button press in pushbutton_sel_wmktable.
function pushbutton_sel_wmktable_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sel_wmktable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_realtime_wmkextractor;
[filename, pathname] = uigetfile({'*.xls; *.txt', 'Table Files (*.xls, *.txt)'}, 'multiselect', 'off');
if isnumeric(filename)      % press cancel
    return
end

fullfilename = fullfile(pathname, filename);
[nametmp, dirtmp, ext] = fileparts(fullfilename);

delimiter = '  ';
if strcmpi(ext, '.xls')
    [num_tmp, var_txt, var_raw] = xlsread(fullfilename);
    nrow = size(var_raw, 1);
    str = cell(nrow, 1);
    for nn=1:nrow
        str_tmp = var_raw{nn, 1};
        if isnan(str_tmp)
            str_tmp = '';
        end
        str{nn} = num2str(str_tmp);
        for ii=2:size(var_raw, 2);
            str_tmp = var_raw{nn, ii};
            if isnan(str_tmp)
                str_tmp = '';
            end 
            str{nn} = [str{nn}, delimiter, num2str(str_tmp)];
        end
    end
elseif strcmpi(ext, '.txt')
    fid = fopen(fullfilename, 'r');   
    strcell_row = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);

    nrow = size(strcell_row{1}, 1);
    str = cell(nrow, 1);
    for nn=1:nrow
        str_raw = strcell_row{1}{nn};
        str_sep = textscan(str_raw, '%s', 'delimiter', '\t');
        str{nn} = str_sep{1}{1};
        for ii=2:length(str_sep{1});
            str{nn} = [str{nn}, delimiter, str_sep{1}{ii}];
        end
    end
else
    errordlg('Table file must have an extension of ''xls'' or ''txt''.');
    return
end
if size(str,1)<Nrow_TableHeader+1
    errordlg(['Table must have at least ', num2str(Nrow_TableHeader+1), ' rows.'], 'Table error', 'replace');
    return
else
    set(findobj('tag', 'listbox_wmk'), 'string', str);
    set(findobj('tag', 'listbox_wmk'), 'value', Nrow_TableHeader+1);
end


function edit_wmk_status_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wmk_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wmk_status as text
%        str2double(get(hObject,'String')) returns contents of edit_wmk_status as a double


% --- Executes during object creation, after setting all properties.
function edit_wmk_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wmk_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wmk_info_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wmk_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wmk_info as text
%        str2double(get(hObject,'String')) returns contents of edit_wmk_info as a double


% --- Executes during object creation, after setting all properties.
function edit_wmk_info_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_wavfile.
function pushbutton_wavfile_Callback(hObject, eventdata, handles)
globalvar_realtime_wmkextractor;
[filename, pathname] = uigetfile('*.wav', 'multiselect', 'on');
fileclosename = fullfile(pathname,filename);
set(findobj('tag', 'edit_wavfile'), 'string', fileclosename);



function edit_wavfile_Callback(hObject, eventdata, handles)
globalvar_realtime_wmkextractor;
fileclosename = get(gcbo, 'string');


% --- Executes during object creation, after setting all properties.
function edit_wavfile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_wavfile_Callback(hObject, eventdata, handles)
% hObject    handle to slider_wavfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_wavfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_wavfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
