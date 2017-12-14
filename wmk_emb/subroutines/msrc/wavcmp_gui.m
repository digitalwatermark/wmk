% Compare Wav Files (GUI)
% 2009-12-15

function [filename, index, dir1, dir2] = wavcmp_gui()

index = [];
dir2 = [];
[filename, dir1] = uigetfile('*.wav', 'Select wav files of Group 1', 'multiselect', 'on');

if isnumeric(filename)          
    filename = [];
    dir1 = [];
    return
elseif ~iscell(filename)            
        filename = {filename};
end

dir2 = uigetdir(dir1, 'Select directory of Group 2');
if isnumeric(dir2)
    dir2 = [];
    return
end

index = zeros(length(filename), 1);
for ii=1:length(filename)                
    wavfile1 = fullfile(dir1, filename{ii});
    wavfile2 = fullfile(dir2, filename{ii});
    if exist(wavfile2)~=2
        errordlg(['One or more wav files do not exist in ', dir2]);
        return
    end
    [x1, fs1, nbit1] = wavread(wavfile1);
    [x2, fs2, nbit2] = wavread(wavfile2);
    
    if isequal(x1, x2) && fs1==fs2 && nbit1==nbit2
        index(ii) = 1;
    end
end
index = logical(index);
if ~all(index)
    disp('Some wav files are different.');
else
    disp('Wav files are identical.');
end

