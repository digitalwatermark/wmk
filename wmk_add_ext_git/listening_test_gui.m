% % Subjective Listening Test Platform
% % Peng Zhang    Tsinghua Univ.    2009.04~05
% % All rights reserved
% % % % % % % % % % % % % % % % % % % 

function varargout = listening_test_gui(varargin)
% LISTENING_TEST_GUI_EXPORT M-file for listening_test_gui.fig
%      LISTENING_TEST_GUI_EXPORT, by itself, creates a new LISTENING_TEST_GUI_EXPORT or raises the existing
%      singleton*.
%
%      H = LISTENING_TEST_GUI_EXPORT returns the handle to a new LISTENING_TEST_GUI_EXPORT or the handle to
%      the existing singleton*.
%
%      LISTENING_TEST_GUI_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTENING_TEST_GUI_EXPORT.M with the given input arguments.
%
%      LISTENING_TEST_GUI_EXPORT('Property','Value',...) creates a new LISTENING_TEST_GUI_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before listening_test_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to listening_test_gui_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help listening_test_gui

% Last Modified by GUIDE v2.5 04-Sep-2011 21:29:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @listening_test_gui_export_OpeningFcn, ...
                   'gui_OutputFcn',  @listening_test_gui_export_OutputFcn, ...
                   'gui_LayoutFcn',  @listening_test_gui_export_LayoutFcn, ...
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


% --- Executes just before listening_test_gui is made visible.
function listening_test_gui_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to listening_test_gui (see VARARGIN)

% Choose default command line output for listening_test_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes listening_test_gui wait for user response (see UIRESUME)
% uiwait(handles.mainfig_listening_test);

add_path;
globalvar_listening_test;
reset;

%% Function: Reset
function [] = reset()
globalvar_listening_test;
s = whos('global');         % set global variables used to []
for ii=1:length(s)
    eval([s(ii).name, ' = [];']);
end

for ii=1:100            % calculate max supported number of files to be tested
    if isempty(findobj('tag', ['play', num2str(ii)]))
        MAX_NTEST = ii-1;
        break
    end
end

MIN_TEST = 10;      % default minimum number of tests
set(findobj('tag', 'edit_ntest'), 'string', num2str(MIN_TEST));

PERM_ORDER = 'none';
set(findobj('tag', 'popupmenu_ref_rearrange'), 'value', 1);

PLAYED_CHANNEL = 'stereo';
set(findobj('tag', 'popupmenu_channel'), 'value', 1);

set_mode('admin');
set_libmode('write');

% --- EOF : reset

%%
% --- Outputs from this function are returned to the command line.
function varargout = listening_test_gui_export_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function mainfig_listening_test_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to mainfig_listening_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
stop_player;
stop_timer;

%%
function mos1_Callback(hObject, eventdata, handles)
% hObject    handle to mos1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos1 as text
%        str2double(get(hObject,'String')) returns contents of mos1 as a double

% --- Executes during object creation, after setting all properties.
function mos1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos2_Callback(hObject, eventdata, handles)
% hObject    handle to mos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos2 as text
%        str2double(get(hObject,'String')) returns contents of mos2 as a double

% --- Executes during object creation, after setting all properties.
function mos2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos3_Callback(hObject, eventdata, handles)
% hObject    handle to mos3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos3 as text
%        str2double(get(hObject,'String')) returns contents of mos3 as a double

% --- Executes during object creation, after setting all properties.
function mos3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos4_Callback(hObject, eventdata, handles)
% hObject    handle to mos4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos4 as text
%        str2double(get(hObject,'String')) returns contents of mos4 as a double

% --- Executes during object creation, after setting all properties.
function mos4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos5_Callback(hObject, eventdata, handles)
% hObject    handle to mos5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos5 as text
%        str2double(get(hObject,'String')) returns contents of mos5 as a double

% --- Executes during object creation, after setting all properties.
function mos5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos6_Callback(hObject, eventdata, handles)
% hObject    handle to mos6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos6 as text
%        str2double(get(hObject,'String')) returns contents of mos6 as a double

% --- Executes during object creation, after setting all properties.
function mos6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mos7_Callback(hObject, eventdata, handles)
% hObject    handle to mos7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mos7 as text
%        str2double(get(hObject,'String')) returns contents of mos7 as a double

% --- Executes during object creation, after setting all properties.
function mos7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mos7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Function: Wav player
function wavplayer(x, fs, nbit)
globalvar_listening_test;
PLAYER = audioplayer(x, fs, nbit);

play(PLAYER);          % playblocking(), sound() or wavplay() can not be stopped immediately.
                                        % a toggle button up can not interrupt while playing; use another button to stop playing                                       
% --- EOF : wavplayer

%% Function: Stop wav player
function [] = stop_player()
globalvar_listening_test;
attr = whos('PLAYER');
if isequal(attr.class, 'audioplayer') 
    stop(PLAYER);
end
% --- EOF : stop_player

%% Function: Stop timer
function [] = stop_timer()
t = timerfind('tag', 'timer');
if ~isempty(t)
    stop(t);
    delete(t);
end
% --- EOF : stop_timer

%% mode selection
% --- Executes on button press in radiobutton_admin.
function radiobutton_admin_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_admin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_admin
globalvar_listening_test;

if ~strcmpi(MODE, 'admin');
    if isempty(LT_Report_Filename)
        ok = questdlg('Save results of current user?','Save results','Save','Discard','Save');
        if isempty(ok)
            set(findobj('tag', 'radiobutton_admin'), 'value', 0);
            set(findobj('tag', 'radiobutton_user'), 'value', 1);
            return
        elseif strcmpi(ok, 'Save')
            pushbutton_finish_Callback;
            if isempty(LT_Report_Filename)
                set(findobj('tag', 'radiobutton_admin'), 'value', 0);
                set(findobj('tag', 'radiobutton_user'), 'value', 1);
                return
            end
        end
    end
    pwd = inputdlg('Password');
    if isempty(pwd)           % press cancel
        set(findobj('tag', 'radiobutton_admin'), 'value', 0);
        set(findobj('tag', 'radiobutton_user'), 'value', 1);
        return
    else
        pwd = pwd{1};
    end

    if isequal(pwd, ADMIN_PWD)
        set_mode('admin');
    else
        errordlg('Password wrong!');
        set(findobj('tag', 'radiobutton_admin'), 'value', 0);
        set(findobj('tag', 'radiobutton_user'), 'value', 1);        
    end
else
    set(findobj('tag', 'radiobutton_admin'), 'value', 1);
    set(findobj('tag', 'radiobutton_user'), 'value', 0);
end


% --- Executes on button press in radiobutton_user.
function radiobutton_user_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_user
globalvar_listening_test;

if ~strcmpi(MODE, 'user');  
    if isempty(AUDIO_LIST)
        errordlg('No audio library loaded.');
        set(findobj('tag', 'radiobutton_admin'), 'value', 1);
        set(findobj('tag', 'radiobutton_user'), 'value', 0);
        return
    end
    username = inputdlg('User Name');
    if isempty(username)           % press cancel 
        set(findobj('tag', 'radiobutton_admin'), 'value', 1);
        set(findobj('tag', 'radiobutton_user'), 'value', 0);
        return
    else
        CURRENT_USER = username{1};
        set_mode('user');
        proc_newuser;        
    end
else
    set(findobj('tag', 'radiobutton_admin'), 'value', 0);
    set(findobj('tag', 'radiobutton_user'), 'value', 1);
end


