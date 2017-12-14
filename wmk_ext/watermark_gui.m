% % Audio Watermarking Platform
% % Peng Zhang    Tsinghua Univ.    2009.01~05
% % All rights reserved
% % % % % % % % % % % % % % % % % % % 

function varargout = watermark_gui(varargin)
% WATERMARK_GUI_EXPORT M-file for watermark_gui.fig
%      WATERMARK_GUI_EXPORT, by itself, creates a new WATERMARK_GUI_EXPORT or raises the existing
%      singleton*.
%
%      H = WATERMARK_GUI_EXPORT returns the handle to a new WATERMARK_GUI_EXPORT or the handle to
%      the existing singleton*.
%
%      WATERMARK_GUI_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK_GUI_EXPORT.M with the given input arguments.
%
%      WATERMARK_GUI_EXPORT('Property','Value',...) creates a new WATERMARK_GUI_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermark_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermark_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermark_gui

% Last Modified by GUIDE v2.5 02-May-2010 01:56:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark_gui_OutputFcn, ...
                   'gui_LayoutFcn',  @watermark_gui_LayoutFcn, ...
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

% --------------------------------------------------------------------
% --- Executes when mainfig_watermark_gui is resized.
function mainfig_watermark_gui_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to mainfig_watermark_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Initialization when GUI created

% --------------------------------------------------------------------
% --- Executes just before watermark_gui is made visible.
function watermark_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermark_gui (see VARARGIN)

% Choose default command line output for watermark_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes watermark_gui wait for user response (see UIRESUME)
% uiwait(handles.mainfig_watermark_gui);
clear all;
add_path;
global_var;
initialcfg();
cfg_filename = fullfile(cd,'default.cfg'); % [cd,'\default.cfg'] will be wrong when cd is a root dir
if exist(cfg_filename)==2
    loadcfg(cfg_filename);    % load default config
    Files_Config = cfg_filename;
    savecfg(cfg_filename);    % update Files_Config
end
dispcfg();                              % display config on GUI

if ~isdir(Dir_Output)
    mkdir(Dir_Output);
end
Log_Filename = fullfile(Dir_Output, ['cmdwin', datestr(now, 'yyyymmddTHHMMSS'),'.log']);

diary(Log_Filename);
diary off;

% --- Outputs from this function are returned to the command line.
function varargout = watermark_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Termination when GUI closed

% --------------------------------------------------------------------
% --- Executes during object deletion, before destroying properties.
function mainfig_watermark_gui_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to mainfig_watermark_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
attr = whos('PLAYER');
if isequal(attr.class, 'audioplayer')    % if audioplayer exists, stop playing and terminate playlist
    stop(PLAYER);
    set(PLAYER, 'userdata', 'terminate');
end
diary off;

%% Menus

% --------------------------------------------------------------------
function menufile_Callback(hObject, eventdata, handles)
% hObject    handle to menufile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menufile_load_config_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_load_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile('*.cfg', 'multiselect', 'off');
if ~isnumeric(filename)
    cfg_filename = fullfile(pathname, filename);
    loadcfg(cfg_filename);
    Files_Config = cfg_filename;
    savecfg(cfg_filename);    % update Files_Config
    dispcfg();
end

% --------------------------------------------------------------------
function menufile_load_default_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_load_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
cfg_filename = fullfile(cd,'default.cfg'); % [cd,'\default.cfg'] will be wrong when cd is a root dir
if exist(cfg_filename)==2
    loadcfg(cfg_filename);           % load default config
    Files_Config = cfg_filename;
    savecfg(cfg_filename);    % update Files_Config
    dispcfg();
else
    errordlg([cfg_filename, ' does not exist.']);
end

% --------------------------------------------------------------------
function menufile_save_config_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_save_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if isempty(Files_Config)
    [filename, pathname] = uiputfile('*.cfg');
    if filename~=0
        cfg_filename = fullfile(pathname, filename);
        savecfg(cfg_filename);
        Files_Config = cfg_filename;
        set(findobj('tag', 'mainfig_watermark_gui'), 'name', ['Watermarking GUI: ', Files_Config]);
    end
else
    savecfg(Files_Config);
end

% --------------------------------------------------------------------
function menufile_save_as_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uiputfile('*.cfg');
if filename~=0
    cfg_filename = fullfile(pathname, filename);
    Files_Config = cfg_filename;
    savecfg(cfg_filename);
    set(findobj('tag', 'mainfig_watermark_gui'), 'name', ['Watermarking GUI: ', Files_Config]);
end

