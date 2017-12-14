% % Audio alignment
% % Peng Zhang     Tsinghua Univ.    2009.02.25
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [y, yfs, timedelay] = audio_timealign(x_ref, fs_ref, x_tba, fs_tba)
% 

function [y, yfs, timedelay] = audio_timealign(x_ref, fs_ref, x_tba, fs_tba)

y = double(x_tba);
y_class = class(x_tba);
if fs_tba~=fs_ref
    y = resample(y, fs_ref, fs_tba);          
end

Lmax = min([2^19, length(x_ref), length(y)]);

Lx = length(x_ref);
Ly = length(y);

ryx = linxcorr_fft(y(1:Lmax,1), double(x_ref(1:Lmax,1)));   

peak = max(ryx);
peak_pos = find(ryx==peak);

timedelay = peak_pos-Lmax;                     

padding = zeros(Lx-Ly+timedelay,size(y,2));
if timedelay>0
    y = [y(timedelay+1:end,:); padding];
else
    y = [zeros(-timedelay,size(y,2)); y(1:end,:); padding];
end

y = y(1:Lx,:);
eval(['y = ', y_class, '(y);']);
yfs = fs_ref;

return
