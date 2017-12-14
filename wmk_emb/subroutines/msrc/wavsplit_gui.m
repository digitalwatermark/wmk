% % Split Wav Files (GUI)
% % Peng Zhang     Tsinghua Univ.    2009.03.06
% % % % % % % % % % % % % % % % % % % 


function wavsplit_gui()

[ifilename, idir] = uigetfile('*.wav', 'multiselect', 'on');

if isnumeric(ifilename)            
    return
end

odir = uigetdir(idir, 'Select Output Directory');
if isnumeric(odir)          
    return
end

prompt = {'Enter output audio duration:','Enter time shift:'};
dlg_title = 'Input parameters for splitting wav file';
num_lines = 1;
def = {'10','0'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if isempty(answer)
    return
end

duration = eval(answer{1});
shift = str2double(answer{2});

period_button = questdlg('Split periodically or just once?','','Once','Periodically','Once');

if isempty(period_button)
    return
end

if ~iscell(ifilename)                    
    ifilename = {ifilename};
end

nfile = length(ifilename) ;
h = progress_indication('Split Completed: ... ');
for ii=1:nfile                   
    [path_temp, name, ext] = fileparts(ifilename{ii});
%     ofile = fullfile(odir, [name, '_', num2str(duration), 's',ext]);
    ofile = fullfile(odir, [name, '_clip',ext]);
    if strcmpi(period_button, 'Periodically')
        wavsplit(fullfile(idir, ifilename{ii}), ofile, duration, shift, duration);
    else
        wavsplit(fullfile(idir, ifilename{ii}), ofile, duration, shift, 0);
    end
    progress_indication(ii, nfile, max(floor(nfile/100),1), h, 'Split Completed: ... ');
end

% --- EOF : wavsplit_gui



function [] = wavsplit(ifilename, ofilename, duration, shift, period)
[x, fs, nbit] = wavread(ifilename);

Nduration = round(duration*fs);
Nshift = round(shift*fs);
Nperiod = round(period*fs);
if length(x)<Nduration+Nshift
    error('Wav file too short');
end

if Nperiod==0    
    y = x(1+Nshift : Nduration+Nshift, :);
    wavwrite(y, fs, nbit, ofilename);
else    
    Nseg = floor((length(x)-Nshift-Nduration)/Nperiod) + 1;
    Ndigit = length(num2str(Nseg));
    [odir, ofile, ext] = fileparts(ofilename);
    
    for ii=1:Nseg
        y = x((ii-1)*Nperiod+Nshift+1 : (ii-1)*Nperiod+Nshift+Nduration,:);
        ofilename = fullfile(odir, [ofile, dec2base(ii, 10, Ndigit), ext]);
        wavwrite(y, fs, nbit, ofilename);
    end
end
% --- EOF : wavsplit