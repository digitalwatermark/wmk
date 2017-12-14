

function process_acquireddata_v2(obj, event, len_seg)
%fprintf('=====================process_acquireddata_v2===================\n');
t1 = clock;
globalvar_realtime_wmkextractor;

Algorithm_Param.watermark_type = Wmk_Type;  % override watermark_type
Algorithm_Param.key = Key;
Algorithm_Param.fs = Fs;

[wmk_temp, param_out] = wmk_core_ccsk_v2(0, Algorithm_Param.fs, [], [], Algorithm_Param.key, 'extract', Algorithm_Param);
param_name = fieldnames(param_out);
for ii=1:length(param_name)
    eval(['Algorithm_Param.', param_name{ii}, ' = param_out.', param_name{ii}, ';']);
end

% param_out
nfft = 1024;

N = Algorithm_Param.N;
M = Algorithm_Param.M;
key = Algorithm_Param.key;
fs = Algorithm_Param.fs;
pn = Algorithm_Param.pn;
h_extfilter = Algorithm_Param.extract_h;

acqdata = Input_Gain*Read_Databody();%file


if AD_Polar==-1
    acqdata = -acqdata;
end


if ~isempty(h_extfilter)
    x = fir_aligned(acqdata, h_extfilter);                   % pre-filter
else
    x = acqdata;    
end


% outdata = acqdata;
% 
% if DA_Polar==-1
%     outdata = -outdata;
% end
% if Phone_Enable && ~isempty(ao) && ~(FileOver)  
%     putdata(ao, outdata);   
% end
% outdata = Volum_adjust(acqdata);


nchan = size(x, 2);

for ii=1:Nframes_Rx_Buffer-1
    Rx_Buffer((ii-1)*N+1:ii*N, :) = Rx_Buffer(ii*N+1:(ii+1)*N, :); % buffer the data
end
xlen = length(x(:,1));
if (xlen == N)
Rx_Buffer(ii*N+1:(ii+1)*N, 1:nchan) = x(:, 1:nchan);
else
Rx_Buffer(ii*N+1:ii*N+1+xlen-1, 1:nchan) = x(1:xlen,1:nchan); 
Rx_Buffer(ii*N+1+xlen:end, 1:nchan) = 0; 
end

if Nframes_In_Rx_Buffer<Nframes_Rx_Buffer-1
    Nframes_In_Rx_Buffer = Nframes_In_Rx_Buffer+1;
    return
end

old_state = Sync_State;      

Sync_State.Channel = mod( (old_state.Channel),2)+1;
Sync_State = dsss_sync_v2(Rx_Buffer, pn, Sync_State, Algorithm_Param);

if strcmpi(old_state.Sync_State, 'acquisition') && strcmpi(Sync_State.Sync_State, 'acquisition')
    idx_row = old_state.Count_Acq+1;
    idx_col = Sync_State.Count_Acq+1;
elseif strcmpi(old_state.Sync_State, 'tracking') && strcmpi(Sync_State.Sync_State, 'tracking')
    idx_row = old_state.Count_Fail+Sync_State.Max_Acqtime+1;
    idx_col = Sync_State.Count_Fail+Sync_State.Max_Acqtime+1;
elseif strcmpi(old_state.Sync_State, 'acquisition') && strcmpi(Sync_State.Sync_State, 'tracking')
    idx_row = Sync_State.Max_Acqtime;
    idx_col = Sync_State.Max_Acqtime+1;
elseif strcmpi(old_state.Sync_State, 'tracking') && strcmpi(Sync_State.Sync_State, 'acquisition')
    idx_row = Sync_State.Max_Acqtime+Sync_State.Max_Failtime;
    idx_col = 1;
end
Transition_Matrix(idx_row, idx_col) = Transition_Matrix(idx_row, idx_col) +1;

n_acq2track = Transition_Matrix(Sync_State.Max_Acqtime, Sync_State.Max_Acqtime+1);
n_acq2all = sum(Transition_Matrix(1,:));
n_track2acq = Transition_Matrix(Sync_State.Max_Acqtime+Sync_State.Max_Failtime, 1);
n_track2all = sum(Transition_Matrix(Sync_State.Max_Acqtime+1,:));
prob_acq2track = n_acq2track/n_acq2all;
if n_track2all==0 && n_track2acq==0     %force 0/0=1
    prob_track2acq = 1;
else
    prob_track2acq = n_track2acq/n_track2all;
end

warning off
n_all2acq = sum(sum(Transition_Matrix(:, 1:Sync_State.Max_Acqtime)))+1;  
t_acq = n_all2acq/n_acq2track*N/fs;

n_all2track = sum(sum(Transition_Matrix(:, Sync_State.Max_Acqtime+1:end)));
t_loss = n_all2track/n_track2acq*N/fs;
warning on