%% Function: Set mode
function []=set_mode(mode)
globalvar_listening_test;
if strcmpi(mode, 'admin')
    MODE = 'admin';
    CURRENT_USER = 'Administrator';
    set(findobj('tag', 'mainfig_listening_test'), 'name', ['Subjective Listening Test GUI: ', 'Administrator']);
    set(findobj('tag', 'radiobutton_admin'), 'value', 1);
    set(findobj('tag', 'radiobutton_user'), 'value', 0);
    set(findobj('tag', 'pushbutton_newuser'), 'enable', 'off');
    
    set(findobj('tag', 'menufile_loadlib'), 'enable', 'on');
    set(findobj('tag', 'menufile_createlib'), 'enable', 'on');
    set(findobj('tag', 'menufile_reset'), 'enable', 'on');
    
    set(findobj('tag', 'menuview_report'), 'enable', 'on');
    set(findobj('tag', 'menuview_currentlib'), 'enable', 'on');
    set(findobj('tag', 'menuview_lib'), 'enable', 'on');
    set(findobj('tag', 'menuview_outputdir'), 'enable', 'on');
    set(findobj('tag', 'menuview_userlist'), 'enable', 'on');
    
    set(findobj('tag', 'menusettings_password'), 'enable', 'on');
    set(findobj('tag', 'menusettings_outputdir'), 'enable', 'on');
    set(findobj('tag', 'edit_ntest'), 'enable', 'on');
    set(findobj('tag', 'popupmenu_ref_rearrange'), 'enable', 'on');
    set(findobj('tag', 'popupmenu_channel'), 'enable', 'on');
    
    REF_ORDER = 1:NREF;
    TEST_ORDER = (1:NTEST).';
    RESULT_MOS = [];
    RESULT_ISREF = [];
    RESULT_COMMENT = {};
    if isempty(NTEST)
        CURRENT_COMMENT = {''};
    else
        CURRENT_COMMENT = repmat({''}, NTEST, 1);
    end
    LT_Report_Filename = '';
    readaudio;
elseif strcmpi(mode, 'user')
    MODE = 'user';
    if isempty(CURRENT_USER)
        set(findobj('tag', 'mainfig_listening_test'), 'name', ['Subjective Listening Test GUI: ', 'Anonymous user']);
    else
        set(findobj('tag', 'mainfig_listening_test'), 'name', ['Subjective Listening Test GUI: ', CURRENT_USER]);
    end
    set(findobj('tag', 'radiobutton_admin'), 'value', 0);
    set(findobj('tag', 'radiobutton_user'), 'value', 1);
    set(findobj('tag', 'pushbutton_newuser'), 'enable', 'on');
    set(findobj('tag', 'menufile_loadlib'), 'enable', 'off');
    set(findobj('tag', 'menufile_createlib'), 'enable', 'off');
    set(findobj('tag', 'menufile_reset'), 'enable', 'off');
    
    set(findobj('tag', 'menuview_report'), 'enable', 'off');
    set(findobj('tag', 'menuview_currentlib'), 'enable', 'off');
    set(findobj('tag', 'menuview_lib'), 'enable', 'off');
    set(findobj('tag', 'menuview_outputdir'), 'enable', 'off');
    set(findobj('tag', 'menuview_userlist'), 'enable', 'off');
    
    set(findobj('tag', 'menusettings_password'), 'enable', 'off');
    set(findobj('tag', 'menusettings_outputdir'), 'enable', 'off');
    set(findobj('tag', 'edit_ntest'), 'enable', 'off');
    set(findobj('tag', 'popupmenu_ref_rearrange'), 'enable', 'off');    
    set(findobj('tag', 'popupmenu_channel'), 'enable', 'off');
end
initial_testpanel;
% --- EOF : set_mode

%% Function: Initial test panel and global variables
function [] = initial_testpanel()
globalvar_listening_test;
stop_player;
stop_timer;

set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
set(findobj('tag', 'pushbutton_next'), 'enable', 'on');
set(findobj('tag', 'pushbutton_finish'), 'enable', 'off');
set(findobj('tag', 'slider_playprogress'), 'value', 0);

for ii=1:NTEST
    set(findobj('tag', ['isref', num2str(ii)]), 'value', 0);
    set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on', 'string', '');
end
CURRENT_AUDIO_INDEX = [1, 0];

if ~isempty(AUDIO_LIST)
    set(findobj('tag', 'text_refname'), 'string', AUDIO_LIST{REF_ORDER(CURRENT_AUDIO_INDEX(1))});
end

if isempty(AUDIO_LIST)
    str = '';
else
    str = sprintf('%d of %d', CURRENT_AUDIO_INDEX(1), min(NREF, MIN_TEST));
end
set(findobj('tag', 'text_progress'), 'string', str);
% --- EOF : initial_testpanel

%% Function: Set libmode
function []=set_libmode(libmode)
globalvar_listening_test;
RESULT_MOS = [];
RESULT_ISREF = [];
RESULT_COMMENT = {};
if isempty(NTEST)
    CURRENT_COMMENT = {''};
else
    CURRENT_COMMENT = repmat({''}, NTEST, 1);
