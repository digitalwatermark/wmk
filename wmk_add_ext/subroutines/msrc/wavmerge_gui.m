% % Merge Wav Files (GUI)
% % Peng Zhang     Tsinghua Univ.    2009.12.23
% % % % % % % % % % % % % % % % % % % 
% 
% see also:
% wavsplit_gui

function wavmerge_gui()

[ifilename, idir] = uigetfile('*.wav', 'multiselect', 'on');

if isnumeric(ifilename)        
    return
end

if ~iscell(ifilename)                 
%     ifilename = {ifilename};
    warndlg('Cancelled for single wav file input.');
    return
end

odir = uigetdir(idir, 'Select Output Directory');
if isnumeric(odir)           
    return
end

nfile = length(ifilename);
% [path_temp, ifilename{1}, ext] = fileparts(ifilename{1});
lname = length(ifilename{1});
comm_idx = ones(1, lname);
file_idx = zeros(nfile, 1);

for ii=2:nfile                  
%     [path_temp, ifilename{ii}, ext] = fileparts(ifilename{ii});
    if length(ifilename{ii})~=lname
       errordlg('Wav file names must have the same length.');
       return
   end
   comm_idx = and(comm_idx, ~(ifilename{ii}-ifilename{1}));
   
   file_idx(ii) = str2double(ifilename{ii}(~comm_idx));
   if isnan(file_idx(ii))       
       errordlg('One or more wav file names are irregular.');
       return
   end
end
file_idx(1) = str2num(ifilename{1}(~comm_idx));      
ndigit = sum(~comm_idx);
ofilename = ifilename{1}(comm_idx);

ofile = fullfile(odir, ofilename);
if exist(ofile)==2
    ov = questdlg('Target file already exists', '', 'Overwrite', 'Cancel', 'Cancel');
    if isempty(ov) || isequal(ov, 'Cancel')
        return
    end
end

[sorted_idx, file_idx] = sort(file_idx, 'ascend');
if ~all(diff(sorted_idx)==1)
    errordlg('One or more wav files are missing.');
    return
end

 y = [];
 h = progress_indication('Merge Completed: ... ');
for ii=1:nfile
    [x, fs, nbit] = wavread(fullfile(idir, ifilename{file_idx(ii)}), 'double');
    y = [y; single(x)];
    progress_indication(ii, nfile, max(floor(nfile/100),1), h, 'Merge Completed: ... ');
end

wavwrite(y, fs, nbit, ofile);