if ~isnan(Sync_State.Sink_Bit(1))
    nbit_sink = length(Sync_State.Sink_Bit);     
    SinkBit_Buffer(WP_SinkBit_Buffer:WP_SinkBit_Buffer+nbit_sink-1) = Sync_State.Sink_Bit;
    N_SinkBit = N_SinkBit+nbit_sink;
    if WP_SinkBit_Buffer>=Len_SinkBit_Buffer
        WP_SinkBit_Buffer = 1;
        RP_BER = 1;      
        warning('Sink bit buffer overflows and previous data will be overwritten.');
    else
        WP_SinkBit_Buffer = WP_SinkBit_Buffer+nbit_sink;
    end
end


if isnan(Sync_State.Sink_Bit)
    Start_SinkWord = WP_SinkBit_Buffer;
    Rx_String = {};
elseif strcmpi(Sync_State.Sync_State, 'tracking')
    bitvec = SinkBit_Buffer(Start_SinkWord : WP_SinkBit_Buffer-1);
    if strcmpi(Wmk_Format, 'text')
        Rx_String = bit2text(bitvec, Sync_Word);       
    else  
        Rx_String = bit2strcell(bitvec, N_CharPerLine, Bit_Format);
    end
else
    Start_SinkWord = WP_SinkBit_Buffer;
    Rx_String = {};
end



hberr = Hplot(5);
hnerr = Hplot(6);
hntot = Hplot(7);
if isempty(Ref_Wmk_Bit)        
    N_CurrentErrorBit = 0;
    N_PreviousErrorBit = 0;
    BER = NaN;
    set(hberr, 'string', num2str(BER*100, '%.2f'));
    set(hnerr, 'string', num2str(N_PreviousErrorBit+N_CurrentErrorBit));
elseif isnan(Sync_State.Sink_Bit) 
    RP_BER = WP_SinkBit_Buffer;     
    if strcmpi(old_state.Sync_State, 'tracking')
        N_PreviousErrorBit = N_PreviousErrorBit+N_CurrentErrorBit;       
    end
elseif BER_Enable
    if mod((WP_SinkBit_Buffer-RP_BER), 10)==0
        [nerr, ber, pos] = biterr_min(Ref_Wmk_Bit, SinkBit_Buffer(RP_BER:WP_SinkBit_Buffer-1));
        N_CurrentErrorBit = nerr;
        BER = (N_PreviousErrorBit+N_CurrentErrorBit)/N_SinkBit;      
        set(hberr, 'string', num2str(BER*100, '%.2f'));
        set(hnerr, 'string', num2str(N_PreviousErrorBit+N_CurrentErrorBit));
        set(hntot, 'string', num2str(N_SinkBit));
    end
end

% % % % % % % % % % % % % % % % % % % % 
hstatus = Hplot(8);
if strcmpi(Sync_State.Sync_State, 'tracking')
    str = 'Watermark Detected';
    textcolor = [0 0.7 0];  
else
    str = 'Watermark Undetected';
    textcolor = 'red';   
end
set(hstatus, 'string', str);
set(hstatus, 'foregroundcolor', textcolor);

% % % % % % % % % % % % % % % % % % 
hdata = Hplot(1);
hpsd = Hplot(2);
hcorr = Hplot(3);
htext = Hplot(4);


if strcmpi(old_state.Sync_State, 'tracking') && strcmpi(Sync_State.Sync_State, 'acquisition')
    Str_Buffer = [get(htext, 'string'); {'< -- Sync Lost ... Retry ... >'}];
end
set(htext, 'string', [Str_Buffer; Rx_String]);
set(htext, 'value', length([Str_Buffer; Rx_String]));


if Plot_Enable(1)
    plot(hdata, acqdata);
    set(hdata, 'xlim', [1 len_seg], 'ylim', [-1 1]);
    title(hdata, 'Acquired Samples');
    ylabel(hdata, 'Amplitude');
end
if Plot_Enable(2)
    X = abs(fft(acqdata(:,1), nfft));
    X = X(1:end/2);
    Xmax = max(X);
    X2 = abs(fft(x(:,1), nfft));
    X2 = X2(1:end/2);
    plot(hpsd, [0:fs/nfft:(fs/2-fs/nfft)]/1e3, 20*log10(X/Xmax+1e-8), 'b');
    hold(hpsd, 'on');
    plot(hpsd, [0:fs/nfft:(fs/2-fs/nfft)]/1e3, 20*log10(X2/Xmax+1e-8), 'r');
    set(hpsd, 'xlim', [0 fs/2/1e3], 'ylim', [-100 0]);
    title(hpsd, 'Power Spectrum');
    xlabel(hpsd, 'Frequency (kHz)');
    ylabel(hpsd, 'Power (dB)');
	hold(hpsd, 'off');
