% % Save configurations (global variables) to file
% % Peng Zhang    Tsinghua Univ.    2009.02.08

function savecfg(filename)

global_var;

% if exist(filename)     
%     button = questdlg(['''', filename, ''' already exists! Overwrite?'], 'Save As', 'Yes', 'No', 'No');
%     if strcmpi(button, 'No')
%         return;
%     end
% end

fid = fopen(filename, 'w');

% % write file
fprintf(fid, '%%-------------------------------------------------------------------------------------\n');
fprintf(fid, '%% Configurations for Audio Watermarking Platform\n');
fprintf(fid, '%% Config Filename : %s\n', Files_Config);
fprintf(fid, '%% Generated Time : %s\n', datestr(clock));
fprintf(fid, '%%-------------------------------------------------------------------------------------\n');

% % writable configs
fprintf(fid, '\n%% Directory Config\n');
s=who('Dir*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Filename Template Config (Cover file/Stego file ...)\n');
s=who('Filename*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Source Files Config (Cover audio/Watermark file ...)\n');
s=who('Files*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Algorithm Config (Embed/Extract/Sync ...)\n');
s=who('Algorithm*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Key Config\n');
s=who('Key*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Attack Enable/Disable Config (1/0 = enable/disable)\n');
s=who('Attack_On*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Attack Parameters Config\n');
s=who('Attack_Param*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Attack Options Config (see Attack Option Table)\n');
s=who('Attack_Option*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Sweeping Enable/Disable Config (1/0 = enable/disable)\n');
s=who('Sweep*_On','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Sweeping Parameters Config\n');
s=who('Sweep_Param*','global');
for ii=1:length(s)    
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Sequential Reading Enable/Disable Config (1/0 = enable/disable)\n');
fprintf_var(fid, 'Sequential_On', Sequential_On);

%%
% % unwritable configs
fprintf(fid, '\n%%**********************************************************************************\n');
fprintf(fid, '%% Read-Only Configs \n');
fprintf(fid, '%% DO NOT uncomment and modify the following configs unless necessary\n');
fprintf(fid, '%%**********************************************************************************\n');

fprintf(fid, '\n%% Attacked Filename Template Config\n');
s=who('Attack_Filename*','global');
for ii=1:length(s)
    fprintf(fid, '%% ');
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fprintf(fid, '\n%% Attack Option Table Config\n');
s=who('Table_Attack_Option*','global');
for ii=1:length(s)    
    fprintf(fid, '%% ');
    fprintf_var(fid, s{ii}, eval(s{ii}));
end

fclose(fid);