% --------------------------------------------------------------------
function menufile_save_default_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_save_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
cfg_filename = fullfile(cd,'default.cfg'); % [cd,'\default.cfg'] will be wrong when cd is a root dir
if exist(cfg_filename)==2                       % check whether the target file exists
    button = questdlg(['''', cfg_filename, ''' already exists! Overwrite?'], 'Save As', 'Yes', 'No', 'No');
    if strcmpi(button, 'No')
        return;
    end
end
Files_Config = cfg_filename;
savecfg(cfg_filename);
set(findobj('tag', 'mainfig_watermark_gui'), 'name', ['Watermarking GUI: ', Files_Config]);

% --------------------------------------------------------------------
function menufile_reset_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
initialcfg();
dispcfg();

% --------------------------------------------------------------------
function menufile_exit_gui_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_exit_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
close all;

% --------------------------------------------------------------------
function menuview_Callback(hObject, eventdata, handles)
% hObject    handle to menuview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function menuview_config_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if exist(Files_Config)==2
    edit(Files_Config);
elseif isempty(Files_Config)
    errordlg('No config file specified.');
else
    errordlg(['Cannot find ''', Files_Config, '''.']);
end

% --------------------------------------------------------------------
function menuview_wmk_emb_extr_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_wmk_emb_extr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if exist(Algorithm_Emb_Extr)==2
    edit(Algorithm_Emb_Extr);
elseif isempty(Algorithm_Emb_Extr)
    errordlg('No watermarking algorithm specified.');
else
    errordlg(['Cannot find ''', Algorithm_Emb_Extr, '''.']);
end

% --------------------------------------------------------------------
function menuview_global_var_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_global_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
edit('global_var.m');

% --------------------------------------------------------------------
function menuview_current_report_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_current_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if exist(Report_Filename)==2
    dos(['explorer ', Report_Filename]);
elseif isempty(Report_Filename)
    errordlg('No report file generated.');
else
    errordlg(['Cannot find ''', Report_Filename, '''.']);
end

% --------------------------------------------------------------------
function menuview_report_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile(fullfile(Dir_Output, '*.xls'), 'multiselect', 'off');
if ~isnumeric(filename)
    rpt_filename = fullfile(pathname, filename);
    dos(['explorer ', rpt_filename]);
end

% --------------------------------------------------------------------
function menuview_log_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if exist(Log_Filename)==2
    dos(['explorer ', Log_Filename]);
elseif isempty(Log_Filename)
    errordlg('No log file generated.');
else
    errordlg(['Cannot find ''', Log_Filename, '''.']);
end

% --------------------------------------------------------------------
function menuview_path_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
edit('add_path.m');

% --------------------------------------------------------------------
function menuview_output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_output_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if isdir(Dir_Output)
    dos(['explorer ', Dir_Output]);
elseif isempty(Dir_Output)
    errordlg('No output directory specified.');
else
    errordlg(['Directory ''', Dir_Output, ''' does not exist.']);
end

% --------------------------------------------------------------------
function menutools_Callback(hObject, eventdata, handles)
% hObject    handle to menutools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menutools_listentest_Callback(hObject, eventdata, handles)
% hObject    handle to menutools_listentest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
listening_test_gui;

% --------------------------------------------------------------------
function menutools_wavsplit_Callback(hObject, eventdata, handles)
% hObject    handle to menutools_wavsplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
wavsplit_gui;

% --------------------------------------------------------------------
function menutools_wavmerge_Callback(hObject, eventdata, handles)
% hObject    handle to menutools_wavmerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
wavmerge_gui;

% --------------------------------------------------------------------
function menutools_wavcmp_Callback(hObject, eventdata, handles)
% hObject    handle to menutools_wavcmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, index, dir1, dir2] = wavcmp_gui();
if ~isempty(filename)
    disp('Different files:');
    filename{~index}
end

% --------------------------------------------------------------------
function menutools_txt2wmk_Callback(hObject, eventdata, handles)
% hObject    handle to menutools_txt2wmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile('*.txt', 'Select Text File to open', 'multiselect', 'off');
if isnumeric(filename)               % click 'cancel'
    return;
else
    txtfile = fullfile(pathname, filename);
end

prompt = {'Enter hexadecimal sync word:'};
name = 'Input sync word';
numlines = 1;
defaultanswer = {'0D0A'};
syncword = inputdlg(prompt,name,numlines,defaultanswer);
if isempty(syncword)            % click 'cancel'
    return
end

[ofile, odir] = uiputfile('*.mat','Save Watermark Bits As');

if isnumeric(ofile)
    return
else
    [wmk,syncbit,txtcell] = text2bit(txtfile,syncword{1});
    wmk = [wmk, wmk];
    save(fullfile(odir, ofile), 'wmk');
end

% --------------------------------------------------------------------
function menuhelp_Callback(hObject, eventdata, handles)
% hObject    handle to menuhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuhelp_about_Callback(hObject, eventdata, handles)
% hObject    handle to menuhelp_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
str = sprintf('Audio Watermarking GUI Platform v1.1\nPeng Zhang,  Tsinghua Univ.  Jun. 2009\nAll rights reserved.');
logofile = 'logo.gif';
if exist(logofile)==2
    [iconData, iconCmap]=imread(logofile);
    h=msgbox(str,'About','custom',iconData,iconCmap);
    set(h, 'color',[1 1 1]);
else
    helpdlg(str, 'About');
end
% --------------------------------------------------------------------
function menuhelp_userguide_Callback(hObject, eventdata, handles)
% hObject    handle to menuhelp_userguide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
helpdoc_name = 'Audio Watermarking Platform User Guide.chm';
if exist(helpdoc_name)==2
    dos(['explorer ', which(helpdoc_name)]);
else
    errordlg(['Cannot find ''', helpdoc_name, '''']);
    return
end

%% Function: Initialize Config

% -------------------------------------------------------------------------------
% --- Initialize configurations; reset others to []
function initialcfg()
global_var;

% reset all global variables to []. ('clear global;' will affect global variable declarations in all other functions !!!)
s=who('global');
for ii=1:length(s)
    eval([s{ii}, ' = [];']);
end

% initial Attack_Suffix_Name
prefix_str = 'Attack_On_';
var_name=whos([prefix_str, '*']);
Attack_Suffix_Name = cell(size(var_name));
for ii=1:length(var_name)
    Attack_Suffix_Name{ii} = var_name(ii).name(length(prefix_str)+1:end);
end
    
% initial attack option table
Table_Attack_Option_Filter = {'lpf', 'bpf', 'hpf'};
Table_Attack_Option_MP3 = {'lame'};
Table_Attack_Option_AAC = {'faac', 'nero'};
% Table_Attack_Option_Resamp = {'recover'};
Table_Attack_Option_Crop = {'random', 'burst'};
Table_Attack_Option_TSM = {'pvoc', 'wsola'};
Table_Attack_Option_PS = {'pvoc', 'wsola'};

% initial attack options
for ii=1:length(Attack_Suffix_Name)
    if exist(['Table_Attack_Option_', Attack_Suffix_Name{ii}]) 
        eval(['Attack_Option_', Attack_Suffix_Name{ii}, ' = Table_Attack_Option_', Attack_Suffix_Name{ii}, '{1};']);               
    end
end      

% initial attack enable/disable and filename template configs
for ii=1:length(Attack_Suffix_Name)
    % initial attack enable/disable
    eval(['Attack_On_', Attack_Suffix_Name{ii}, ' = 1;']);
    % initial attacked filename template
    if exist(['Attack_Option_', Attack_Suffix_Name{ii}]) 
        eval(['Attack_Filename_', Attack_Suffix_Name{ii}, ' = ''*_', lower(Attack_Suffix_Name{ii}), '_'';']);
    else
        eval(['Attack_Filename_', Attack_Suffix_Name{ii}, ' = ''*_', lower(Attack_Suffix_Name{ii}),''';']);
    end
end

% initial sweeping enable/disable
s=who('Sweep*_On', 'global');
for ii=1:length(s)
    eval([s{ii}, ' = 0;']);
end

Sequential_On = 0;

XLS_Startcolumn = 1;
XLS_Extrarow = 3;

% --- EOF : initialcfg

%% Function: Display Config

% ---------------------------------------------------------------------------
% --- Display configurations on GUI objects
function dispcfg()
global_var;
set(findobj('tag', 'mainfig_watermark_gui'), 'name', ['Watermarking GUI: ', Files_Config]);

set(findobj('tag', 'edit_homedir'), 'string', Dir_Home);
set(findobj('tag', 'edit_outdir'), 'string', Dir_Output);
set(findobj('tag', 'edit_wmk_file'), 'string', Files_Watermark);
set(findobj('tag', 'edit_cover_name'), 'string', Filename_Cover);
set(findobj('tag', 'edit_stego_name'), 'string', Filename_Stego);
set(findobj('tag', 'edit_wmk_algorithm'), 'string', Algorithm_Emb_Extr);
set(findobj('tag', 'edit_emb_key'), 'string', num2str(Key_Emb));
set(findobj('tag', 'edit_extr_key'), 'string', num2str(Key_Extr));

wav_filename = cell(size(Files_Wav));           % display wav file list
for ii=1:length(Files_Wav)
    [path_temp, wav_filename{ii}, ext] = fileparts(Files_Wav{ii});
end
set(findobj('tag', 'src_audio_list'), 'string', eval('wav_filename'));
set(findobj('tag', 'src_audio_list'), 'value', [1:length(wav_filename)]);

for ii=1:length(Attack_Suffix_Name)
    % display attack enable/disable
    set(findobj('tag', ['check_', lower(Attack_Suffix_Name{ii})]), ...
          'value', eval(['Attack_On_', Attack_Suffix_Name{ii}]));    

    % display attack param value
    value = eval(['Attack_Param_', Attack_Suffix_Name{ii}]);    
    if ~isempty(value) 
        set(findobj('tag', ['value_', lower(Attack_Suffix_Name{ii})]), 'string', mat2str(value));
    else
        set(findobj('tag', ['value_', lower(Attack_Suffix_Name{ii})]), 'string', []);
    end
    
    % display attack option if it exists
    if exist(['Attack_Option_', Attack_Suffix_Name{ii}])         
        index = strmatch(eval(['Attack_Option_', Attack_Suffix_Name{ii}]), ...
                     eval(['Table_Attack_Option_', Attack_Suffix_Name{ii}]), 'exact'); % index option table       
                 set(findobj('tag', ['option_', lower(Attack_Suffix_Name{ii})]), 'value', index);
    end
    
    if eval(['Attack_On_', Attack_Suffix_Name{ii}])         
        set(findobj('tag', ['value_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');                
        set(findobj('tag', ['option_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');
        set(findobj('tag', ['run_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');
        set(findobj('tag', ['play_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');
    else
        set(findobj('tag', ['value_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
        set(findobj('tag', ['option_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
        set(findobj('tag', ['run_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
        set(findobj('tag', ['play_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
    end
end

s=who('Sweep*_On', 'global');
for ii=1:length(s)
    % display sweeping enable/disable
    set(findobj('tag', ['check_sweep', num2str(ii)]), ...
          'value', eval(['Sweep', num2str(ii), '_On'])); 
      
    if eval(['Sweep', num2str(ii), '_On'])          % sweeping enabled
        set(findobj('tag', ['edit_sweep', num2str(ii)]), 'enable', 'on');
    else
        set(findobj('tag', ['edit_sweep', num2str(ii)]), 'enable', 'off');
    end
          
    % display sweeping param value
    value = eval(['Sweep_Param', num2str(ii)]);    
    if ~isempty(value) 
        set(findobj('tag', ['edit_sweep', num2str(ii)]), 'string', mat2str(value));
    else
        set(findobj('tag', ['edit_sweep', num2str(ii)]), 'string', []);
    end
end

if Sweep1_On        % disable individual runs
    set(findobj('tag', 'run_noattack'), 'enable', 'off'); 
    for ii=1:length(Attack_Suffix_Name)            
        set(findobj('tag', ['check_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
        set(findobj('tag', ['run_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
    end
end

set(findobj('tag', 'check_seq_embed'), 'value', Sequential_On);

% --- EOF : dispcfg


%% Edit text objects for file and directory configs

% --------------------------------------------------------------------
function edit_homedir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_homedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_homedir as text
%        str2double(get(hObject,'String')) returns contents of edit_homedir as a double
global_var;
Dir_Home = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_homedir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_homedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_outdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outdir as text
%        str2double(get(hObject,'String')) returns contents of edit_outdir as a double
global_var;
Dir_Output = get(gcbo, 'string');
Dir_Attack = fullfile(Dir_Output, 'attacked');
if ~isdir(Dir_Output)
    mkdir(Dir_Output);
end
Log_Filename = fullfile(Dir_Output, ['cmdwin', datestr(now, 'yyyymmddTHHMMSS'),'.log']);
diary(Log_Filename);

% --- Executes during object creation, after setting all properties.
function edit_outdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_wmk_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wmk_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wmk_file as text
%        str2double(get(hObject,'String')) returns contents of edit_wmk_file as a double
global_var;
Files_Watermark = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_wmk_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wmk_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_wmk_algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wmk_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wmk_algorithm as text
%        str2double(get(hObject,'String')) returns contents of edit_wmk_algorithm as a double
global_var;
Algorithm_Emb_Extr = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_wmk_algorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wmk_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_cover_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cover_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cover_name as text
%        str2double(get(hObject,'String')) returns contents of edit_cover_name as a double
global_var;
Filename_Cover = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_cover_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cover_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_stego_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stego_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stego_name as text
%        str2double(get(hObject,'String')) returns contents of edit_stego_name as a double
global_var;
Filename_Stego = get(gcbo, 'string');

% --- Executes during object creation, after setting all properties.
function edit_stego_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stego_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edit_emb_key_Callback(hObject, eventdata, handles)
% hObject    handle to edit_emb_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_emb_key as text
%        str2double(get(hObject,'String')) returns contents of edit_emb_key as a double
global_var;
Key_Emb = str2num(get(gcbo, 'string'));

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

% --------------------------------------------------------------------
function edit_extr_key_Callback(hObject, eventdata, handles)
% hObject    handle to edit_extr_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_extr_key as text
%        str2double(get(hObject,'String')) returns contents of edit_extr_key as a double
global_var;
Key_Extr = str2num(get(gcbo, 'string'));

% --- Executes during object creation, after setting all properties.
function edit_extr_key_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_extr_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in src_audio_list.
function src_audio_list_Callback(hObject, eventdata, handles)
% hObject    handle to src_audio_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns src_audio_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from src_audio_list
global_var;

% --- Executes during object creation, after setting all properties.
function src_audio_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to src_audio_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press over src_audio_list with no controls selected.
% function src_audio_list_KeyPressFcn(hObject, eventdata, handles)
% % hObject    handle to src_audio_list (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global_var;
% pressedkey = get(gcf, 'CurrentKey');
% if strcmpi(pressedkey, 'delete')
%     Files_Wav(get(findobj('tag', 'src_audio_list'), 'value')) = [];     % delete selected files 
%     for ii=1:length(Files_Wav) 
%         [pathstr, filename{ii}, ext] = fileparts(Files_Wav{ii});
%     end
%     set(findobj('tag', 'src_audio_list'), 'string', filename);
%     set(findobj('tag', 'src_audio_list'), 'value', []);
% end


%% Push button objects for file and directory configs

% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_homedir.
function pushbutton_homedir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_homedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
Dir_Home = uigetdir(cd);
if isnumeric(Dir_Home)            % click 'cancel'
    Dir_Home = get(findobj('tag', 'edit_homedir'), 'string');
end
set(findobj('tag', 'edit_homedir'), 'string', Dir_Home);

% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_outdir.
function pushbutton_outdir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
if  ~isdir(Dir_Home)
    Dir_Output = uigetdir(cd);
else
    Dir_Output = uigetdir(Dir_Home);
end
if isnumeric(Dir_Output)               % click 'cancel'
    Dir_Output = get(findobj('tag', 'edit_outdir'), 'string');
end
set(findobj('tag', 'edit_outdir'), 'string', Dir_Output);
Dir_Attack = fullfile(Dir_Output, 'attacked');
Log_Filename = fullfile(Dir_Output, ['cmdwin', datestr(now, 'yyyymmddTHHMMSS'),'.log']);
diary(Log_Filename);

% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_wmk_file.
function pushbutton_wmk_file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wmk_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile('*.mat', 'multiselect', 'off');
if isnumeric(filename)               % click 'cancel'
    return;
else
    Files_Watermark = fullfile(pathname, filename);
    set(findobj('tag', 'edit_wmk_file'), 'string', Files_Watermark);
end

% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_wmk_algorithm.
function pushbutton_wmk_algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wmk_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile('*.m', 'multiselect', 'off');
if isnumeric(filename)               % click 'cancel'
    return;
else
    Algorithm_Emb_Extr = fullfile(pathname, filename);
    set(findobj('tag', 'edit_wmk_algorithm'), 'string', Algorithm_Emb_Extr);
end

% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_sel_src_au.
function pushbutton_sel_src_au_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sel_src_au (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile('*.wav', 'multiselect', 'on');

if isnumeric(filename)               % click 'cancel'
    return
else
    if ~iscell(filename)                             % for single file input, filename is a string
        filename = {filename};
    end
    filename = sort(filename);      % sort the strings in ASCII dictionary order.
    Files_Wav = cell(size(filename));
    for ii=1:length(filename)                   % for multiple-file input, filename is a cell array
        Files_Wav{ii} = fullfile(pathname, filename{ii});
    end
    set(findobj('tag', 'src_audio_list'), 'string', filename);
    set(findobj('tag', 'src_audio_list'), 'value', [1:length(filename)]);
end


%% Function: Checkbox Process for Attacks

% --------------------------------------------------------------------
% --- checkbox process for attacks
% gcbo : current handle of checkbox
% suffix_name : string suffixed to global variable name and object tag name, such as 'AWGN', 'Echo'
function checkbox_proc_attack(gcbo, suffix_name)
global_var;
if get(gcbo,'Value')==1     % enable objects & set variables
    eval(['Attack_On_', suffix_name, ' = 1;']);
    if ~isempty(findobj('tag', ['value_', lower(suffix_name)]))
        eval(['Attack_Param_', suffix_name, ' = str2num(get(findobj(''tag'', ''value_', lower(suffix_name),'''),''String''));']);
        set(findobj('tag', ['value_', lower(suffix_name)]), 'enable', 'on');
    end
    if ~isempty(findobj('tag', ['option_', lower(suffix_name)]))
        index = get(findobj('tag', ['option_', lower(suffix_name)]), 'value');
        eval(['Attack_Option_', suffix_name, ' = Table_Attack_Option_', suffix_name, '{index};']);
        set(findobj('tag', ['option_', lower(suffix_name)]), 'enable', 'on');
    end
    set(findobj('tag', ['run_', lower(suffix_name)]), 'enable', 'on');
    set(findobj('tag', ['play_', lower(suffix_name)]), 'enable', 'on');
    set(findobj('tag', ['stop_', lower(suffix_name)]), 'enable', 'on');
else                                % disable objects & clear variables
    eval(['Attack_On_', suffix_name, ' = 0;']);
%     eval(['Attack_Param_', suffix_name, ' = [];']);
%     eval(['Attack_Option_', suffix_name, ' = [];']);
    set(findobj('tag', ['value_', lower(suffix_name)]), 'enable', 'off');
    set(findobj('tag', ['option_', lower(suffix_name)]), 'enable', 'off');
    set(findobj('tag', ['run_', lower(suffix_name)]), 'enable', 'off');
    set(findobj('tag', ['play_', lower(suffix_name)]), 'enable', 'off');
end
% --- EOF : checkbox_proc_attack


%% Attack On/Off Control

% --------------------------------------------------------------------
% --- Executes on button press in check_noattack.
function check_noattack_Callback(hObject, eventdata, handles)
% hObject    handle to check_noattack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_noattack

% --------------------------------------------------------------------
% --- Executes on button press in check_awgn.
function check_awgn_Callback(hObject, eventdata, handles)
% hObject    handle to check_awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_awgn
global_var;
checkbox_proc_attack(gcbo, 'AWGN');

% --------------------------------------------------------------------
% --- Executes on button press in check_as.
function check_as_Callback(hObject, eventdata, handles)
% hObject    handle to check_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_as
global_var;
checkbox_proc_attack(gcbo, 'AS');

% --------------------------------------------------------------------
% --- Executes on button press in check_filter.
function check_filter_Callback(hObject, eventdata, handles)
% hObject    handle to check_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_filter
global_var;
checkbox_proc_attack(gcbo, 'Filter');

% --------------------------------------------------------------------
% --- Executes on button press in check_mp3.
function check_mp3_Callback(hObject, eventdata, handles)
% hObject    handle to check_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_mp3
global_var;
checkbox_proc_attack(gcbo, 'MP3');

% --------------------------------------------------------------------
% --- Executes on button press in check_aac.
function check_aac_Callback(hObject, eventdata, handles)
% hObject    handle to check_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_aac
global_var;
checkbox_proc_attack(gcbo, 'AAC');

% --------------------------------------------------------------------
% --- Executes on button press in check_resamp.
function check_resamp_Callback(hObject, eventdata, handles)
% hObject    handle to check_resamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_resamp
global_var;
checkbox_proc_attack(gcbo, 'Resamp');

% --------------------------------------------------------------------
% --- Executes on button press in check_requantz.
function check_requantz_Callback(hObject, eventdata, handles)
% hObject    handle to check_requantz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_requantz
global_var;
checkbox_proc_attack(gcbo, 'Requantz');

% --------------------------------------------------------------------
% --- Executes on button press in check_crop.
function check_crop_Callback(hObject, eventdata, handles)
% hObject    handle to check_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_crop
global_var;
checkbox_proc_attack(gcbo, 'Crop');

% --------------------------------------------------------------------
% --- Executes on button press in check_echo.
function check_echo_Callback(hObject, eventdata, handles)
% hObject    handle to check_echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_echo
global_var;
checkbox_proc_attack(gcbo, 'Echo');

% --------------------------------------------------------------------
% --- Executes on button press in check_tsm.
function check_tsm_Callback(hObject, eventdata, handles)
% hObject    handle to check_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_tsm
global_var;
checkbox_proc_attack(gcbo, 'TSM');

% --------------------------------------------------------------------
% --- Executes on button press in check_ps.
function check_ps_Callback(hObject, eventdata, handles)
% hObject    handle to check_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_ps
global_var;
checkbox_proc_attack(gcbo, 'PS');

% --------------------------------------------------------------------
% --- Executes on button press in check_jitter.
function check_jitter_Callback(hObject, eventdata, handles)
% hObject    handle to check_jitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_jitter
global_var;
checkbox_proc_attack(gcbo, 'Jitter');


%% Parameter Assignment

% --------------------------------------------------------------------
function value_awgn_Callback(hObject, eventdata, handles)
% hObject    handle to value_awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_awgn as text
%        str2double(get(hObject,'String')) returns contents of value_awgn as a double
global_var;
% Attack_Param_AWGN = eval(get(gcbo,'String'));
Attack_Param_AWGN = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_awgn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_as_Callback(hObject, eventdata, handles)
% hObject    handle to value_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_as as text
%        str2double(get(hObject,'String')) returns contents of value_as as a double
global_var;
Attack_Param_AS = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_as_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_filter_Callback(hObject, eventdata, handles)
% hObject    handle to value_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_filter as text
%        str2double(get(hObject,'String')) returns contents of value_filter as a double
global_var;
Attack_Param_Filter = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_mp3_Callback(hObject, eventdata, handles)
% hObject    handle to value_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_mp3 as text
%        str2double(get(hObject,'String')) returns contents of value_mp3 as a double
global_var;
Attack_Param_MP3 = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_mp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_aac_Callback(hObject, eventdata, handles)
% hObject    handle to value_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_aac as text
%        str2double(get(hObject,'String')) returns contents of value_aac as a double
global_var;
Attack_Param_AAC = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_aac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_resamp_Callback(hObject, eventdata, handles)
% hObject    handle to value_resamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_resamp as text
%        str2double(get(hObject,'String')) returns contents of value_resamp as a double
global_var;
Attack_Param_Resamp = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_resamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_resamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_requantz_Callback(hObject, eventdata, handles)
% hObject    handle to value_requantz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_requantz as text
%        str2double(get(hObject,'String')) returns contents of value_requantz as a double
global_var;
Attack_Param_Requantz = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_requantz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_requantz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_crop_Callback(hObject, eventdata, handles)
% hObject    handle to value_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_crop as text
%        str2double(get(hObject,'String')) returns contents of value_crop as a double
global_var;
Attack_Param_Crop = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_crop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_echo_Callback(hObject, eventdata, handles)
% hObject    handle to value_echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_echo as text
%        str2double(get(hObject,'String')) returns contents of value_echo as a double
global_var;
Attack_Param_Echo = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_echo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_tsm_Callback(hObject, eventdata, handles)
% hObject    handle to value_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_tsm as text
%        str2double(get(hObject,'String')) returns contents of value_tsm as a double
global_var;
Attack_Param_TSM = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_tsm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_ps_Callback(hObject, eventdata, handles)
% hObject    handle to value_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_ps as text
%        str2double(get(hObject,'String')) returns contents of value_ps as a double
global_var;
Attack_Param_PS = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_ps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function value_jitter_Callback(hObject, eventdata, handles)
% hObject    handle to value_jitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_jitter as text
%        str2double(get(hObject,'String')) returns contents of value_jitter as a double
global_var;
Attack_Param_Jitter = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function value_jitter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_jitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Attack Options

% --------------------------------------------------------------------
% --- Executes on selection change in option_filter.
function option_filter_Callback(hObject, eventdata, handles)
% hObject    handle to option_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_filter
global_var;
index = get(gcbo, 'value');
Attack_Option_Filter = Table_Attack_Option_Filter{index};

% --- Executes during object creation, after setting all properties.
function option_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in option_mp3.
function option_mp3_Callback(hObject, eventdata, handles)
% hObject    handle to option_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_mp3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_mp3
global_var;
index = get(gcbo, 'value');
Attack_Option_MP3 = Table_Attack_Option_MP3{index};


% --- Executes during object creation, after setting all properties.
function option_mp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in option_aac.
function option_aac_Callback(hObject, eventdata, handles)
% hObject    handle to option_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_aac contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_aac
global_var;
index = get(gcbo, 'value');
Attack_Option_AAC = Table_Attack_Option_AAC{index};

% --- Executes during object creation, after setting all properties.
function option_aac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in option_crop.
function option_crop_Callback(hObject, eventdata, handles)
% hObject    handle to option_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_crop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_crop
global_var;
index = get(gcbo, 'value');
Attack_Option_Crop = Table_Attack_Option_Crop{index};

% --- Executes during object creation, after setting all properties.
function option_crop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in option_tsm.
function option_tsm_Callback(hObject, eventdata, handles)
% hObject    handle to option_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_tsm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_tsm
global_var;
index = get(gcbo, 'value');
Attack_Option_TSM = Table_Attack_Option_TSM{index};

% --- Executes during object creation, after setting all properties.
function option_tsm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in option_ps.
function option_ps_Callback(hObject, eventdata, handles)
% hObject    handle to option_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns option_ps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from option_ps
global_var;
index = get(gcbo, 'value');
Attack_Option_PS = Table_Attack_Option_PS{index};

% --- Executes during object creation, after setting all properties.
function option_ps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Function: Wav Player
% --------------------------------------------------------------------
% --- play wav files
% filelist : string or string cell array : wav file list
% revision:
% 2009-03-24: bug fixed: stop other suspended players when finish playing current audio list
function wavplayer(filelist)
global_var;
for ii=1:length(filelist)
    if exist(filelist{ii})~=2
        h = errordlg(['Cannot find ''', filelist{ii}, '''.']);
        return;
    end
    [x, fs, nbit] = wavread(filelist{ii}, 'native');    % use native data type instead of double to save memory
    PLAYER = audioplayer(x, fs, nbit);

    play(PLAYER);          % playblocking(), sound() or wavplay() can not be stopped immediately.
                                        % a toggle button up can not interrupt while playing; use another button to stop playing

    % if no pause, the for-statement will interrupt the player, thus only the last one can be completely played
    % pause at least length(x)/fs seconds before PLAYER stopped
    td = 0.5;               % if too small, delay will be much longer than playing duration; 
                                 % if too large, busy time is too long even though the player is stopped
    for k = 1:ceil(length(x)/fs/td)
        if strcmpi(get(PLAYER, 'userdata'), 'terminate')
            break;
        else
            pause(td);
        end
    end
%     % method 2 : WRONG!! (while- or for-statements cause full-speed calculation)
%     while(strcmpi(get(PLAYER, 'running'),'on') && ~strcmpi(get(PLAYER, 'userdata'), 'terminate'))
%     end
%     % end of method 2

    if strcmpi(get(PLAYER, 'userdata'), 'terminate')
        break;
    end
end 
set(PLAYER, 'userdata', 'terminate');           % stop suspended player

% --- EOF : wavplayer


%% Function: Play Attacked Audios

% --------------------------------------------------------------------
% --- play attacked stego wav files
% suffix_name : string : string suffixed to global variable name, such as 'AWGN', 'Echo'
function play_attacked_wavfile(suffix_name)
global_var;
param_value = eval(['Attack_Param_', suffix_name]);     % e.g. param_value = Attack_Param_AWGN

select = get(findobj('tag', 'src_audio_list'), 'value');

if size(param_value, 1)==1        % only one parameter value
    selected_param = param_value;
elseif ~isempty(param_value)
    [k, ok] = listdlg('PromptString',['Select a parameter value (', suffix_name, '):'], 'SelectionMode','single', ...
                 'ListSize', [250, 150], 'ListString', numcat2str(param_value, [], [], ', '));
    if ok==0
        return
    else
        selected_param = param_value(k, :);
    end
else
    errordlg('Parameter value not assigned.');
    return
end

if exist(['Attack_Option_', suffix_name])
    option = eval(['Attack_Option_', suffix_name]);    
else
    option = [];
end

filelist = attacked_filename_gen(Files_Wav(select), Dir_Attack, ...
              {Filename_Stego, [eval(['Attack_Filename_', suffix_name]), option]}, selected_param);

wavplayer(filelist);
% --- EOF : play_attacked_wavfile


%% Play Audio

% --------------------------------------------------------------------
% --- Executes on button press in play_src.
function play_src_Callback(hObject, eventdata, handles)
% hObject    handle to play_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_src
global_var;
select = get(findobj('tag', 'src_audio_list'), 'value');
filelist = Files_Wav(select);
wavplayer(filelist);

% --------------------------------------------------------------------
% --- Executes on button press in stop_player.
function stop_player_Callback(hObject, eventdata, handles)
% hObject    handle to stop_player (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stop_player
global_var;
attr = whos('PLAYER');
if isequal(attr.class, 'audioplayer') 
    stop(PLAYER);
    set(PLAYER, 'userdata', 'terminate');         % terminate playlist
end

% --------------------------------------------------------------------
% --- Executes on button press in play_noattack.
function play_noattack_Callback(hObject, eventdata, handles)
% hObject    handle to play_noattack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
select = get(findobj('tag', 'src_audio_list'), 'value');
filelist = output_filename_gen(Files_Wav(select), Dir_Output, Filename_Stego);
wavplayer(filelist);

% --------------------------------------------------------------------
% --- Executes on button press in play_awgn.
function play_awgn_Callback(hObject, eventdata, handles)
% hObject    handle to play_awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('AWGN');  

% --- Executes on button press in play_as.
function play_as_Callback(hObject, eventdata, handles)
% hObject    handle to play_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('AS');

% --- Executes on button press in play_filter.
function play_filter_Callback(hObject, eventdata, handles)
% hObject    handle to play_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Filter');

% --- Executes on button press in play_mp3.
function play_mp3_Callback(hObject, eventdata, handles)
% hObject    handle to play_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('MP3');

% --- Executes on button press in play_aac.
function play_aac_Callback(hObject, eventdata, handles)
% hObject    handle to play_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('AAC');

% --- Executes on button press in play_resamp.
function play_resamp_Callback(hObject, eventdata, handles)
% hObject    handle to play_resamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Resamp');


% --- Executes on button press in play_requantz.
function play_requantz_Callback(hObject, eventdata, handles)
% hObject    handle to play_requantz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Requantz');

% --- Executes on button press in play_crop.
function play_crop_Callback(hObject, eventdata, handles)
% hObject    handle to play_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Crop');

% --- Executes on button press in play_echo.
function play_echo_Callback(hObject, eventdata, handles)
% hObject    handle to play_echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Echo');

% --- Executes on button press in play_tsm.
function play_tsm_Callback(hObject, eventdata, handles)
% hObject    handle to play_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('TSM');

% --- Executes on button press in play_ps.
function play_ps_Callback(hObject, eventdata, handles)
% hObject    handle to play_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('PS');

% --- Executes on button press in play_jitter.
function play_jitter_Callback(hObject, eventdata, handles)
% hObject    handle to play_jitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
play_attacked_wavfile('Jitter');


%% Function: Embed & Extract Watermark (No Attack)

% --------------------------------------------------------------------
% --- Embed and extract watermark
% 2009-04-20 : trimmean() added
function [] = run_noattack()
global_var;
cd(Dir_Home);

diary on;
tic;
if ~isdir(Dir_Output)
    mkdir(Dir_Output);
end
[pathstr, wmk_function, ext] = fileparts(Algorithm_Emb_Extr);
ofilename_c = output_filename_gen(Files_Wav, Dir_Output, Filename_Cover);
ofilename_s = output_filename_gen(Files_Wav, Dir_Output, Filename_Stego);
wmk = wmk_preprocess(Files_Watermark);

n_file = length(Files_Wav);
snr = zeros(n_file, 1);
ber = zeros(n_file, 1);
odg = zeros(n_file, 1);
cap = zeros(n_file, 1);
wavfile = cell(size(Files_Wav));
warning on;

h = progress_indication('Embedding and Extracting ... ');

% figure;             % for plotting masking threshold

for ii=1:n_file
    [pathstr, filename, ext] = fileparts(Files_Wav{ii});
    wavfile{ii} = [filename, ext];

    [wmk_emb, c_pcm, s_pcm] = feval(wmk_function, Files_Wav{ii}, wmk, Key_Emb, ...
                                                        ofilename_c{ii}, ofilename_s{ii}, 'embed');

%     if isequal(class(c_pcm), 'uint8')   % balance for uint8 (0~255 to -128~127)
%         snr(ii) = SNR(double(c_pcm-128), double(s_pcm-128));
%     else
%         snr(ii) = SNR(double(c_pcm), double(s_pcm));
%     end
    snr(ii) = SNR(c_pcm, s_pcm);
    
    result_equal(ii) = EAQUAL(ofilename_c{ii}, ofilename_s{ii});
    odg(ii) = result_equal(ii).ODG;
    cap(ii) = 44100*length(wmk_emb)/length(c_pcm);
    wmk_extract = feval(wmk_function, ofilename_s{ii}, Key_Extr, 'extract');

    [nerr, ber(ii)] = biterr(wmk(1:size(wmk_extract, 1), 1:size(wmk_extract, 2)), wmk_extract);
    
    if Sequential_On
        wmk = wmk(length(wmk_emb)+1:end, :);                                        
    end
    
    progress_indication(ii, n_file, max(floor(n_file/100),1), h, 'Embedding and Extracting ... ');
end

Report_Filename = fullfile(Dir_Output, ['report', datestr(now, 'yyyymmddTHHMMSS'),'.xls']);
XLS_Startcolumn = 1;
XLS_Extrarow = 3;

table_item = {'Wav File', 'Capacity(bps/ch@44.1kHz)', 'SNR(dB)', 'ODG', 'BER'};
outmatrix = cell(n_file+XLS_Extrarow, length(table_item));
outmatrix(1, :) = table_item;
outmatrix(2, :) = ['Average', num2cell([mean(cap), mean(snr), mean(odg), mean(ber)])];
for ii=1:n_file
    outmatrix(ii+XLS_Extrarow, :) = [wavfile(ii), num2cell([cap(ii), snr(ii), result_equal(ii).ODG, ber(ii)])];
end
xlswrite(Report_Filename, outmatrix, 1, [xlscol_num2char(XLS_Startcolumn),'1']);
XLS_Startcolumn = XLS_Startcolumn+size(outmatrix, 2);

outlier_percent = 5;
ber_avg = mean(ber);
ber_trim = trimmean(ber, outlier_percent);
snr_avg = mean(snr);
snr_trim = trimmean(snr, outlier_percent);
odg_avg = mean(odg);
odg_trim = trimmean(odg, outlier_percent);
emb_rate = 44100*length(wmk_emb)/length(c_pcm);

warning on;
fprintf(1, '-----------------------------------------------------\n');
disp('Processing finished: Embed & Extract');
fprintf(1, 'Average BER : %.2e\n', ber_avg);
fprintf(1, ['Average BER (', num2str(100-outlier_percent), '%%) : %.2e\n'], ber_trim);
fprintf(1, 'Average SNR : %.2f dB\n', snr_avg);
fprintf(1, ['Average SNR (', num2str(100-outlier_percent), '%%) : %.2f dB\n'], snr_trim);
fprintf(1, 'Average ODG : %.2f\n', odg_avg);
fprintf(1, ['Average ODG (', num2str(100-outlier_percent), '%%) : %.2f\n'], odg_trim);
fprintf(1, 'Embedding Rate : %.2f bps/ch@44.1kHz\n', emb_rate);
% fprintf(1, 'Total number of embedded bits : %d\n', length(wmk_emb(:)));
% fprintf('Exact BER should be >= %1.0e\n', 10/length(wmk_emb(:)));
fprintf(1, 'Saved report file : %s\n', Report_Filename);
fprintf(1, 'Saved log file : %s\n', Log_Filename);

Temp_CAP = emb_rate;
Temp_BER = ber_avg;
Temp_SNR = snr_avg;
Temp_ODG = odg_avg;

toc;
fprintf(1, '\n');
diary off;
% --- EOF : run_noattack


%% Function: Attack & Extract Watermark

% --------------------------------------------------------------------
% --- Attack and extract watermark
% 2009-04-20 : trimmean() added
function [] = run_attack(suffix_name)
global_var;

if isempty(Report_Filename)
    errordlg('No report file specified. Run ''No Attack'' first.');
    ofile = [];
    return
end

tic;
diary on;

stego_filename = output_filename_gen(Files_Wav, Dir_Output, Filename_Stego);
value = eval(['Attack_Param_', suffix_name]);
if exist(['Attack_Option_', suffix_name]) 
    option = eval(['Attack_Option_', suffix_name]);    
else
    option = [];
end
ofilecfg = {Dir_Attack, {[eval(['Attack_Filename_', suffix_name]), option]}};

ofile = cell(length(stego_filename), size(value,1));    % each row is a different file

if ~isdir(Dir_Attack)
    mkdir(Dir_Attack);
end

warning off;
% process stego audio
h = progress_indication(['Attacking (',suffix_name, ') ... ']);
n_file = length(stego_filename);
for ii=1:n_file
    for jj=1:size(value,1)
        ofile{ii, jj} = audioprocess(stego_filename{ii}, suffix_name, {value(jj,:), option}, ofilecfg);
    end
    progress_indication(ii, n_file, max(floor(n_file/100),1), h, ['Attacking (',suffix_name, ') ... ']);
end

% extract watermark from attacked stego audio and generate report
[pathstr, wmk_function, ext] = fileparts(Algorithm_Emb_Extr);
ofilename_c = output_filename_gen(Files_Wav, Dir_Output, Filename_Cover);
ofilename_s = output_filename_gen(Files_Wav, Dir_Output, Filename_Stego);
wmk = wmk_preprocess(Files_Watermark);

ber = zeros(size(ofile));
outmatrix = cell(size(ofile,1)+XLS_Extrarow, size(ofile,2));
for ii=1:size(outmatrix,2)          % table items
    outmatrix{1,ii} = attacked_filename_gen('', '', ['*', suffix_name, option], value(ii,:));
end

h = progress_indication(['Extracting from attacked audio (',suffix_name, ') ... ']);
for ii=1:size(ofile,1)
    
    [x, xfs, nbit] = wavread(ofilename_s{ii}, 'double');
    x = single(x);
    
    for jj=1:size(ofile,2)
        
        [y, yfs, nbit] = wavread(ofile{ii, jj}, 'double');
        y = single(y);
        
        [y, yfs, td] = audio_timealign(x, xfs, y, yfs);
%         td
%         SNR(x,y)

        wmk_extract = feval(wmk_function, y, yfs, nbit, Key_Extr, 'extract');
        
        [nerr, ber(ii, jj)] = biterr(wmk(1:size(wmk_extract, 1), 1:size(wmk_extract, 2)), wmk_extract);
        outmatrix(ii+XLS_Extrarow, jj) = num2cell(ber(ii, jj));
    end
    
    if Sequential_On
        wmk = wmk(length(wmk_extract)+1:end, :);                                        
    end
    
    progress_indication(ii, n_file, max(floor(n_file/100),1), h, ['Extracting from attacked audio (',suffix_name, ') ... ']);
end

outmatrix(2, :) = num2cell(mean(ber));

xlswrite(Report_Filename, outmatrix, 1, [xlscol_num2char(XLS_Startcolumn),'1']);
XLS_Startcolumn = XLS_Startcolumn+size(outmatrix, 2);

warning on;
value_str = numcat2str({mat2str(value)}, [], [], ',');
if isscalar(value)
    value_str{1} = ['[', value_str{1}, ']'];
end
disp(['Attack processing finished : ',suffix_name, ' ', option, value_str{1}]);
outlier_percent = 5;
str_ber = sprintf('%.2e', mean(ber(:, 1)));
str_ber2 = sprintf('%.2e', trimmean(ber(:, 1), outlier_percent));
for jj=2:size(ber,2)
    str_ber = [str_ber, '; ',sprintf('%.2e', mean(ber(:, jj)))];
    str_ber2 = [str_ber2, '; ',sprintf('%.2e', trimmean(ber(:, jj), outlier_percent))];
end
disp(['Average BER : [', str_ber, ']']);
disp(['Average BER (', num2str(100-outlier_percent), '%) : [', str_ber2, ']']);

Temp_BER = mean(ber, 1).';

toc
fprintf(1, '\n');
diary off;
% --- EOF : run_attack


%% Function: Generate Excel column notation

% ----------------------------------------------------------------------
% --- Convert column number to Excel column notation
% eg: 1-->'a'; 26-->'z'; 27-->'aa'; 256-->'iv'
function col = xlscol_num2char(col_num)
str1 = floor(col_num/26);
if col_num>26
    str1 = char(floor((col_num-1)/26)-1+'a');
else
    str1 = '';
end
str2 = char(mod(col_num-1, 26)+'a');
col = [str1, str2];
% --- EOF : xlscol_num2char


%% Function: Pre-preprocess Watermark File

% --------------------------------------------------------------------
% --- Watermark file pre-preprocessing; Read information from watermark file
% wmk_file: string: watermark filename
function wmk_out = wmk_preprocess(wmk_file)
global_var;
[pathstr, name, ext] = fileparts(wmk_file);
if strcmpi(ext, '.mat')
    vars = whos('-file', wmk_file);
    if length(vars)~=1
        errordlg('Watermark file (*.mat) must contain one and only one variable.');
    end
    load(wmk_file);
    var_name = vars(1).name;
     
%     var_temp = eval(var_name);
%     var_temp = var_temp(:);
%     if mod(length(var_temp),2)==0
%         wmk_out = reshape(var_temp, length(var_temp)/2, 2);
%     else
%         wmk_out = reshape(var_temp(1:end-1), (length(var_temp)-1)/2, 2);
%     end
    wmk_out = eval(var_name);
    if size(wmk_out, 2)==1
        wmk_out = [wmk_out, wmk_out];               % if has only one column, copy to two same channels
    end
else            % reserved for other formats
    
end
% --- EOF : wmk_preprocess    


%% Run Testbench

% --------------------------------------------------------------------
% --- Executes on button press in run_noattack.
function run_noattack_Callback(hObject, eventdata, handles)
% hObject    handle to run_noattack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in run_awgn.
global_var;
run_noattack();

% --------------------------------------------------------------------
function run_awgn_Callback(hObject, eventdata, handles)
% hObject    handle to run_awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('AWGN');

% --- Executes on button press in run_as.
function run_as_Callback(hObject, eventdata, handles)
% hObject    handle to run_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('AS');

% --- Executes on button press in run_filter.
function run_filter_Callback(hObject, eventdata, handles)
% hObject    handle to run_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Filter');

% --- Executes on button press in run_mp3.
function run_mp3_Callback(hObject, eventdata, handles)
% hObject    handle to run_mp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('MP3');

% --- Executes on button press in run_aac.
function run_aac_Callback(hObject, eventdata, handles)
% hObject    handle to run_aac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('AAC');

% --- Executes on button press in run_resamp.
function run_resamp_Callback(hObject, eventdata, handles)
% hObject    handle to run_resamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Resamp');

% --- Executes on button press in run_requantz.
function run_requantz_Callback(hObject, eventdata, handles)
% hObject    handle to run_requantz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Requantz');

% --- Executes on button press in run_crop.
function run_crop_Callback(hObject, eventdata, handles)
% hObject    handle to run_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Crop');

% --- Executes on button press in run_echo.
function run_echo_Callback(hObject, eventdata, handles)
% hObject    handle to run_echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Echo');

% --- Executes on button press in run_tsm.
function run_tsm_Callback(hObject, eventdata, handles)
% hObject    handle to run_tsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('TSM');

% --- Executes on button press in run_ps.
function run_ps_Callback(hObject, eventdata, handles)
% hObject    handle to run_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('PS');

% --- Executes on button press in run_jitter.
function run_jitter_Callback(hObject, eventdata, handles)
% hObject    handle to run_jitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
run_attack('Jitter');

% -------------------------------------------------------------------------------
% --- Executes on button press in run_all.
function run_all_Callback(hObject, eventdata, handles)
% hObject    handle to run_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
t0 = clock;
diary on;
fprintf(1, '\n****************************************************\n');
fprintf(1, ['Processing started at ', datestr(now)]);
fprintf(1, '\n****************************************************\n');

if Sweep1_On
    if size(Sweep_Param1,1)==1
        Sweep_Param1 = Sweep_Param1.';
    end
    nsweep1 = size(Sweep_Param1, 1);
    if nsweep1==0
        errordlg('Sweeping parameter must contain at least one value.');
        return
    end
else
    nsweep1 = 1;
end

if Sweep2_On
    if size(Sweep_Param2,1)==1
        Sweep_Param2 = Sweep_Param2.';
    end
    nsweep2 = size(Sweep_Param2, 1);
    if nsweep2==0
        errordlg('Sweeping parameter must contain at least one value.');
        return
    end
else
    nsweep2 = 1;
end

if Sweep1_On
    h = progress_indication('Sweeping parameters ... ');
end

if Sweep1_On
    str = {'No attack'};
     for ii=1:length(Attack_Suffix_Name)
            if eval(['Attack_On_', Attack_Suffix_Name{ii}])==1
                value = eval(['Attack_Param_', Attack_Suffix_Name{ii}]);
                for jj=1:size(value, 1)
                    value_str = numcat2str({mat2str(value(jj, :))}, [], [], ',');
                    if isscalar(value(jj, :))
                        value_str{1} = ['[', value_str{1}, ']'];
                    end
                    str = [str, {[Attack_Suffix_Name{ii}, value_str{1}]}];
                end
            end
     end
    Sweep_CAP = zeros(nsweep1, nsweep2);
    Sweep_SNR = zeros(nsweep1, nsweep2);
    Sweep_ODG = zeros(nsweep1, nsweep2);

    Sweep_BER = [str; repmat({zeros(nsweep1, nsweep2)}, 1, length(str))];
end   
for n1=1:nsweep1
    for n2=1:nsweep2
        t1 = clock;
        diary on;
        if Sweep1_On
            Sweep_Var1 = Sweep_Param1(n1, :);
            fprintf(1, '-----------------------------------------------------\n');
            disp(['Sweeping parameter 1 (', num2str(n1), ' of ', num2str(nsweep1), '): ', mat2str(Sweep_Var1)]);
            bar_title = ['Sweeping P1(', num2str(n1), '/', num2str(nsweep1), ')'];            
        end
        
        if Sweep2_On
            Sweep_Var2 = Sweep_Param2(n2, :);
            disp(['Sweeping parameter 2 (', num2str(n2), ' of ', num2str(nsweep2), '): ', mat2str(Sweep_Var2)]);
            bar_title = [bar_title, ' P2(', num2str(n2), '/', num2str(nsweep2), ')'];
        end
        
        if Sweep1_On
            set(h, 'name', bar_title);           
        end       
        run_noattack();
        
        Sweep_CAP(n1, n2) = Temp_CAP;
        Sweep_SNR(n1, n2) = Temp_SNR;
        Sweep_ODG(n1, n2) = Temp_ODG;
        Sweep_BER{2, 1}(n1, n2) = Temp_BER;
        
        pcol = 1;
        for ii=1:length(Attack_Suffix_Name)
            if eval(['Attack_On_', Attack_Suffix_Name{ii}])==1        
        %         try, 
                    run_attack(Attack_Suffix_Name{ii});
        %         catch,
        %             errordlg(['Error occurs while attacking (', Attack_Suffix_Name{ii}, '). ', ...
        %                             'Check parameter values or run this attack separately to see error information.']);
        %         end
                for jj=1:length(Temp_BER)
                    Sweep_BER{2, pcol+jj}(n1, n2) = Temp_BER(jj);
                end
                pcol = pcol+length(Temp_BER);  
            end
        end
        
        diary on;
        disp('All attacks finished.');
        disp(['Total elapsed time : ', num2str(etime(clock, t1)), ' seconds.']);
        fprintf(1, 'Saved report file : %s\n', Report_Filename);
        fprintf(1, 'Saved log file : %s\n', Log_Filename);
        
        if Sweep1_On
%             set(h, 'name', bar_title);
            progress_indication((n1-1)*nsweep2+n2, nsweep1*nsweep2, max(floor(nsweep1*nsweep2/100),1), h, 'Sweeping parameters ... ');
        end
    end
end

if Sweep1_On
    fprintf(1, '\n');
    disp('Parameter sweep finished.');
    disp(['Total elapsed time : ', num2str(etime(clock, t0)), ' seconds.']);
    matfile = fullfile(Dir_Output, ['sweepresult', datestr(now, 'yyyymmddTHHMMSS'),'.mat']);
    save(matfile, 'Sweep_*');
    fprintf(1, 'Saved MAT file : %s\n', matfile);
end
    
if Sweep1_On && isvector(Sweep_Param1) 
    if Sweep2_On && isvector(Sweep_Param2) ...
       && length(Sweep_Param1)>1 && length(Sweep_Param2)>1 % 3-D mesh plot
        [x, y] = meshgrid(Sweep_Param1, Sweep_Param2);
        figure;                                     % performance without attack
        subplot(2,2,1);
        mesh(x, y, Sweep_CAP.');
        xlabel('Param 1'); ylabel('Param 2'); zlabel('Rate (bps/ch@44.1kHz)');
        subplot(2,2,2);
        mesh(x, y, Sweep_SNR.');
        xlabel('Param 1'); ylabel('Param 2'); zlabel('SNR (dB)');
        subplot(2,2,3);
        mesh(x, y, Sweep_ODG.');
        xlabel('Param 1'); ylabel('Param 2'); zlabel('ODG');
        subplot(2,2,4);
        mesh(x, y, Sweep_BER{2,1}.');
        xlabel('Param 1'); ylabel('Param 2'); zlabel('BER');
        
        linestyle =  {'-', '--', '-.', ':'};
        markerstyle = {'none', '+', 'o', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
        [markerstyle_idx, linestyle_idx] = meshgrid(1:length(markerstyle), 1:length(linestyle));
        linestyle_idx = linestyle_idx(:);
        markerstyle_idx = markerstyle_idx(:);
        
        figure;                                 % all-in-one
        for ii=1:size(Sweep_BER,2)-1   % BER under attacks                   
            h = mesh(x, y, Sweep_BER{2,ii+1}.');
            set(h, 'linestyle', linestyle{linestyle_idx(ii)});
            set(h, 'marker', markerstyle{markerstyle_idx(ii)});
            hold on;       
        end
        legend(Sweep_BER(1, 2:end));
        title('BER under attacks');
        xlabel('Param 1'); ylabel('Param 2'); zlabel('BER');
                                             
        for ii=1:size(Sweep_BER,2)-1   % BER under attacks
            figure;                             % plot separate figures
            h = mesh(x, y, Sweep_BER{2,ii+1}.');
            title(Sweep_BER{1, ii+1});
            xlabel('Param 1'); ylabel('Param 2'); zlabel('BER');
        end
    
    elseif (~Sweep2_On && length(Sweep_Param1)>1) ...
            || (Sweep2_On && isvector(Sweep_Param2) ...
                && length(Sweep_Param1)==1 && length(Sweep_Param2)>1) % 2-D curve
        if Sweep2_On
            x = Sweep_Param2;
            xname = 'Param 2';
        else
            x = Sweep_Param1;
            xname = 'Param 1';
        end
        
        figure;                                     % performance without attack
        subplot(2,2,1);
        plot(x, Sweep_CAP.', 'bo-');
        xlabel(xname); ylabel('Rate (bps/ch@44.1kHz)'); grid on;
        subplot(2,2,2);
        plot(x, Sweep_SNR.', 'bo-'); grid on;
        xlabel(xname); ylabel('SNR (dB)');
        subplot(2,2,3);
        plot(x, Sweep_ODG.', 'bo-'); grid on;
        xlabel(xname); ylabel('ODG');
        subplot(2,2,4);
        semilogy(x, Sweep_BER{2,1}.', 'bo-'); grid on;
        xlabel(xname); ylabel('BER');
        
        set(0, 'DefaultAxesLineStyleOrder', {'o-', '*-',  '+-', 'x-', 's-', 'd-', '^-', 'v-', '>-', '<-', 'p-', 'h-'});
        set(0, 'DefaultAxesColorOrder', [0 0 1; 1 0 0; 0 1 0; 0 0 0]);
        
        figure;                                 % BER under attacks; all-in-one
        bers = zeros(length(Sweep_BER{2,1}), size(Sweep_BER,2)-1);
        for ii=1:size(Sweep_BER,2)-1   % BER under attacks                   
            bers(:, ii) = Sweep_BER{2,ii+1};                  
        end
        semilogy(x, bers);
        legend(Sweep_BER(1, 2:end));
        title('BER under attacks');
        xlabel(xname); ylabel('BER'); grid on;
        
        set(0, 'DefaultAxesLineStyleOrder', 'remove');
        set(0, 'DefaultAxesColorOrder', 'remove');
    end

end
fprintf(1, ['Processing finished at ', datestr(now), '\n']);
fprintf(1, '\n');
diary off;

%% Function: Read Data from XLS File

% --------------------------------------------------------------------
function [] = readreport(report_name)
global_var;
if exist(report_name)==2
    var_num = 'num';
    var_txt = 'txt';
    var_raw = 'raw';
    eval(['[', var_num, ',', var_txt, ',', var_raw, '] = xlsread(report_name);']); % [num, txt, raw] = xlsread(report_name);
    
    assignin('base', var_num, eval(var_num));    % output variables to command window
    assignin('base', var_txt, eval(var_txt));
    assignin('base', var_raw, eval(var_raw));
    
    snum = whos(var_num);
    stxt = whos(var_txt);
    sraw = whos(var_raw);
    
    fprintf('Read data from %s into:\n', report_name);
    fprintf([var_num, ' : %s : numeric data\n'], mat2str(snum.size));
    fprintf([var_txt, ' : %s : text data\n'], mat2str(stxt.size));
    fprintf([var_raw, ' : %s : unprocessed cell content\n'], mat2str(sraw.size));
    
    % analyze data and plot
    num = evalin('base', 'num');
    txt = evalin('base', 'txt');

    set(0, 'DefaultAxesLineStyleOrder', {'*--', '-', '-.', '--', ':', '-*', '-o', ':s', '-d', });
    set(0, 'DefaultAxesColorOrder', [0 0 1; 1 0 0; 0 1 0; 0 0 0]);
    figure;
    plot(num(XLS_Extrarow : end, 2)); title('Signal-to-Noise Ratio'); xlabel('Wav File Index'); ylabel('SNR (dB)');
    figure;
    plot(num(XLS_Extrarow : end, 3)); title('Objective Difference Grade'); ylim([-4, 1]); 
    xlabel('Wav File Index'); ylabel('ODG');grid

    bers = num(XLS_Extrarow : end, 4:end)+1e-6;
    attacks = {'No attack', txt{1, 6:end}};
    figure;
    semilogy(bers); legend(txt{1, 5:end});
    xlabel('Wav File Index'); ylabel('BER'); title('Bit Error Rate'); grid;
%     figure;
%     semilogy(bers.'); legend(txt{XLS_Extrarow+1:end, 1});
%     xlabel('Attack Index'); ylabel('BER'); title('Bit Error Rate'); grid;

    % if size(bers,2)>1
    %     [x, y] = meshgrid(1:size(bers,1), 1:size(bers,2));
    %     figure; mesh(x, y, bers.');
    %     xlabel('Wav File Index'); ylabel('Attack Index');
    % else
    % end

    set(0, 'DefaultAxesLineStyleOrder', 'remove');
    set(0, 'DefaultAxesColorOrder', 'remove');

    if size(bers,1)>1       % more than 1 samples
        figure; boxplot(bers,'notch','on', 'labels', attacks); ylabel('BER');  % display error in Matlab2009
%         set(gca, 'yscale', 'log');
        view(90,-90); grid on; title('BER Statistics');
    end

elseif isempty(report_name)
    errordlg('No report file specified. Run ''No Attack'' first.');
    return
else
    errordlg([report_name, ' does not exist.']);
    return
end
% --- EOF : readreport

%%
% --------------------------------------------------------------------
function menuanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to menuanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuanalysis_read_current_report_Callback(hObject, eventdata, handles)
% hObject    handle to menuanalysis_read_current_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
readreport(Report_Filename);

% --------------------------------------------------------------------
function menuanalysis_read_report_Callback(hObject, eventdata, handles)
% hObject    handle to menuanalysis_read_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global_var;
[filename, pathname] = uigetfile(fullfile(Dir_Output, '*.xls'), 'multiselect', 'off');
if ~isnumeric(filename)
    rpt_filename = fullfile(pathname, filename);
    readreport(rpt_filename);
else
    return
end

% [iconData, iconCmap]=imread('logo.gif');
% h=msgbox('hello','test','custom',iconData,iconCmap);
% set(h, 'color',[1 1 1]);
% iconRGB = ind2rgb(iconData, iconCmap);
% iconRGB = imresize(iconRGB, 0.25);
% uipushtool('separator','on','tooltips','aa','CData', iconRGB);
% 
% iconRGB = imread('Audio.png');
% [iconData, iconCmap]=rgb2ind(iconRGB, 256);
% h=msgbox('hello','test','custom',iconData,iconCmap);
% set(h, 'color',[1 1 1]);
% uipushtool('separator','on','tooltips','aa','CData', imresize(iconRGB, 0.2));




% --- Executes on button press in check_sweep1.
function check_sweep1_Callback(hObject, eventdata, handles)
% hObject    handle to check_sweep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_sweep1
global_var;
checkbox_proc_sweep(gcbo, '1');

% --- Executes on button press in check_sweep2.
function check_sweep2_Callback(hObject, eventdata, handles)
% hObject    handle to check_sweep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_sweep2
global_var;
checkbox_proc_sweep(gcbo, '2');


function checkbox_proc_sweep(gcbo, suffix_name)
global_var;

if get(gcbo,'Value')==1     % enable objects & set variables
    str = sprintf(['Make sure the following steps have been done before running:\n', ...
        '1. Variable Sweep_Var', suffix_name, ' must be declared global in the function containing the local variable to be swept.\n' ...
        '2. Sweep_Var', suffix_name, ' must be assigned to the local variable to be swept.\n', ...
        '3. Delete or comment out other latter assignments to this local variable to make 2 effective.']);
    msgbox(str, 'Importance', 'warn', 'modal');
    
    eval(['Sweep', suffix_name, '_On = 1;']);
    if ~isempty(findobj('tag', ['edit_sweep', suffix_name]))
        eval(['Sweep_Param', suffix_name, ' = str2num(get(findobj(''tag'', ''edit_sweep', suffix_name,'''),''String''));']);
        set(findobj('tag', ['edit_sweep', suffix_name]), 'enable', 'on');
    end
    for ii=1:10
        id_str = num2str(str2num(suffix_name)+ii);
        if exist(['Sweep', id_str, '_On'])==1          
            set(findobj('tag', ['check_sweep', id_str]), 'enable', 'on');
        else
            break
        end
    end
    
    if isequal(suffix_name, '1')
        set(findobj('tag', 'run_noattack'), 'enable', 'off');   % disable individual runs
        for ii=1:length(Attack_Suffix_Name)
            set(findobj('tag', ['run_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
            set(findobj('tag', ['check_', lower(Attack_Suffix_Name{ii})]), 'enable', 'off');
        end
    end

else                                % disable objects & clear variables  
    eval(['Sweep_Var', suffix_name, ' = [];']);
    eval(['Sweep', suffix_name, '_On = 0;']);
    set(findobj('tag', ['edit_sweep', suffix_name]), 'enable', 'off');
    for ii=1:10
        id_str = num2str(str2num(suffix_name)+ii);
        if exist(['Sweep', id_str, '_On'])==1
            eval(['Sweep', id_str, '_On = 0;']);
            set(findobj('tag', ['edit_sweep', id_str]), 'enable', 'off');
            set(findobj('tag', ['check_sweep', id_str]), 'value', 0, 'enable', 'off');
        else
            break
        end
    end
    
    if isequal(suffix_name, '1')
        set(findobj('tag', 'run_noattack'), 'enable', 'on');   % enable individual runs
        for ii=1:length(Attack_Suffix_Name)
            set(findobj('tag', ['check_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');
            if get(findobj('tag', ['check_', lower(Attack_Suffix_Name{ii})]), 'value')
                set(findobj('tag', ['run_', lower(Attack_Suffix_Name{ii})]), 'enable', 'on');
            end
        end  
    end
end
% --- EOF : checkbox_proc_sweep

function edit_sweep1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sweep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sweep1 as text
%        str2double(get(hObject,'String')) returns contents of edit_sweep1 as a double
global_var;
Sweep_Param1 = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function edit_sweep1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sweep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_sweep2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sweep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sweep2 as text
%        str2double(get(hObject,'String')) returns contents of edit_sweep2 as a double
global_var;
Sweep_Param2 = str2num(get(gcbo,'String'));

% --- Executes during object creation, after setting all properties.
function edit_sweep2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sweep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in check_seq_embed.
function check_seq_embed_Callback(hObject, eventdata, handles)
% hObject    handle to check_seq_embed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_seq_embed
global_var;
Sequential_On = get(gcbo, 'value');



% --- Creates and returns a handle to the GUI figure. 
function h1 = watermark_gui_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'pushbutton', 55, ...
    'edit', 46, ...
    'listbox', 3, ...
    'text', 44, ...
    'togglebutton', 4, ...
    'activex', 3, ...
    'popupmenu', 18, ...
    'checkbox', 18, ...
    'radiobutton', 5, ...
    'slider', 2), ...
    'override', 1, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'F:\wmk_for_st_100502\watermark_gui.m', ...
    'lastFilename', 'E:\matlab_work\audio_watermark\watermark_gui.fig');
appdata.lastValidTag = 'mainfig_watermark_gui';
appdata.GUIDELayoutEditor = [];

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'DockControls','off',...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','watermark_gui',...
'NumberTitle','off',...
'PaperPosition',[0.25 2.5 8 12],...
'PaperSize',[20.98404194812 29.67743169791],...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.833333333333 4.3125 123.666666666667 42.25],...
'Resize','off',...
'ResizeFcn','watermark_gui(''mainfig_watermark_gui_ResizeFcn'',gcbo,[],guidata(gcbo))',...
'DeleteFcn','watermark_gui(''mainfig_watermark_gui_DeleteFcn'',gcbo,[],guidata(gcbo))',...
'HandleVisibility','callback',...
'Tag','mainfig_watermark_gui',...
'UserData',[],...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_homedir';

h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''pushbutton_homedir_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3 39.875 22.5 1.625],...
'String','Home Directory ...',...
'Tag','pushbutton_homedir',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_homedir';

h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_homedir_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[28.5 39.875 49.6666666666667 1.625],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_homedir_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_homedir',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'pushbutton_outdir';

h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''pushbutton_outdir_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3 37.8125 22.5 1.625],...
'String','Output Directory ...',...
'Tag','pushbutton_outdir',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_outdir';

h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_outdir_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[28.5 37.8125 49.6666666666667 1.625],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_outdir_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_outdir',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'menufile';

h6 = uimenu(...
'Parent',h1,...
'Callback','watermark_gui(''menufile_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&File',...
'Tag','menufile',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_load_config';

h7 = uimenu(...
'Parent',h6,...
'Accelerator','L',...
'Callback','watermark_gui(''menufile_load_config_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Load Config...',...
'Tag','menufile_load_config',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_load_default';

h8 = uimenu(...
'Parent',h6,...
'Callback','watermark_gui(''menufile_load_default_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Load &Default Config',...
'Tag','menufile_load_default',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_save_config';

h9 = uimenu(...
'Parent',h6,...
'Accelerator','S',...
'Callback','watermark_gui(''menufile_save_config_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Save Config',...
'Separator','on',...
'Tag','menufile_save_config',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_save_as';

h10 = uimenu(...
'Parent',h6,...
'Callback','watermark_gui(''menufile_save_as_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Save Config &As...',...
'Tag','menufile_save_as',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_save_default';

h11 = uimenu(...
'Parent',h6,...
'Callback','watermark_gui(''menufile_save_default_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Save As &Default Config...',...
'Tag','menufile_save_default',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_reset';

h12 = uimenu(...
'Parent',h6,...
'Callback','watermark_gui(''menufile_reset_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Reset',...
'Separator','on',...
'Tag','menufile_reset',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_exit_gui';

h13 = uimenu(...
'Parent',h6,...
'Callback','watermark_gui(''menufile_exit_gui_Callback'',gcbo,[],guidata(gcbo))',...
'Label','E&xit',...
'Separator','on',...
'Tag','menufile_exit_gui',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_wmk_file';

h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''pushbutton_wmk_file_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3 35.75 22.5 1.625],...
'String','Watermark File ...',...
'Tag','pushbutton_wmk_file',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_wmk_file';

h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_wmk_file_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[28.5 35.75 49.6666666666667 1.625],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_wmk_file_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_wmk_file',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'pushbutton_wmk_algorithm';

h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''pushbutton_wmk_algorithm_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3 33.5625 22.5 1.625],...
'String','Emb/Extr Method ...',...
'Tag','pushbutton_wmk_algorithm',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_wmk_algorithm';

h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_wmk_algorithm_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[28.5 33.5625 49.6666666666667 1.625],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_wmk_algorithm_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_wmk_algorithm',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'pushbutton_sel_src_au';

h18 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''pushbutton_sel_src_au_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[81.3333333333333 39.8125 26.5 1.6875],...
'String','Source Audio Files ...',...
'Tag','pushbutton_sel_src_au',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'src_audio_list';

h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''src_audio_list_Callback'',gcbo,[],guidata(gcbo))',...
'Max',3,...
'Position',[81.3333333333333 33.5625 26.6666666666667 5.875],...
'String','',...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''src_audio_list_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','src_audio_list');

appdata = [];
appdata.lastValidTag = 'text2';

h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[3.16666666666667 31.4375 28.1666666666667 1.1875],...
'String','Output Filename Template:',...
'Style','text',...
'TooltipString','e.g., *_cover,stego*,...',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text3';

h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[31.5 31.5625 8.16666666666667 1.0625],...
'String','Cover',...
'Style','text',...
'TooltipString','host/original/cover audio',...
'Tag','text3',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text4';

h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[50.5 31.5625 8.16666666666667 1.0625],...
'String','Stego',...
'Style','text',...
'TooltipString','watermarked/stego audio',...
'Tag','text4',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_src';

h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_src_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[109.666666666667 36.4375 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_src',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'stop_player';

h24 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''stop_player_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[109.666666666667 34.375 8.16666666666667 1.375],...
'String','Stop',...
'Tag','stop_player',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text5';

h25 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[7.16666666666667 27.4375 14.5 1.0625],...
'String','Attack Profile',...
'Style','text',...
'Tag','text5',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text6';

h26 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 27.4375 14.5 1.0625],...
'String','Parameters',...
'Style','text',...
'Tag','text6',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text7';

h27 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 23.875 14.5 1.1875],...
'String','SNR (dB)',...
'Style','text',...
'TooltipString','Signal-to-Noise Ratio',...
'Tag','text7',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_cover_name';

h28 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_cover_name_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[39.5 31.4375 10 1.3125],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_cover_name_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_cover_name',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'edit_stego_name';

h29 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_stego_name_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[58.3333333333333 31.4375 10 1.3125],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_stego_name_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_stego_name',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'edit_emb_key';

h30 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_emb_key_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[87.3333333333333 31.4375 10 1.3125],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_emb_key_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_emb_key',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'edit_extr_key';

h31 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_extr_key_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[108 31.4375 10 1.3125],...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_extr_key_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_extr_key',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'check_noattack';

h32 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_noattack_Callback'',gcbo,[],guidata(gcbo))',...
'Enable','off',...
'Position',[3.16666666666667 25.625 30.1666666666667 1.5625],...
'String',' No Attack (embed/extract)',...
'Style','checkbox',...
'Value',1,...
'Tag','check_noattack',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text8';

h33 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 21.9375 16.5 1.1875],...
'String','Power Gain (dB)',...
'Style','text',...
'Tag','text8',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text9';

h34 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 20.125 23.1666666666667 1.1875],...
'String','Band Edge Freq. (kHz)',...
'Style','text',...
'TooltipString','LPF:[fpass,fstop];BPF:[fstop1,fpass1,fpass2,fstop2];HPF:[fstop,fpass]',...
'Tag','text9',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text10';

h35 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 18.1875 15.1666666666667 1.1875],...
'String','Bit Rate (kbps)',...
'Style','text',...
'TooltipString','bit rate supported by the encoder',...
'Tag','text10',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text11';

h36 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 16.3125 20.1666666666667 1.1875],...
'String','Bit Rate (kbps)',...
'Style','text',...
'TooltipString','bit rate supported by the encoder',...
'Tag','text11',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text21';

h37 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[66.5 27.3125 8.66666666666667 1.1875],...
'String','Values',...
'Style','text',...
'TooltipString','[param1,param2,...,paramk; param1,param2,...,paramk]',...
'Tag','text21',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_awgn';

h38 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_awgn_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 23.75 30 1.5625],...
'String',' Additive Gaussian Noise',...
'Style','checkbox',...
'Value',1,...
'Tag','check_awgn',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_as';

h39 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_as_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 21.75 30.1666666666667 1.5625],...
'String',' Amplitude Scaling',...
'Style','checkbox',...
'Value',1,...
'Tag','check_as',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_filter';

h40 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_filter_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 19.9375 30.1666666666667 1.5625],...
'String',' Filtering',...
'Style','checkbox',...
'Value',1,...
'Tag','check_filter',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_mp3';

h41 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_mp3_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 18 30.1666666666667 1.5625],...
'String',' MP3 Compression',...
'Style','checkbox',...
'Value',1,...
'Tag','check_mp3',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_aac';

h42 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_aac_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 16.25 30.1666666666667 1.5625],...
'String',' AAC Compression',...
'Style','checkbox',...
'Value',1,...
'Tag','check_aac',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_resamp';

h43 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_resamp_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 14.3125 30 1.5625],...
'String',' Resampling',...
'Style','checkbox',...
'Value',1,...
'Tag','check_resamp',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_echo';

h44 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_echo_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 10.75 29.8333333333333 1.5625],...
'String',' Echo',...
'Style','checkbox',...
'Value',1,...
'Tag','check_echo',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_crop';

h45 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_crop_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 8.875 30 1.5625],...
'String',' Cropping',...
'Style','checkbox',...
'Value',1,...
'Tag','check_crop',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_tsm';

h46 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_tsm_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[3.16666666666667 6.9375 30.3333333333333 1.5625],...
'String',' Time Scale Modification',...
'Style','checkbox',...
'Value',1,...
'Tag','check_tsm',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_ps';

h47 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_ps_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[3.16666666666667 5.1875 30 1.5625],...
'String',' Pitch Shifting',...
'Style','checkbox',...
'Value',1,...
'Tag','check_ps',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_jitter';

h48 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_jitter_Callback'',gcbo,[],guidata(gcbo))',...
'Enable','off',...
'Position',[3.16666666666667 3.3125 30.1666666666667 1.5625],...
'String',' Jitter',...
'Style','checkbox',...
'Value',1,...
'Tag','check_jitter',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'value_awgn';

h49 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_awgn_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 23.8125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_awgn_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_awgn');

appdata = [];
appdata.lastValidTag = 'value_as';

h50 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_as_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 21.9375 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_as_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_as');

appdata = [];
appdata.lastValidTag = 'value_filter';

h51 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_filter_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 20.0625 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_filter_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_filter');

appdata = [];
appdata.lastValidTag = 'value_mp3';

h52 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_mp3_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 18.1875 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_mp3_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_mp3');

appdata = [];
appdata.lastValidTag = 'value_aac';

h53 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_aac_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 16.3125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_aac_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_aac');

appdata = [];
appdata.lastValidTag = 'value_resamp';

h54 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_resamp_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 14.4375 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_resamp_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_resamp');

appdata = [];
appdata.lastValidTag = 'value_echo';

h55 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_echo_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 10.75 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_echo_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_echo');

appdata = [];
appdata.lastValidTag = 'value_crop';

h56 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_crop_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 8.9375 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_crop_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_crop');

appdata = [];
appdata.lastValidTag = 'value_tsm';

h57 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_tsm_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 7 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_tsm_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_tsm');

appdata = [];
appdata.lastValidTag = 'value_ps';

h58 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_ps_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 5.125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_ps_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_ps');

appdata = [];
appdata.lastValidTag = 'value_jitter';

h59 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_jitter_Callback'',gcbo,[],guidata(gcbo))',...
'Enable','off',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 3.3125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_jitter_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_jitter');

appdata = [];
appdata.lastValidTag = 'text12';

h60 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 14.5 21 1.1875],...
'String','Sampling Rate (kHz)',...
'Style','text',...
'TooltipString','target sampling frequency',...
'Tag','text12',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text13';

h61 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 8.9375 22 1.1875],...
'String','N, Ncrop (samples)',...
'Style','text',...
'TooltipString','Remove Ncrop samples every N samples periodically',...
'Tag','text13',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text14';

h62 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[36.5 10.8125 21.3333333333333 1.1875],...
'String','I (dB), D (ms), A (dB)',...
'Style','text',...
'TooltipString','I:Initial volume; D:Delay; A:Attenuation',...
'Tag','text14',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text15';

h63 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[36.5 7.0625 23.8333333333333 1.1875],...
'String','Factor (>1:stretch time)',...
'Style','text',...
'Tag','text15',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview';

h64 = uimenu(...
'Parent',h1,...
'Callback','watermark_gui(''menuview_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&View',...
'Tag','menuview',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_config';

h65 = uimenu(...
'Parent',h64,...
'Accelerator','G',...
'Callback','watermark_gui(''menuview_config_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Current &Config',...
'Tag','menuview_config',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_current_report';

h66 = uimenu(...
'Parent',h64,...
'Accelerator','R',...
'Callback','watermark_gui(''menuview_current_report_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Current &Report',...
'Tag','menuview_current_report',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_report';

h67 = uimenu(...
'Parent',h64,...
'Callback','watermark_gui(''menuview_report_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Report...',...
'Tag','menuview_report',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_log';

h68 = uimenu(...
'Parent',h64,...
'Callback','watermark_gui(''menuview_log_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Log File',...
'Tag','menuview_log',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_output_dir';

h69 = uimenu(...
'Parent',h64,...
'Accelerator','D',...
'Callback','watermark_gui(''menuview_output_dir_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Output &Directory',...
'Tag','menuview_output_dir',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_wmk_emb_extr';

h70 = uimenu(...
'Parent',h64,...
'Accelerator','W',...
'Callback','watermark_gui(''menuview_wmk_emb_extr_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Watermarking Algorithm',...
'Tag','menuview_wmk_emb_extr',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_global_var';

h71 = uimenu(...
'Parent',h64,...
'Callback','watermark_gui(''menuview_global_var_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Global &Variables',...
'Tag','menuview_global_var',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_path';

h72 = uimenu(...
'Parent',h64,...
'Callback','watermark_gui(''menuview_path_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Paths',...
'Tag','menuview_path',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text16';

h73 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'HorizontalAlignment','left',...
'Position',[36.5 5.1875 24.8333333333333 1.1875],...
'String','Factor (>1:raise pitch)',...
'Style','text',...
'Tag','text16',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text17';

h74 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'Enable','off',...
'HorizontalAlignment','left',...
'Position',[36.5 3.375 19.8333333333333 1.1875],...
'String','Percentage (%)',...
'Style','text',...
'Tag','text17',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text22';

h75 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[82.3333333333333 27.3125 8.66666666666667 1.1875],...
'String','Option',...
'Style','text',...
'Tag','text22',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_noattack';

h76 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_noattack_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 25.625 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_noattack',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_noattack';

h77 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_noattack_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 25.625 8.16666666666667 1.375],...
'String','Play',...
'BusyAction','cancel',...
'Tag','play_noattack',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_awgn';

h78 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_awgn_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 23.75 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_awgn',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_awgn';

h79 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_awgn_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 23.75 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_awgn',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_as';

h80 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_as_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 21.875 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_as',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_as';

h81 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_as_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 21.875 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_as',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_filter';

h82 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_filter_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 19.9375 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_filter',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_filter';

h83 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_filter_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 19.9375 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_filter',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_mp3';

h84 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_mp3_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 18.0625 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_mp3',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_mp3';

h85 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_mp3_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 18.0625 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_mp3',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_aac';

h86 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_aac_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 16.25 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_aac',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_aac';

h87 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_aac_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 16.25 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_aac',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_resamp';

h88 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_resamp_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 14.375 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_resamp',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_resamp';

h89 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_resamp_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 14.375 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_resamp',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_echo';

h90 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_echo_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 10.6875 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_echo',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_echo';

h91 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_echo_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 10.6875 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_echo',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_crop';

h92 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_crop_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 8.8125 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_crop',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_crop';

h93 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_crop_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 8.8125 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_crop',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_tsm';

h94 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_tsm_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 6.9375 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_tsm',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_tsm';

h95 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_tsm_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 6.9375 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_tsm',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_ps';

h96 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_ps_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 5 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_ps',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_ps';

h97 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_ps_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 5 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_ps',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_jitter';

h98 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_jitter_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Enable','off',...
'Position',[99.8333333333333 3.1875 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_jitter',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_jitter';

h99 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_jitter_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Enable','off',...
'Position',[109.833333333333 3.1875 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_jitter',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_all';

h100 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_all_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 0.875 18.1666666666667 1.6875],...
'String','Run All',...
'Interruptible','off',...
'Tag','run_all',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text37';

h101 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[77.5 31.4375 10 1.1875],...
'String','Emb Key',...
'Style','text',...
'TooltipString','integer between 0 and 2^32-1',...
'Tag','text37',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text38';

h102 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[98.5 31.5 8.83333333333333 1.1875],...
'String','Extr Key',...
'Style','text',...
'TooltipString','integer between 0 and 2^32-1',...
'Tag','text38',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuanalysis';

h103 = uimenu(...
'Parent',h1,...
'Callback','watermark_gui(''menuanalysis_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Analysis',...
'Tag','menuanalysis',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuanalysis_read_current_report';

h104 = uimenu(...
'Parent',h103,...
'Callback','watermark_gui(''menuanalysis_read_current_report_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Read and Analyze Data from &Current Report',...
'Tag','menuanalysis_read_current_report',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuanalysis_read_report';

h105 = uimenu(...
'Parent',h103,...
'Callback','watermark_gui(''menuanalysis_read_report_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Read and Analyze Data from Report...',...
'Tag','menuanalysis_read_report',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools';

h106 = uimenu(...
'Parent',h1,...
'Callback','watermark_gui(''menutools_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Tools',...
'Tag','menutools',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools_listentest';

h107 = uimenu(...
'Parent',h106,...
'Callback','watermark_gui(''menutools_listentest_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Listening Test...',...
'Tag','menutools_listentest',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools_wavsplit';

h108 = uimenu(...
'Parent',h106,...
'Callback','watermark_gui(''menutools_wavsplit_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Wav File &Split...',...
'Tag','menutools_wavsplit',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools_wavmerge';

h109 = uimenu(...
'Parent',h106,...
'Callback','watermark_gui(''menutools_wavmerge_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Wav File &Merge...',...
'Tag','menutools_wavmerge',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools_wavcmp';

h110 = uimenu(...
'Parent',h106,...
'Callback','watermark_gui(''menutools_wavcmp_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Wav File &Compare...',...
'Tag','menutools_wavcmp',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menutools_txt2wmk';

h111 = uimenu(...
'Parent',h106,...
'Callback','watermark_gui(''menutools_txt2wmk_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Text to Watermark...',...
'Tag','menutools_txt2wmk',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp';

h112 = uimenu(...
'Parent',h1,...
'Callback','watermark_gui(''menuhelp_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Help',...
'Tag','menuhelp',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp_about';

h113 = uimenu(...
'Parent',h112,...
'Callback','watermark_gui(''menuhelp_about_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&About...',...
'Tag','menuhelp_about',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp_userguide';

h114 = uimenu(...
'Parent',h112,...
'Callback','watermark_gui(''menuhelp_userguide_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&User''s Guide',...
'Tag','menuhelp_userguide',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_requantz';

h115 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_requantz_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 12.5 30.1666666666667 1.5625],...
'String',' Requantization',...
'Style','checkbox',...
'Value',1,...
'Tag','check_requantz',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'value_requantz';

h116 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''value_requantz_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 12.625 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''value_requantz_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','value_requantz');

appdata = [];
appdata.lastValidTag = 'text41';

h117 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[36.5 12.6875 21 1.1875],...
'String','Number of Bits',...
'Style','text',...
'TooltipString','target number of bits per sample;8,16,24,32 recommended',...
'Tag','text41',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'run_requantz';

h118 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''run_requantz_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[99.8333333333333 12.5625 8.16666666666667 1.375],...
'String','Run',...
'Interruptible','off',...
'Tag','run_requantz',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'play_requantz';

h119 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''play_requantz_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[109.833333333333 12.5625 8.16666666666667 1.375],...
'String','Play',...
'Tag','play_requantz',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'check_sweep1';

h120 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_sweep1_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[3.16666666666667 29.125 18.6666666666667 1.5625],...
'String','Param1 Sweep',...
'Style','checkbox',...
'Value',1,...
'Tag','check_sweep1',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_sweep1';

h121 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_sweep1_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[23.1666666666667 29.3125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_sweep1_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_sweep1');

appdata = [];
appdata.lastValidTag = 'check_sweep2';

h122 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_sweep2_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[41.6666666666667 29.125 18.8333333333333 1.5625],...
'String','Param2 Sweep',...
'Style','checkbox',...
'Value',1,...
'Tag','check_sweep2',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit_sweep2';

h123 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''edit_sweep2_Callback'',gcbo,[],guidata(gcbo))',...
'HorizontalAlignment','left',...
'Position',[61.6666666666667 29.3125 16.6666666666667 1.25],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''edit_sweep2_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit_sweep2');

appdata = [];
appdata.lastValidTag = 'check_seq_embed';

h124 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','watermark_gui(''check_seq_embed_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[79.6666666666665 29.0625 38.6666666666667 1.6875],...
'String','Sequentially read the watermark file',...
'Style','checkbox',...
'TooltipString','sequentially read the watermark file for each audio clip',...
'Tag','check_seq_embed',...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'option_ps';

h125 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_ps_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[79.8333333333333 4.875 15 1.625],...
'String',{  'Phs. Voc.'; 'WSOLA' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_ps_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_ps',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'option_tsm';

h126 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_tsm_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[79.8333333333333 6.75 15 1.625],...
'String',{  'Phs. Voc.'; 'WSOLA' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_tsm_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_tsm',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'option_crop';

h127 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_crop_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[79.8333333333333 8.6875 15 1.625],...
'String',{  'Random'; 'Burst' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_crop_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_crop',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'option_aac';

h128 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_aac_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[79.8333333333333 16.125 15 1.625],...
'String',{  'FAAC'; 'Nero' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_aac_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_aac',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'option_mp3';

h129 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_mp3_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'Position',[79.8333333333333 17.9375 15 1.625],...
'String','Lame',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_mp3_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_mp3',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'option_filter';

h130 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','watermark_gui(''option_filter_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[79.8333333333333 19.75 15 1.625],...
'String',{  'Low Pass'; 'Band Pass'; 'High Pass' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'watermark_gui(''option_filter_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','option_filter');


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   eval(createfcn);
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      WATERMARK_GUI_EXPORT, by itself, creates a new WATERMARK_GUI_EXPORT or raises the existing
%      singleton*.
%
%      H = WATERMARK_GUI_EXPORT returns the handle to a new WATERMARK_GUI_EXPORT or the handle to
%      the existing singleton*.
%
%      WATERMARK_GUI_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK_GUI_EXPORT.M with the given input arguments.
%
%      WATERMARK_GUI_EXPORT('Property','Value',...) creates a new WATERMARK_GUI_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2006/06/27 23:04:21 $

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('MATLAB:gui_mainfcn:FieldNotFound', 'Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % WATERMARK_GUI_EXPORT
    % create the GUI
    gui_Create = 1;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % WATERMARK_GUI_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallbak(gui_State, varargin{:})
    % WATERMARK_GUI_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % WATERMARK_GUI_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen')
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end

    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% this application data is used to indicate the running mode of a GUIDE
% GUI to distinguish it from the design mode of the GUI in GUIDE.
setappdata(0,'OpenGuiWhenRunning',1);

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
try
    gui_hFigure = openfig(name, singleton, visible);
catch
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end
rmappdata(0,'OpenGuiWhenRunning');

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallbak(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) ...
             && ischar(varargin{1}) ...
             && isequal(ishandle(varargin{2}), 1);
catch
    result = false;
end