end


njt = Sync_State.Max_Sync_Jitter;
sym_offset = mod(Sync_State.Max_Pos, Sync_State.Len_Pn)-njt;

plot(hcorr, -njt:length(Sync_State.Rxpn_AbsShiftAdd)-1-njt, Sync_State.Rxpn_AbsShiftAdd([end, 1:end-1], Sync_State.Pn_Index), 'b');

set(hcorr, 'xlim', [-njt length(Sync_State.Rxpn_AbsShiftAdd)-1-njt], 'ylim', [0 1]);
set(hcorr, 'ytick', unique([get(hcorr,'ytick'), Sync_State.Current_Threshold]));
title(hcorr, 'Normalized Cross Correlation');
xlabel(hcorr, 'Sample Offset');
ylabel(hcorr, 'Amplitude');
hold(hcorr, 'on');
plot(hcorr, sym_offset, Sync_State.Rxpn_AbsShiftAdd(Sync_State.Max_Pos, Sync_State.Pn_Index), 'ro');

text(sym_offset, Sync_State.Rxpn_AbsShiftAdd(Sync_State.Max_Pos, Sync_State.Pn_Index), ...
       ['  (', num2str(sym_offset), ', ', num2str(Sync_State.Rxpn_AbsShiftAdd(Sync_State.Max_Pos, Sync_State.Pn_Index), '%.2f'),    ')'], ...
       'parent', hcorr);
line(get(hcorr, 'xlim'), [Sync_State.Current_Threshold, Sync_State.Current_Threshold], ...
       'linestyle', '--', 'color', 'k', 'parent', hcorr);

str_cell{1} = ['   Sync State: '];
str_cell{2} = ['   Count Acq/Fail: ', mat2str([Sync_State.Count_Acq, Sync_State.Count_Fail])];
str_cell{3} = ['   Sink Bit: ', int2str(Sync_State.Sink_Bit(:).')];
str_cell{4} = ['   Max Acq/Fail: ', mat2str([Sync_State.Max_Acqtime, Sync_State.Max_Failtime])];
str_cell{5} = sprintf('   Hit:    %.2e (%d/%d)', prob_acq2track, n_acq2track, n_acq2all);
str_cell{6} = sprintf('   Loss: %.2e (%d/%d)', prob_track2acq, n_track2acq, n_track2all);
str_cell{7} = sprintf('   Tacq: %.2f s (%d/%d frames)', t_acq, n_all2acq, n_acq2track);
str_cell{8} = sprintf('   Tloss: %.2f s (%d/%d frames)', t_loss, n_all2track, n_track2acq);

str = '';
for ii=1:length(str_cell)
    str = sprintf('%s%s\n',str, str_cell{ii});
end
text(min(get(hcorr, 'xlim')), max(get(hcorr, 'ylim'))*0.95, str, ...
       'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'parent', hcorr, ...
       'fontsize', 9);

if strcmpi(Sync_State.Sync_State, 'acquisition')
   textcolor = 'red';   
else
   textcolor = [0 0.7 0];  
end
str = [repmat(' ', 1, 23), Sync_State.Sync_State];
text(min(get(hcorr, 'xlim')), max(get(hcorr, 'ylim'))*0.95, str, ...
       'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'parent', hcorr, ...
       'fontsize', 9, 'color', textcolor, 'FontWeight', 'bold');
           
hold(hcorr, 'off');

% %{
global N_FrameCount;
global Silence_State;
global Last_Valid_Output;
min_td_silence = 10; 
min_td_sound = 5;   

silence = silence_detect(acqdata);  
if Silence_State==0  
    if all(silence==0)
        N_FrameCount = 0;        
    else       
        N_FrameCount = N_FrameCount+1;
        if N_FrameCount==1     
            Last_Valid_Output = str_cell;            
        elseif N_FrameCount>min_td_silence*fs/N
            Silence_State = 1;
            disp(['Signal lost at ', datestr(clock, 'HH:MM:SS, dd-mmm-yyyy')]);
            disp('The latest valid results are:');
            for ii=5:length(Last_Valid_Output)
                fprintf(1, Last_Valid_Output{ii});
                fprintf(1, '\n');
            end
            fprintf(1, '\n');
        end
    end
else       % silent
    if all(silence==1)        
        N_FrameCount = 0;
    else
        N_FrameCount = N_FrameCount+1;        
        if N_FrameCount>min_td_sound*fs/N
            Silence_State = 0;
            disp(['Signal ready at ', datestr(clock, 'HH:MM:SS, dd-mmm-yyyy')]);
        end
    end
end

if(count == t.TasksToExecute)
    fseek(readfileID,0,'bof');
    ReadInital = 1;
    stop(t);
    delete(t);
    msgbox('检测完成','提示');
end
et = etime(clock, t1);
%}