end
LT_Report_Filename = '';
if strcmpi(libmode, 'write')
    LIB_MODE = 'write';
    NTEST = 1;
    DIR_LIST = {};
    AUDIO_LIST = {};
    set(findobj('tag', 'text_play'), 'string', 'Files');
    set(findobj('tag', 'text_testdir'), 'string', 'Directory');
    set(findobj('tag', 'text_isref'), 'string', '');
    set(findobj('tag', 'text_mos'), 'string', 'Filename Template');
    set(findobj('tag', 'text_refname'), 'string', '');
    set(findobj('tag', 'text_comment'), 'string', '');
    
    set(findobj('tag', 'pushbutton_next'), 'string', 'Add');
    set(findobj('tag', 'pushbutton_previous'), 'string', 'Delete');
    
    set(findobj('tag', 'radiobutton_user'), 'value', 0);
    set(findobj('tag', 'pushbutton_newuser'), 'enable', 'off');       
    set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
    set(findobj('tag', 'pushbutton_finish'), 'enable', 'on');
    set(findobj('tag', 'radiobutton_user'), 'enable', 'off');
    
    for ii=2:10
        set(findobj('tag', ['play', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['mos', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['isref', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['mos', num2str(ii)]), 'string', '');
        set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on');
        set(findobj('tag', ['comment', num2str(ii)]), 'visible', 'off');
    end
    set(findobj('tag', 'isref1'), 'visible', 'off');
    set(findobj('tag', 'mos1'), 'string', '');
    set(findobj('tag', 'mos1'), 'enable', 'on');
    set(findobj('tag', 'isref1'), 'value', 0);
    set(findobj('tag', 'comment1'), 'visible', 'off');
    set(findobj('tag', 'stop_play'), 'visible', 'off');
    set(findobj('tag', 'slider_playprogress'), 'visible', 'off');    
    
    set(findobj('tag', 'text_nref'), 'visible', 'off');
    set(findobj('tag', 'text_progress'), 'visible', 'off');    
    set(findobj('tag', 'text_duration'), 'string', '');
elseif strcmpi(libmode, 'read')
    LIB_MODE = 'read';
    NTEST = [];
    DIR_LIST = {};
    AUDIO_LIST = {};
    set(findobj('tag', 'text_play'), 'string', 'Play');
    set(findobj('tag', 'text_testdir'), 'string', '');
    set(findobj('tag', 'text_isref'), 'string', '=Ref.?');
    set(findobj('tag', 'text_mos'), 'string', 'MOS (1.0 -- 5.0)');
    set(findobj('tag', 'text_comment'), 'string', 'Comment');
    
    set(findobj('tag', 'pushbutton_next'), 'string', 'Next >>');
    set(findobj('tag', 'pushbutton_previous'), 'string', '<< Previous');
    
    set(findobj('tag', 'radiobutton_user'), 'value', 0);
    set(findobj('tag', 'pushbutton_newuser'), 'enable', 'off');       
    set(findobj('tag', 'pushbutton_finish'), 'enable', 'on');
    set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
    set(findobj('tag', 'pushbutton_finish'), 'enable', 'off');
    set(findobj('tag', 'radiobutton_user'), 'enable', 'on');
    
    for ii=1:10
        set(findobj('tag', ['play', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['mos', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['isref', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['mos', num2str(ii)]), 'string', '');
        set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on');
        set(findobj('tag', ['comment', num2str(ii)]), 'visible', 'on');
    end
    set(findobj('tag', 'text_nref'), 'visible', 'on');
    set(findobj('tag', 'text_progress'), 'visible', 'on'); 
    set(findobj('tag', 'stop_play'), 'visible', 'on');
    set(findobj('tag', 'slider_playprogress'), 'visible', 'on');
end
% --- EOF : set_libmode

%% new user
% --- Executes on button press in pushbutton_newuser.
function pushbutton_newuser_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_newuser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
set(gcbo, 'value', 1);
if isempty(LT_Report_Filename)
    ok = questdlg('Save results of current user?','Save results','Save','Discard','Save');
    if isempty(ok)
        return
    elseif strcmpi(ok, 'Save')
        pushbutton_finish_Callback;
        if isempty(LT_Report_Filename)
            return
        end
    end
end

username = inputdlg('User Name', 'New user', [1, 30]);
if isempty(username)           % press cancel      
    return
else
    CURRENT_USER = username{1};
    proc_newuser;
end


%% Function: Process when creating new user account
function [] = proc_newuser()
globalvar_listening_test;

if isempty(CURRENT_USER)
    set(findobj('tag', 'mainfig_listening_test'), 'name', ['Subjective Listening Test GUI: ', 'Anonymous user']);
else
    set(findobj('tag', 'mainfig_listening_test'), 'name', ['Subjective Listening Test GUI: ', CURRENT_USER]);
end

if isempty(USER_LIST)
    USER_LIST = {};
end

USER_LIST = {USER_LIST{:} , CURRENT_USER};

if strcmpi(PERM_ORDER, 'none')
    REF_ORDER = 1:NREF;
elseif strcmpi(PERM_ORDER, 'random')
    REF_ORDER = randperm(NREF);
end

current_test_order = randperm(NTEST);
TEST_ORDER = current_test_order(:);

initial_testpanel;

RESULT_MOS = [];
RESULT_ISREF = [];
RESULT_COMMENT = {};
CURRENT_COMMENT = repmat({''}, NTEST, 1);
LT_Report_Filename = '';
readaudio;
% --- EOF : proc_newuser

%%
% --- Executes on slider movement.
function slider_playprogress_Callback(hObject, eventdata, handles)
% hObject    handle to slider_playprogress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
globalvar_listening_test;

if isempty(CURRENT_AUDIO) || isempty(CURRENT_AUDIO_INDEX)
    set(gcbo, 'value', 0);
    return
end
if CURRENT_AUDIO_INDEX(2)==0
    set(gcbo, 'value', 0);
    return
end
x = CURRENT_AUDIO{CURRENT_AUDIO_INDEX(2)};
x = x(1:PLAYED_LENGTH,:);
fs = FS{CURRENT_AUDIO_INDEX(2)};
nbit = NBIT{CURRENT_AUDIO_INDEX(2)};
if ~isempty(x)
    v = get(gcbo, 'value');
    len = length(x);
    start_idx = round(len*v)+1;
    if start_idx<len
        if strcmpi(PLAYED_CHANNEL, 'stereo')
            wavplayer(x(start_idx+1:end, :), fs, nbit);
        elseif strcmpi(PLAYED_CHANNEL, 'left')
            wavplayer(x(start_idx+1:end, 1), fs, nbit);
        elseif strcmpi(PLAYED_CHANNEL, 'right')
            wavplayer(x(start_idx+1:end, min(size(x,2),2)), fs, nbit);
        end
    else
        stop_player;
    end
end


% --- Executes during object creation, after setting all properties.
function slider_playprogress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_playprogress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Function: Process checkboxes tagged iref1~irefn
% process when press isrefn
function [] = proc_isref(h)
globalvar_listening_test;
set(h, 'value', 1);
len_prefix = 5;
current_tag = get(gcbo,'tag');
id = str2num(current_tag(len_prefix+1:end));
set(findobj('tag', ['mos', num2str(id)]), 'enable', 'off', 'string', '5.0');
id_set = find(1:NTEST~=id);
for ii=id_set
    if get(findobj('tag', [current_tag(1:len_prefix), num2str(ii)]), 'value')==1
        set(findobj('tag', ['mos', num2str(ii)]), 'string', '');
    end
    set(findobj('tag', [current_tag(1:len_prefix), num2str(ii)]), 'value', 0);
    set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on');
end
% --- EOF : proc_isref

% --- Executes on button press in isref1.
function isref1_Callback(hObject, eventdata, handles)
% hObject    handle to isref1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref1
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref2.
function isref2_Callback(hObject, eventdata, handles)
% hObject    handle to isref2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref2
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref3.
function isref3_Callback(hObject, eventdata, handles)
% hObject    handle to isref3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref3
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref4.
function isref4_Callback(hObject, eventdata, handles)
% hObject    handle to isref4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref4
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref5.
function isref5_Callback(hObject, eventdata, handles)
% hObject    handle to isref5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref5
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref6.
function isref6_Callback(hObject, eventdata, handles)
% hObject    handle to isref6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref6
globalvar_listening_test;
proc_isref(hObject);

% --- Executes on button press in isref7.
function isref7_Callback(hObject, eventdata, handles)
% hObject    handle to isref7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isref7
globalvar_listening_test;
proc_isref(hObject);


%% Function: Save current result
function ok = save_current_result()
globalvar_listening_test;
current_isref = zeros(NTEST, 1);
current_mos = zeros(NTEST, 1);

ok = 0;
for ii=1:NTEST
    current_isref(ii) = get(findobj('tag', ['isref', num2str(ii)]), 'value');
    current_mos(ii) = str2double(get(findobj('tag', ['mos', num2str(ii)]), 'string'));
    if ~(current_mos(ii)<=5 && current_mos(ii)>=1)
        errordlg('MOS must be a number in the range [1,5]', 'Input Error', 'on');
        return
    end
end
if sum(current_isref) ~=1
    errordlg('Please select the hidden reference', 'Input Error', 'on');
    return
end

if CURRENT_AUDIO_INDEX(1)>size(RESULT_ISREF, 2)     % new test results
    RESULT_ISREF = [RESULT_ISREF, current_isref];
    RESULT_MOS = [RESULT_MOS, current_mos];
    RESULT_COMMENT = [RESULT_COMMENT, CURRENT_COMMENT];
else                                                            % test before, update the results
    RESULT_ISREF(:, CURRENT_AUDIO_INDEX(1)) = current_isref;
    RESULT_MOS(:, CURRENT_AUDIO_INDEX(1)) = current_mos;
    RESULT_COMMENT(:, CURRENT_AUDIO_INDEX(1)) = CURRENT_COMMENT;
end
ok = 1;
% --- EOF : save_current_result

%% Function: Process next or previous
function [] = proc_changeref(h, direction)
globalvar_listening_test;
if isempty(CURRENT_AUDIO)
    errordlg('No audio library loaded.');
    return
end

set(h, 'enable', 'off');            % disable multiple click
stop_player;
stop_timer;
set(findobj('tag', 'slider_playprogress'), 'value', 0);

CURRENT_AUDIO_INDEX(1) = CURRENT_AUDIO_INDEX(1) + direction;
CURRENT_AUDIO_INDEX(2) = 0;

set(findobj('tag', 'text_refname'), 'string', AUDIO_LIST{REF_ORDER(CURRENT_AUDIO_INDEX(1))});

if direction==+1 && CURRENT_AUDIO_INDEX(1)>size(TEST_ORDER, 2)
    if strcmpi(MODE, 'admin')
        current_test_order = 1:NTEST;
    else
        current_test_order = randperm(NTEST);
    end
    TEST_ORDER = [TEST_ORDER, current_test_order(:)];
end

readaudio;

str = sprintf('%d of %d', CURRENT_AUDIO_INDEX(1), min(NREF, MIN_TEST));
set(findobj('tag', 'text_progress'), 'string', str);

if CURRENT_AUDIO_INDEX(1)>=min(NREF, MIN_TEST)
    set(findobj('tag', 'pushbutton_finish'), 'enable', 'on');
end

if CURRENT_AUDIO_INDEX(1)==NREF
    set(findobj('tag', 'pushbutton_next'), 'enable', 'off');
%     set(findobj('tag', 'pushbutton_finish'), 'enable', 'on');
elseif CURRENT_AUDIO_INDEX(1)==1
    set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
else
    set(findobj('tag', 'pushbutton_previous'), 'enable', 'on');
    set(findobj('tag', 'pushbutton_next'), 'enable', 'on');
%     set(findobj('tag', 'pushbutton_finish'), 'enable', 'off');
end

% display isref and mos
if CURRENT_AUDIO_INDEX(1)<=size(RESULT_ISREF,2)
    for ii=1:NTEST
        set(findobj('tag', ['isref', num2str(ii)]), 'value', RESULT_ISREF(ii, CURRENT_AUDIO_INDEX(1)));
        set(findobj('tag', ['mos', num2str(ii)]), 'string', num2str(RESULT_MOS(ii, CURRENT_AUDIO_INDEX(1))));
        if RESULT_ISREF(ii, CURRENT_AUDIO_INDEX(1))==1
            set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'off');
        else
            set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on');
        end
    end
    CURRENT_COMMENT = RESULT_COMMENT(:, CURRENT_AUDIO_INDEX(1));
else
    for ii=1:NTEST
        set(findobj('tag', ['isref', num2str(ii)]), 'value', 0);
        set(findobj('tag', ['mos', num2str(ii)]), 'enable', 'on', 'string', '');
    end
    CURRENT_COMMENT = repmat({''}, NTEST, 1);
end

% 

% --- EOF : proc_changeref


% --- Executes on button press in pushbutton_previous.
function pushbutton_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
if strcmpi(LIB_MODE, 'write')
    if NTEST<=2
        set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
    end
    set(findobj('tag', 'pushbutton_next'), 'enable', 'on');
    
    set(findobj('tag', ['play', num2str(NTEST)]), 'visible', 'off');
    set(findobj('tag', ['mos', num2str(NTEST)]), 'visible', 'off');
    set(findobj('tag', ['mos', num2str(NTEST)]), 'string', '');
    if length(DIR_LIST)>NTEST
        DIR_LIST(NTEST+1) = [];
    end
    if size(AUDIO_LIST, 2)>NTEST
        AUDIO_LIST(:, NTEST+1) = [];
    end
    NTEST = NTEST-1;
    
elseif strcmpi(LIB_MODE, 'read')    
    ok = save_current_result;
    if ok
        proc_changeref(hObject, -1);
    end
end

% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;

if strcmpi(LIB_MODE, 'write')
    NTEST = NTEST+1;
    set(findobj('tag', ['play', num2str(NTEST)]), 'visible', 'on');
    set(findobj('tag', ['mos', num2str(NTEST)]), 'visible', 'on');
    set(findobj('tag', 'pushbutton_previous'), 'enable', 'on');
    
    if isempty(findobj('tag', ['play', num2str(NTEST+1)]))
        set(findobj('tag', 'pushbutton_next'), 'enable', 'off');
    end
    if NTEST>1
        set(findobj('tag', 'pushbutton_finish'), 'enable', 'on');
    end
elseif strcmpi(LIB_MODE, 'read')
    ok = save_current_result;
    if ok
        proc_changeref(hObject, 1);
    end
end

% --- Executes on button press in pushbutton_finish.
function pushbutton_finish_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;

if strcmpi(LIB_MODE, 'write')
    if size(AUDIO_LIST, 2)==0 || isempty(AUDIO_LIST)
        errordlg('No reference file specified.');
        return
    end
    filelist = cell(size(AUDIO_LIST,1), NTEST+1);
    for ii=1:NTEST
        if length(DIR_LIST)<=ii || isempty(DIR_LIST(ii+1))
            errordlg(['No directory specified in ', char(ii-1+'A')]);
            return
        end
        filename_template = get(findobj('tag', ['mos', num2str(ii)]), 'string');        
        try
            testfile = output_filename_gen(AUDIO_LIST(:,1), DIR_LIST{ii+1}, filename_template);
        catch
            a = lasterror;
            errstr = sprintf(['Error in ', char(ii-1+'A'), '\n',a.message]);
            errordlg(errstr);
            return
        end
        for jj=1:length(testfile)
            if exist(testfile{jj})~=2
                errordlg(['Some files do not exist in ', char(ii-1+'A')]);
                return
            else
                [pathstr_temp, namestr, ext] = fileparts(testfile{jj});
                filelist{jj, ii+1} = [namestr, ext];
            end
        end        
    end
    filelist(:, 1) = AUDIO_LIST(:,1);
    list_title = {'Reference'};
    for ii=1:NTEST
        list_title = [list_title, {['Test ', num2str(ii)]}];
    end
    [libname, libdir] = uiputfile('*.xls','Save as','untitled');
    if ~isnumeric(libname)
        xlswrite(fullfile(libdir, libname), [list_title; DIR_LIST; filelist]);
    end
    
elseif strcmpi(LIB_MODE, 'read')
    stop_player;
    stop_timer;
    set(findobj('tag', 'slider_playprogress'), 'value', 0);
    ok = save_current_result;
    CURRENT_AUDIO_INDEX(2) = 0;
    if ok
        output_isref = [RESULT_ISREF, zeros(NTEST, NREF-size(RESULT_ISREF,2))];
        output_mos = [RESULT_MOS, zeros(NTEST, NREF-size(RESULT_MOS,2))];
        output_comment = [RESULT_COMMENT, repmat({''}, NTEST, NREF-size(RESULT_COMMENT,2))];
        
        % reorder the results
        [temp, map2ref] = sort(REF_ORDER, 'ascend');
        [temp, map2test] = sort(TEST_ORDER, 'ascend');
        for ii=1:size(map2test, 2)
            output_isref(:,ii) = output_isref(map2test(:,ii), ii);
        end        
        output_isref = output_isref(1:end, map2ref);

        for ii=1:size(map2test, 2)
            output_mos(:,ii) = output_mos(map2test(:,ii), ii);
        end        
        output_mos = output_mos(1:end, map2ref);
        
        for ii=1:size(map2test, 2)
            output_comment(:,ii) = output_comment(map2test(:,ii), ii);
        end        
        output_comment = output_comment(1:end, map2ref);
        
        
        avg_mos = sum(output_mos,2)/size(RESULT_MOS,2);
        avg_discrim = sum(output_isref,2)/size(RESULT_ISREF,2);
        
        disp('*************************************');
        disp(['Results for User: ', CURRENT_USER]);
        disp(['Number of trials: ', num2str(size(RESULT_MOS,2))]);  
        disp('Average MOS: ');
        str_mos = sprintf('%.2f', avg_mos(1));
        disp(['Reference: ', str_mos]);
        for ii=2:NTEST
            str_mos = sprintf('%.2f', avg_mos(ii));
            disp(['Test ', num2str(ii-1), ' : ', str_mos]);
        end

        disp('Discrimination: ');
        str_isref = sprintf('%.1f%%', 100*avg_discrim(1));
        disp(['Hit rate: ', str_isref]);
        for ii=2:NTEST
            str_isref = sprintf('%.1f%%', 100*avg_discrim(ii));
            disp(['Mistake for Test ', num2str(ii-1), ' : ', str_isref]);
        end

        if isempty(LT_Report_Filename)
            LT_Report_Filename = fullfile(LT_Output_Dir, ['listeningtest_', CURRENT_USER, '_', datestr(now, 'yyyymmddTHHMMSS'),'.xls']);
        end
        
        list_title_file = {'Reference'};
        list_title_mos = {'MOS Ref'};
        for ii=1:NTEST-1
            list_title_file = [list_title_file, {['Test ', num2str(ii)]}];
            list_title_mos = [list_title_mos, {['MOS ', num2str(ii)]}];
        end
        list_title_file = [list_title_file; DIR_LIST];
        list_title_mos = [list_title_mos; num2cell(avg_mos(:).')];
        
        list_title = [list_title_file, list_title_mos, {'Discrimination'; avg_discrim(1)}, {'Comments'; ''}];  
        
        isref_idx = bin2dec(num2str(output_isref(end:-1:1, :).'));
        isref_idx = ceil(log2(isref_idx+1));                % change binary vector to index
        
        result = [output_mos.', isref_idx];
        
        result_cell = cell(size(result));   % change to cell, and make the results of untested clips empty
        ref_idx = find(result~=0);
        result_cell(ref_idx)=num2cell(result(ref_idx));
        
        comment_cell = cell(NREF, 1);
        for jj=1:NREF
            if ~isempty(output_comment{1, jj})
                str = sprintf(['Ref: ', output_comment{1, jj}, '\n']);
            else
                str = '';
            end
            for ii=2:NTEST
                if ~isempty(output_comment{ii, jj})
                    str = [str, sprintf(['Test ', num2str(ii-1), ': ', output_comment{ii, jj}, '\n'])];
                end
            end
            comment_cell{jj} = str(1:end-1);            % delete the last \n
        end
        
        h = helpdlg('Generating report ... Please wait', 'Saving...');
        xlswrite(LT_Report_Filename, [list_title; [AUDIO_LIST, result_cell], comment_cell]);
        
        fprintf(1, 'Saved report file: %s\n', LT_Report_Filename);
        close(h);
        
        str = sprintf('Results saved.\n\nYou can press next to continue or have a break.\n\nThanks for your participation!\n');
        logofile = 'happy.gif';
        if exist(logofile)==2
            [iconData, iconCmap]=imread(logofile);
            h = msgbox(str,'Thanks','custom',iconData,iconCmap, 'replace');
            set(h, 'color',[1 1 1]);
        else
            h = helpdlg(str, 'Thanks');
        end
%         a = get(h, 'children');
%         set(get(a(2), 'children'), 'FontWeight','bold');
    else
        return
    end
end

%% Read audio clips
function [] = readaudio()
globalvar_listening_test;
for jj=1:NTEST
    idir = DIR_LIST{jj};
    ifile = AUDIO_LIST{REF_ORDER(CURRENT_AUDIO_INDEX(1)), jj};
    [CURRENT_AUDIO{jj}, FS{jj}, NBIT{jj}] = wavread(fullfile(idir, ifile));
end
% --- EOF : readaudio

%% Process pushbutton tagged play0~playn
% process when press playn
function proc_play(h)
globalvar_listening_test;
len_prefix = 4;
current_tag = get(h, 'tag');
id = str2num(current_tag(len_prefix+1:end));

if strcmpi(LIB_MODE, 'write')
    dest_dir = uigetdir(cd);
    if isnumeric(dest_dir)            % click 'cancel'
        return
    else
        DIR_LIST(id+1) = {dest_dir};
    end
    
elseif strcmpi(LIB_MODE, 'read')
    if isempty(CURRENT_AUDIO)
        errordlg('No audio library loaded.');
        return
    end

    if id==0
        CURRENT_AUDIO_INDEX(2) = 1;
    else
        CURRENT_AUDIO_INDEX(2) = TEST_ORDER(id, CURRENT_AUDIO_INDEX(1));
    %             find(TEST_ORDER(:, CURRENT_AUDIO_INDEX(1))==id);
    end
    
    xlen = zeros(length(CURRENT_AUDIO), 1);
    for ii=1:length(CURRENT_AUDIO)
        xlen(ii) = length(CURRENT_AUDIO{ii});
    end
    PLAYED_LENGTH = min(xlen);
    
    x = CURRENT_AUDIO{CURRENT_AUDIO_INDEX(2)};
    fs = FS{CURRENT_AUDIO_INDEX(2)};
    nbit = NBIT{CURRENT_AUDIO_INDEX(2)};
    
    x = x(1:PLAYED_LENGTH, :);
    td = length(x)/fs;

    set(findobj('tag', 'text_duration'), 'string', sprintf('%d  seconds', round(td)));
    set(findobj('tag', 'slider_playprogress'), 'value', 0);

    stop_timer;

    t = timer('tag', 'timer', 'ExecutionMode', 'fixedRate', 'Period', round(td/100*1e3)/1e3);
    t.TimerFcn = {'timer_callback_fcn', findobj('tag', 'slider_playprogress')};
    start(t)
    if strcmpi(PLAYED_CHANNEL, 'stereo')
        wavplayer(x, fs, nbit);
    elseif strcmpi(PLAYED_CHANNEL, 'left')
        wavplayer(x(:, 1), fs, nbit);
    elseif strcmpi(PLAYED_CHANNEL, 'right')
        wavplayer(x(:, min(size(x,2),2)), fs, nbit);
    end
end
% --- EOF : proc_play

% --- Executes on button press in play0.
function play0_Callback(hObject, eventdata, handles)
% hObject    handle to play0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
if strcmpi(LIB_MODE, 'write')
    [filename, pathname] = uigetfile('*.wav', 'Select Reference Files', 'multiselect', 'on');

    if isnumeric(filename)               % click 'cancel'
        return
    elseif ~iscell(filename)                             % for single file input, filename is a string
            filename = {filename};
    end
    DIR_LIST(1)= {pathname};
    AUDIO_LIST = filename(:);
    
elseif strcmpi(LIB_MODE, 'read')
    proc_play(hObject);
end

% --- Executes on button press in play1.
function play1_Callback(hObject, eventdata, handles)
% hObject    handle to play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play2.
function play2_Callback(hObject, eventdata, handles)
% hObject    handle to play2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play3.
function play3_Callback(hObject, eventdata, handles)
% hObject    handle to play3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play4.
function play4_Callback(hObject, eventdata, handles)
% hObject    handle to play4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play5.
function play5_Callback(hObject, eventdata, handles)
% hObject    handle to play5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play6.
function play6_Callback(hObject, eventdata, handles)
% hObject    handle to play6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --- Executes on button press in play7.
function play7_Callback(hObject, eventdata, handles)
% hObject    handle to play7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_play(hObject);

% --------------------------------------------------------------------
% --- Executes on button press in stop_play.
function stop_play_Callback(hObject, eventdata, handles)
% hObject    handle to stop_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
stop_player;
if get(findobj('tag', 'slider_playprogress'), 'value')~=0
    set(findobj('tag', 'slider_playprogress'), 'value', 1);
end

%% Menu

function menufile_Callback(hObject, eventdata, handles)
% hObject    handle to menufile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menufile_loadlib_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_loadlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;

[filename, pathname] = uigetfile('*.xls', 'multiselect', 'off');
if isnumeric(filename)      % press cancel
    return
end

set_libmode('read');

LT_Lib_Filename = fullfile(pathname, filename);
[var_num, var_txt, var_raw] = xlsread(LT_Lib_Filename);

xls_extrarow = 2;
s = size(var_txt) - [xls_extrarow, 0];
AUDIO_LIST = cell(s(1), min(s(2), MAX_NTEST));
DIR_LIST = cell(1, min(s(2), MAX_NTEST));
% Check lib file
for jj=1:min(s(2), MAX_NTEST)
    idir = var_txt{xls_extrarow, jj};
    for ii=1: s(1)
        ifile = fullfile(idir, var_txt{ii+xls_extrarow, jj});
        [pathstr, filename, ext] = fileparts(ifile);
        if ~strcmpi(ext, '.wav')
            errordlg('Library contains some non-wav files!');
            set_libmode('write');
            return
        elseif exist(ifile)~=2
            errordlg('Some files do not exist in the library!');
            set_libmode('write');
            return 
        end
        AUDIO_LIST{ii,jj} = [filename, ext];
    end
    DIR_LIST{jj} = idir;
end

if s(2)>MAX_NTEST
    msg = sprintf('Too many sequences under test. Only first %d columns loaded.', MAX_NTEST);
    msgbox(msg, 'Warning','warn');
    NTEST = MAX_NTEST;
else
    for ii=1:s(2)
        set(findobj('tag', ['play', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['mos', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['isref', num2str(ii)]), 'visible', 'on');
        set(findobj('tag', ['mos', num2str(ii)]), 'string', '');
        set(findobj('tag', ['isref', num2str(ii)]), 'value', 0);
        set(findobj('tag', ['comment', num2str(ii)]), 'visible', 'on');
    end
    for ii=s(2)+1:MAX_NTEST
        set(findobj('tag', ['play', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['mos', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['isref', num2str(ii)]), 'visible', 'off');
        set(findobj('tag', ['comment', num2str(ii)]), 'visible', 'off');
    end
    NTEST = s(2);
end
NREF = s(1);

CURRENT_AUDIO = cell(NTEST,1);
FS = cell(NTEST,1);
NBIT = cell(NTEST,1);

str = sprintf('%d of %d', CURRENT_AUDIO_INDEX(1), min(NREF, MIN_TEST));
set(findobj('tag', 'text_progress'), 'string', str);
str = sprintf('Total %d', NREF);
set(findobj('tag', 'text_nref'), 'string', str);

if strcmpi(MODE, 'admin')
    TEST_ORDER = (1:NTEST).';
    REF_ORDER = 1:NREF;
end
set(findobj('tag', 'pushbutton_previous'), 'enable', 'off');
set(findobj('tag', 'pushbutton_finish'), 'enable', 'off');

CURRENT_COMMENT = repmat({''}, NTEST, 1);

initial_testpanel;

readaudio;

% --------------------------------------------------------------------
function menufile_createlib_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_createlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
set_libmode('write');

% --------------------------------------------------------------------
function menufile_reset_Callback(hObject, eventdata, handles)
% hObject    handle to menufile_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
reset;

% --------------------------------------------------------------------
function menuview_Callback(hObject, eventdata, handles)
% hObject    handle to menuview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuview_currentreport_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_currentreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
if exist(LT_Report_Filename)==2
    dos(['explorer ', LT_Report_Filename]);
elseif isempty(LT_Report_Filename)
    errordlg('No report file generated.');
else
    errordlg(['Cannot find ''', LT_Report_Filename, '''.']);
end

% --------------------------------------------------------------------
function menuview_report_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
[filename, pathname] = uigetfile(fullfile(LT_Output_Dir, '*.xls'), 'multiselect', 'off');
if ~isnumeric(filename)
    rpt_filename = fullfile(pathname, filename);
    dos(['explorer ', rpt_filename]);
end

% --------------------------------------------------------------------
function menuview_currentlib_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_currentlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
if exist(LT_Lib_Filename)==2
    dos(['explorer ', LT_Lib_Filename]);
elseif isempty(LT_Lib_Filename)
    errordlg('No audio library loaded.');
else
    errordlg(['Cannot find ''', LT_Lib_Filename, '''.']);
end

% --------------------------------------------------------------------
function menuview_lib_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_lib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
[filename, pathname] = uigetfile(fullfile(cd, '*.xls'), 'multiselect', 'off');
if ~isnumeric(filename)
    lib_filename = fullfile(pathname, filename);
    dos(['explorer ', lib_filename]);
end

% --------------------------------------------------------------------
function menuview_outputdir_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_outputdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
if isdir(LT_Output_Dir)
    dos(['explorer ', LT_Output_Dir]);
elseif isempty(LT_Output_Dir)
    errordlg('No output directory specified.');
else
    errordlg(['Directory ''', LT_Output_Dir, ''' does not exist.']);
end
% --------------------------------------------------------------------
function menuview_userlist_Callback(hObject, eventdata, handles)
% hObject    handle to menuview_userlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
USER_LIST

% --------------------------------------------------------------------
function menusettings_Callback(hObject, eventdata, handles)
% hObject    handle to menusettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menusettings_password_Callback(hObject, eventdata, handles)
% hObject    handle to menusettings_password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
ADMIN_PWD = inputdlg('Administrator password');
if isempty(ADMIN_PWD)           % press cancel
    ADMIN_PWD = '';
else
    ADMIN_PWD = ADMIN_PWD{1};
end

% --------------------------------------------------------------------
function menusettings_outputdir_Callback(hObject, eventdata, handles)
% hObject    handle to menusettings_outputdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
global Dir_Output;      % output dir of watermarking platform
if isdir(LT_Output_Dir)
    odir = uigetdir(LT_Output_Dir);
elseif isdir(Dir_Output)
    odir = uigetdir(Dir_Output);
else
    odir = uigetdir(cd);
end
if ~isnumeric(odir)
    LT_Output_Dir = odir;
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
str = sprintf('Subjective Listenting Test Platform v1.0\nPeng Zhang, Tsinghua Univ.  May-2009\nAll rights reserved.');
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

helpdoc_name = 'Subjective Listening Test Platform User Guide.chm';
if exist(helpdoc_name)==2
    dos(['explorer ', which(helpdoc_name)]);
else
    errordlg(['Cannot find ''', helpdoc_name, '''']);
    return
end

% --------------------------------------------------------------------
function edit_ntest_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ntest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ntest as text
%        str2double(get(hObject,'String')) returns contents of edit_ntest as a double
globalvar_listening_test;
v = str2num(get(gcbo, 'string'));
if isempty(v) || v~=ceil(v) || v<=0
    errordlg('Input must be a positive integer.');
    return
end
MIN_TEST = v;

% --- Executes during object creation, after setting all properties.
function edit_ntest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ntest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in popupmenu_ref_rearrange.
function popupmenu_ref_rearrange_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref_rearrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_ref_rearrange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ref_rearrange
globalvar_listening_test;
v = get(gcbo, 'value');
switch v
    case 1
        PERM_ORDER = 'none';
    case 2
        PERM_ORDER = 'random';
    otherwise
        PERM_ORDER = 'none';
end

% --- Executes during object creation, after setting all properties.
function popupmenu_ref_rearrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ref_rearrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on selection change in popupmenu_channel.
function popupmenu_channel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel
globalvar_listening_test;
v = get(gcbo, 'value');
switch v
    case 1
        PLAYED_CHANNEL = 'stereo';
    case 2
        PLAYED_CHANNEL = 'left';
    case 3
        PLAYED_CHANNEL = 'right';
    otherwise
        PLAYED_CHANNEL = 'stereo';
end

% --- Executes during object creation, after setting all properties.
function popupmenu_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Function: Process comments
function [] = proc_comment(h)
globalvar_listening_test;

len_prefix = 7;                         % length of 'comment'
current_tag = get(h, 'tag');
id = str2num(current_tag(len_prefix+1:end));

prompt = {'Enter comments:'};
dlg_title = ['Comments on ', char('A'-1+id)];
num_lines = [5, 35];

if isempty(CURRENT_COMMENT{id})
    default_str = {''};
else
    default_str = CURRENT_COMMENT(id);
end
answer = inputdlg(prompt,dlg_title,num_lines,default_str);

if ~isempty(answer)         % press ok
%     while size(answer{1},1)>1
%         options.WindowStyle='normal';
%         answer = inputdlg(prompt,dlg_title,num_lines,answer, options);
%         errordlg('Do not change line while typing the text.', '', 'on');        
%     end
    ans_mat = answer{1};
    str = '';
    if ~isempty(ans_mat)
        for ii=1:size(ans_mat,1)-1          % change char matrix to string
            str = [str, sprintf([ans_mat(ii,:), '\n'])];
        end
        str = [str, ans_mat(end,:)];
    end
    
    CURRENT_COMMENT(id) = {str};
end

% --- Executes on button press in comment1.
function comment1_Callback(hObject, eventdata, handles)
% hObject    handle to comment1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment2.
function comment2_Callback(hObject, eventdata, handles)
% hObject    handle to comment2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment3.
function comment3_Callback(hObject, eventdata, handles)
% hObject    handle to comment3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment4.
function comment4_Callback(hObject, eventdata, handles)
% hObject    handle to comment4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment5.
function comment5_Callback(hObject, eventdata, handles)
% hObject    handle to comment5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment6.
function comment6_Callback(hObject, eventdata, handles)
% hObject    handle to comment6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);

% --- Executes on button press in comment7.
function comment7_Callback(hObject, eventdata, handles)
% hObject    handle to comment7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalvar_listening_test;
proc_comment(hObject);




% --- Creates and returns a handle to the GUI figure. 
function h1 = listening_test_gui_export_LayoutFcn(policy)
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
    'edit', 24, ...
    'pushbutton', 31, ...
    'uipanel', 67, ...
    'radiobutton', 19, ...
    'text', 92, ...
    'slider', 2, ...
    'axes', 4, ...
    'listbox', 4, ...
    'popupmenu', 3), ...
    'override', 1, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'F:\audio_watermark_release20110725\listening_test_gui.m', ...
    'lastFilename', 'F:\audio_watermark_release20110725\listening_test_gui.fig');
appdata.lastValidTag = 'mainfig_listening_test';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'mainfig_listening_test');

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','listening_test_gui',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[20.98404194812 29.67743169791],...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.666666666667 19.8125 110 41.625],...
'Resize','off',...
'DeleteFcn',@(hObject,eventdata)listening_test_gui('mainfig_listening_test_DeleteFcn',hObject,eventdata,guidata(hObject)),...
'HandleVisibility','callback',...
'Tag','mainfig_listening_test',...
'UserData',[],...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_newuser';

h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('pushbutton_newuser_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[8.66666666666667 35.6875 14.5 1.6875],...
'String','New User',...
'Tag','pushbutton_newuser',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'slider_playprogress';

h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)listening_test_gui('slider_playprogress_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[48.1666666666667 25.4375 38.3333333333333 0.75],...
'Style','slider',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('slider_playprogress_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','slider_playprogress',...
'UserData',[]);

appdata = [];
appdata.lastValidTag = 'uipanel1';

h4 = uibuttongroup(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'ForegroundColor',[0.501960784313725 0.501960784313725 0.501960784313725],...
'Title',blanks(0),...
'Tag','uipanel1',...
'Clipping','on',...
'Position',[8.66666666666667 37.8125 21 3.1875],...
'SelectedObject',[],...
'SelectionChangeFcn',[],...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'radiobutton_admin';

h5 = uicontrol(...
'Parent',h4,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('radiobutton_admin_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[0.344262295081967 1.79162719535667 18.4180327868853 1.16421568627451],...
'String','Administrator',...
'Style','radiobutton',...
'Value',1,...
'Tag','radiobutton_admin',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'radiobutton_user';

h6 = uicontrol(...
'Parent',h4,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('radiobutton_user_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[0.344262295081967 0.198489940454708 16.6967213114754 1.16421568627451],...
'String','User',...
'Style','radiobutton',...
'Tag','radiobutton_user',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menufile';

h7 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)listening_test_gui('menufile_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&File',...
'Tag','menufile',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_loadlib';

h8 = uimenu(...
'Parent',h7,...
'Accelerator','L',...
'Callback',@(hObject,eventdata)listening_test_gui('menufile_loadlib_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Load Library...',...
'Tag','menufile_loadlib',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_createlib';

h9 = uimenu(...
'Parent',h7,...
'Accelerator','E',...
'Callback',@(hObject,eventdata)listening_test_gui('menufile_createlib_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Create Library',...
'Tag','menufile_createlib',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menufile_reset';

h10 = uimenu(...
'Parent',h7,...
'Callback',@(hObject,eventdata)listening_test_gui('menufile_reset_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Reset',...
'Tag','menufile_reset',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_previous';

h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('pushbutton_previous_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','demi',...
'Position',[84.6666666666667 15.5625 17.5 2],...
'String','<< Previous',...
'Tag','pushbutton_previous',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_next';

h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('pushbutton_next_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','demi',...
'Position',[84.6666666666667 11.0625 17.5 2],...
'String','  Next >>',...
'Tag','pushbutton_next',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test1';

h13 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test1',...
'Clipping','on',...
'Position',[8.83333333333333 19.25 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play1';

h14 = uicontrol(...
'Parent',h13,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play1_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','A',...
'Tag','play1',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref1';

h15 = uicontrol(...
'Parent',h13,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref1_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos1';

h16 = uicontrol(...
'Parent',h13,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos1_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.3333333333333 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos1');

appdata = [];
appdata.lastValidTag = 'comment1';

h17 = uicontrol(...
'Parent',h13,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment1_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.125 3.5 1.6875],...
'String','...',...
'Tag','comment1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel52';

h18 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipanel52',...
'Clipping','on',...
'Position',[34 29.6875 72.3333333333333 11.3125],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel31';

h19 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel31',...
'UserData',[],...
'Clipping','on',...
'Position',[1.5 0.5625 68.1666666666667 10.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel9';

h20 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel9',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 4 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text17';

h21 = uicontrol(...
'Parent',h20,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1.83333333333333 0.0625 7.16666666666667 1.4375],...
'String','3',...
'Style','text',...
'Tag','text17',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel10';

h22 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel10',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 2.3125 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text18';

h23 = uicontrol(...
'Parent',h22,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1.83333333333333 0.0625 7.16666666666667 1.4375],...
'String','2',...
'Style','text',...
'Tag','text18',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel11';

h24 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel11',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 0.625 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text19';

h25 = uicontrol(...
'Parent',h24,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1.83333333333333 0.0625 7 1.4375],...
'String','1',...
'Style','text',...
'Tag','text19',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel13';

h26 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel13',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 7.375 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text21';

h27 = uicontrol(...
'Parent',h26,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.125 14 1.4375],...
'String','Excellent',...
'Style','text',...
'Tag','text21',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel18';

h28 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel18',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 5.6875 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text27';

h29 = uicontrol(...
'Parent',h28,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.125 13.5 1.4375],...
'String','Good',...
'Style','text',...
'Tag','text27',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel19';

h30 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel19',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 4 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text28';

h31 = uicontrol(...
'Parent',h30,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.125 13.8333333333333 1.4375],...
'String','Fair',...
'Style','text',...
'Tag','text28',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel20';

h32 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel20',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 2.3125 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text29';

h33 = uicontrol(...
'Parent',h32,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.125 13.8333333333333 1.4375],...
'String','Poor',...
'Style','text',...
'Tag','text29',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel21';

h34 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel21',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 0.625 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text30';

h35 = uicontrol(...
'Parent',h34,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.0625 14.1666666666667 1.4375],...
'String','Bad',...
'Style','text',...
'Tag','text30',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel22';

h36 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel22',...
'UserData',[],...
'Clipping','on',...
'Position',[12.8333333333333 9.0625 15.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text32';

h37 = uicontrol(...
'Parent',h36,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.666666666666667 0.125 13.5 1.4375],...
'String','Quality',...
'Style','text',...
'Tag','text32',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel23';

h38 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel23',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 9.0625 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text33';

h39 = uicontrol(...
'Parent',h38,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.6666666666667 1.4375],...
'String','Impairment',...
'Style','text',...
'Tag','text33',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel26';

h40 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel26',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 7.375 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text36';

h41 = uicontrol(...
'Parent',h40,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.5 1.4375],...
'String','Imperceptible',...
'Style','text',...
'Tag','text36',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel27';

h42 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel27',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 5.6875 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text37';

h43 = uicontrol(...
'Parent',h42,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.3333333333334 1.4375],...
'String','Perceptible but not annoying',...
'Style','text',...
'Tag','text37',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel28';

h44 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel28',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 4 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text38';

h45 = uicontrol(...
'Parent',h44,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.5 1.4375],...
'String','Slightly annoying',...
'Style','text',...
'Tag','text38',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel29';

h46 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel29',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 2.3125 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text39';

h47 = uicontrol(...
'Parent',h46,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.5 1.4375],...
'String','Annoying',...
'Style','text',...
'Tag','text39',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel30';

h48 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel30',...
'UserData',[],...
'Clipping','on',...
'Position',[28.6666666666667 0.625 40.8333333333333 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text40';

h49 = uicontrol(...
'Parent',h48,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[0.5 0.0625 39.3333333333334 1.4375],...
'String','Very annoying',...
'Style','text',...
'Tag','text40',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel50';

h50 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel50',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 7.375 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel51';

h51 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel51',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 9.0625 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel36';

h52 = uipanel(...
'Parent',h18,...
'Units','characters',...
'BorderType','line',...
'HighlightColor',[0 0 0],...
'Tag','uipanel36',...
'UserData',[],...
'Clipping','on',...
'Position',[1.66666666666667 5.6875 11.1666666666667 1.6875],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text68';

h53 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[3.66666666666667 5.8125 7.16666666666667 1.5],...
'String','4',...
'Style','text',...
'Tag','text68',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text69';

h54 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[3.66666666666667 7.5 7.16666666666667 1.5],...
'String','5',...
'Style','text',...
'Tag','text69',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text70';

h55 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[3.66666666666667 9.1875 7.16666666666667 1.5],...
'String','MOS',...
'Style','text',...
'Tag','text70',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play0';

h56 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play0_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'Position',[10 24.6875 13.8333333333333 2.125],...
'String','Ref.',...
'Tag','play0',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview';

h57 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&View',...
'Tag','menuview',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_currentreport';

h58 = uimenu(...
'Parent',h57,...
'Accelerator','R',...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_currentreport_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Current Report',...
'Tag','menuview_currentreport',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_report';

h59 = uimenu(...
'Parent',h57,...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_report_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Report...',...
'Tag','menuview_report',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_currentlib';

h60 = uimenu(...
'Parent',h57,...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_currentlib_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Current Library',...
'Tag','menuview_currentlib',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_lib';

h61 = uimenu(...
'Parent',h57,...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_lib_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Library...',...
'Tag','menuview_lib',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_outputdir';

h62 = uimenu(...
'Parent',h57,...
'Accelerator','D',...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_outputdir_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Output &Directory',...
'Tag','menuview_outputdir',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuview_userlist';

h63 = uimenu(...
'Parent',h57,...
'Callback',@(hObject,eventdata)listening_test_gui('menuview_userlist_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&User List',...
'Tag','menuview_userlist',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_isref';

h64 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'Position',[24.8333333333333 22.0625 16.1666666666667 1.625],...
'String','=Ref.?',...
'Style','text',...
'TooltipString','select the unique hidden reference',...
'Tag','text_isref',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_mos';

h65 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[37.5 22.0625 24 1.625],...
'String','MOS (1.0 -- 5.0)',...
'Style','text',...
'Tag','text_mos',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_play';

h66 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'Position',[8.66666666666667 27.25 16.1666666666667 1.625],...
'String','Play',...
'Style','text',...
'Tag','text_play',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton_finish';

h67 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('pushbutton_finish_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','demi',...
'Position',[83.8333333333333 6.25 19.6666666666667 2.3125],...
'String','Finish & Save',...
'Tag','pushbutton_finish',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_duration';

h68 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'HorizontalAlignment','right',...
'Position',[24.5 24.875 19.5 1.625],...
'String',blanks(0),...
'Style','text',...
'Tag','text_duration',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test2';

h69 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test2',...
'Clipping','on',...
'Position',[8.83333333333333 16.375 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play2';

h70 = uicontrol(...
'Parent',h69,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play2_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','B',...
'Tag','play2',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref2';

h71 = uicontrol(...
'Parent',h69,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref2_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos2';

h72 = uicontrol(...
'Parent',h69,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos2_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos2');

appdata = [];
appdata.lastValidTag = 'comment2';

h73 = uicontrol(...
'Parent',h69,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment2_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.1875 3.5 1.6875],...
'String','...',...
'Tag','comment2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test3';

h74 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test3',...
'Clipping','on',...
'Position',[8.83333333333333 13.5 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play3';

h75 = uicontrol(...
'Parent',h74,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play3_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','C',...
'Tag','play3',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref3';

h76 = uicontrol(...
'Parent',h74,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref3_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos3';

h77 = uicontrol(...
'Parent',h74,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos3_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos3_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos3');

appdata = [];
appdata.lastValidTag = 'comment3';

h78 = uicontrol(...
'Parent',h74,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment3_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.125 3.5 1.6875],...
'String','...',...
'Tag','comment3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test4';

h79 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test4',...
'Clipping','on',...
'Position',[8.83333333333333 10.625 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play4';

h80 = uicontrol(...
'Parent',h79,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play4_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','D',...
'Tag','play4',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref4';

h81 = uicontrol(...
'Parent',h79,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref4_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos4';

h82 = uicontrol(...
'Parent',h79,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos4_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos4_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos4');

appdata = [];
appdata.lastValidTag = 'comment4';

h83 = uicontrol(...
'Parent',h79,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment4_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.125 3.5 1.6875],...
'String','...',...
'Tag','comment4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test5';

h84 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test5',...
'Clipping','on',...
'Position',[8.83333333333333 7.75 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play5';

h85 = uicontrol(...
'Parent',h84,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play5_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','E',...
'Tag','play5',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref5';

h86 = uicontrol(...
'Parent',h84,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref5_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos5';

h87 = uicontrol(...
'Parent',h84,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos5_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos5_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos5');

appdata = [];
appdata.lastValidTag = 'comment5';

h88 = uicontrol(...
'Parent',h84,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment5_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.0625 3.5 1.6875],...
'String','...',...
'Tag','comment5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test7';

h89 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test7',...
'Clipping','on',...
'Position',[8.83333333333333 2 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play7';

h90 = uicontrol(...
'Parent',h89,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play7_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','G',...
'Tag','play7',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref7';

h91 = uicontrol(...
'Parent',h89,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref7_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos7';

h92 = uicontrol(...
'Parent',h89,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos7_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos7_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos7');

appdata = [];
appdata.lastValidTag = 'comment7';

h93 = uicontrol(...
'Parent',h89,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment7_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.125 3.5 1.6875],...
'String','...',...
'Tag','comment7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_progress';

h94 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'Position',[82 19.3125 22.6666666666667 1.6875],...
'Style','text',...
'Tag','text_progress',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_nref';

h95 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'Position',[81.5 22.125 22.6666666666667 1.6875],...
'Style','text',...
'Tag','text_nref',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_testdir';

h96 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'Position',[9 22.0625 16.1666666666667 1.625],...
'String','Directory',...
'Style','text',...
'Tag','text_testdir',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipane_test6';

h97 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipane_test6',...
'Clipping','on',...
'Position',[8.83333333333333 4.875 69.1666666666667 2.25],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'play6';

h98 = uicontrol(...
'Parent',h97,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('play6_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[1 0 13.8333333333333 2.125],...
'String','F',...
'Tag','play6',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'isref6';

h99 = uicontrol(...
'Parent',h97,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('isref6_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.5 0.375 4.83333333333333 1.1875],...
'String',blanks(0),...
'Style','radiobutton',...
'Tag','isref6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'mos6';

h100 = uicontrol(...
'Parent',h97,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('mos6_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[33.1666666666667 0.125 14.5 1.75],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('mos6_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','mos6');

appdata = [];
appdata.lastValidTag = 'comment6';

h101 = uicontrol(...
'Parent',h97,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('comment6_Callback',hObject,eventdata,guidata(hObject)),...
'FontWeight','bold',...
'Position',[59.8333333333333 0.125 3.5 1.6875],...
'String','...',...
'Tag','comment6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menusettings';

h102 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)listening_test_gui('menusettings_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Settings',...
'Tag','menusettings',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menusettings_password';

h103 = uimenu(...
'Parent',h102,...
'Callback',@(hObject,eventdata)listening_test_gui('menusettings_password_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Password...',...
'Tag','menusettings_password',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menusettings_outputdir';

h104 = uimenu(...
'Parent',h102,...
'Callback',@(hObject,eventdata)listening_test_gui('menusettings_outputdir_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Output Directory...',...
'Tag','menusettings_outputdir',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp';

h105 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)listening_test_gui('menuhelp_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&Help',...
'Tag','menuhelp',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp_about';

h106 = uimenu(...
'Parent',h105,...
'Callback',@(hObject,eventdata)listening_test_gui('menuhelp_about_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&About...',...
'Tag','menuhelp_about',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'menuhelp_userguide';

h107 = uimenu(...
'Parent',h105,...
'Callback',@(hObject,eventdata)listening_test_gui('menuhelp_userguide_Callback',hObject,eventdata,guidata(hObject)),...
'Label','&User''s Guide',...
'Tag','menuhelp_userguide',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_number';

h108 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[8.66666666666667 33.375 16.5 1.5],...
'String','Number of Trials',...
'Style','text',...
'TooltipString','the least number of trials for each listener',...
'Tag','text_number',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'edit_ntest';

h109 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('edit_ntest_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'HorizontalAlignment','right',...
'Position',[26.1666666666667 33.75 6.5 1.375],...
'String',blanks(0),...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('edit_ntest_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','edit_ntest');

appdata = [];
appdata.lastValidTag = 'text_ref_rearrange';

h110 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[8.66666666666667 31.625 13.3333333333333 1.1875],...
'String','Ref rearrange',...
'Style','text',...
'TooltipString','reference rearrangement',...
'Tag','text_ref_rearrange',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_refname';

h111 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'Position',[39.6666666666667 27 55.6666666666667 1.75],...
'Style','text',...
'Tag','text_refname',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_channel';

h112 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[8.66666666666667 29.5625 13.3333333333333 1.1875],...
'String','Channel',...
'Style','text',...
'Tag','text_channel',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text_comment';

h113 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'Position',[63.3333333333333 21.9375 14.5 1.75],...
'String','Comment',...
'Style','text',...
'Tag','text_comment',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'stop_play';

h114 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)listening_test_gui('stop_play_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'Position',[91.8333333333333 24.8125 7.66666666666667 1.9375],...
'String','Stop',...
'Tag','stop_play',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'popupmenu_ref_rearrange';

h115 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('popupmenu_ref_rearrange_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.1666666666667 31.625 11 1.5],...
'String',{  'none'; 'random' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('popupmenu_ref_rearrange_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','popupmenu_ref_rearrange');

appdata = [];
appdata.lastValidTag = 'popupmenu_channel';

h116 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)listening_test_gui('popupmenu_channel_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[22.1666666666667 29.5625 11 1.5],...
'String',{  'stereo'; 'left'; 'right' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)listening_test_gui('popupmenu_channel_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','popupmenu_channel');


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
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

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
    % LISTENING_TEST_GUI_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % LISTENING_TEST_GUI_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallbak(gui_State, varargin{:})
    % LISTENING_TEST_GUI_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % LISTENING_TEST_GUI_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~isa(handle(fig),'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
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
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
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
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
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
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
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

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);
end

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
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


