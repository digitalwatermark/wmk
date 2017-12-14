
%function acquire_embed(obj, event, ao, len_seg, nfft, param)
function acquire_embed(obj, event, len_seg, nfft, param,audioPCM)
%fprintf('=====================acquire_embed=====================\n');
t1 = clock;

globalvar_realtime_wmkembedder;

Algorithm_Param.watermark_type = Wmk_Type;  
Algorithm_Param.key = Key;
Algorithm_Param.fs = Fs;

pcmlength = length(audioPCM(:,1));

%fprintf('=====================acquire_embed ccsk1=====================\n');
 [wmk_temp, param_out] = wmk_core_ccsk_v2(0, Algorithm_Param.fs, [], [], Algorithm_Param.key, 'initial', Algorithm_Param);

param_name = fieldnames(param_out);
for ii=1:length(param_name)
    eval(['Algorithm_Param.', param_name{ii}, ' = param_out.', param_name{ii}, ';']);
end


N = Algorithm_Param.N;
M = Algorithm_Param.M;
key = Algorithm_Param.key;
fs = Algorithm_Param.fs;
% pn = Algorithm_Param.pn;
% h_extfilter = Algorithm_Param.extract_h;
% csk_polar = Algorithm_Param.csk_polar;
nbit = Algorithm_Param.nbit;


    if Current_Sample_Index<=len_seg 
        pcmWMKdata=[];
%         [temp, fs, Current_Wav_Info.Nbit] = wavread(Files_Wav{Current_Wav_Index}, 1);
%         [ Current_Wav_Info.Size,Fs] = audioread(Files_Wav{Current_Wav_Index});
        Current_Wav_Info.Fs = Fs;
%         Current_Wav_Info.Size = wavread(Files_Wav{Current_Wav_Index}, 'size');
        Current_Wav_Info.DurationString = sec2minstr(round(pcmlength/fs));
        [tempdir, name, ext] = fileparts(Files_Wav{Current_Wav_Index});
        set(Obj_Handle.CurrentWav, 'string', [name, ext]);
        set(Obj_Handle.TotalTime, 'string', Current_Wav_Info.DurationString);
    end
    
    next_sample_index = Current_Sample_Index+len_seg;
    if next_sample_index > pcmlength+1  
        next_sample_index = next_sample_index- pcmlength;
%         predata = wavread(Files_Wav{Current_Wav_Index}, [Current_Sample_Index, Current_Wav_Info.Size(1)]);
      lastpcm = audioPCM([Current_Sample_Index:pcmlength] ,:);
      
     if size(lastpcm, 2)==1
            lastpcm = [lastpcm; lastpcm];
     end
      maxpcm = zeros(1,2);
      
      pcmWMKdata = [pcmWMKdata;lastpcm];
      
      maxpcm(1,1) = max(pcmWMKdata(:,1));
      maxpcm(1,2) = max(pcmWMKdata(:,2));
      pcmWMKdata1(:,1) = (pcmWMKdata(:,1)./maxpcm(1,1)).*32768;
      pcmWMKdata1(:,2) = (pcmWMKdata(:,2)./maxpcm(1,2)).*32768;
      
       audiowrite(fileclosename,pcmWMKdata,48000,'BitsPerSample',16);
%          fwrite(outfile,pcmWMKdata1','int16');
%          
%          fclose(outfile);
       
         msgbox('嵌入水印生成文件写入完成。','提示');
   
      stop(t);
    else       

         acqdata = audioPCM( [Current_Sample_Index:next_sample_index-1] ,:);
        if size(acqdata, 2)==1
            acqdata = [acqdata; acqdata];
        end
        set(Obj_Handle.Slider , 'value', (Current_Sample_Index+len_seg-1)/pcmlength);  
        set(Obj_Handle.CurrentTime, 'string', sec2minstr(round(Current_Sample_Index/fs)));
        if next_sample_index == pcmlength+1  
            next_sample_index = 1;
        end
%     end
    
    Current_Sample_Index = next_sample_index;    


nbit_emb = length(acqdata)/N*log2(M);
nbit_tot = size(Wmk_Bit, 1);
if (strcmpi(Wmk_Type, 'extractable') && nbit_tot==0) || ...
        (strcmpi(Wmk_Type, 'detectable') &&Wmk_Bypass)    
    cover_pcm = acqdata;
    stego_pcm = acqdata;
else
    nchan = size(acqdata, 2);
    Signal_Buffer(1:Npad_Prefix+Npad_Suffix, 1:nchan) = Signal_Buffer(N+1:end, 1:nchan);
    Signal_Buffer(Npad_Prefix+Npad_Suffix+1:end, 1:nchan) = acqdata;

    
    if strcmpi(Wmk_Type, 'extractable') 
        next_bit_index = Current_Bit_Index+nbit_emb;
        if size(Wmk_Bit,1)<nbit_emb       % 2011-08-14
            Wmk_Bit = repmat(Wmk_Bit, ceil(nbit_emb/size(Wmk_Bit,1)), 1);
        end
        if next_bit_index>nbit_tot
            next_bit_index = next_bit_index-nbit_tot;  
            wmk = [Wmk_Bit(Current_Bit_Index:end, :); Wmk_Bit(1:next_bit_index-1, :)];
        else
            wmk = Wmk_Bit(Current_Bit_Index:next_bit_index-1, :);
        end
    else
        next_bit_index = 1;
        wmk = zeros(nbit_emb, 1);
    end

    if size(wmk, 2)==1;
        wmk = [wmk, wmk];  
    end

    sig_center = Signal_Buffer(Npad_Prefix+1:Npad_Prefix+N, :);
    
    sig_prefix = Signal_Buffer(1:Npad_Prefix, :);   
    sig_suffix = Signal_Buffer(Npad_Prefix+N+1:end, :);
    pn_prefix = Pnmod_Buffer(1:Npad_Prefix, :);
    pn_suffix = Pnmod_Buffer(Npad_Prefix+N+1:end, :);
    
    if ~isempty(Files_Config) && exist(Files_Config)==2  
        var_name = readeval(Files_Config);    
        for ii=1:length(var_name)      
            eval(['Algorithm_Param.', var_name{ii}, ' = ', var_name{ii}, ';']);
        end
        
        Algorithm_Param.watermark_type = Wmk_Type; 
        Algorithm_Param.key = Key;
        Algorithm_Param.fs = Fs;

%         [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk_v2(acqdata, fs, nbit, wmk, key, 'embed', Algorithm_Param);        
        Algorithm_Param.sig_prefix = sig_prefix;
        Algorithm_Param.sig_suffix = sig_suffix;
        Algorithm_Param.pn_prefix = pn_prefix;
        Algorithm_Param.pn_suffix = pn_suffix;
        %fprintf('=====================acquire_embed ccsk2=====================\n');
        [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk_v2(sig_center, Algorithm_Param.fs, nbit, wmk, Algorithm_Param.key, 'embed', Algorithm_Param);
        
    else                
%         [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk_v2(acqdata, fs, nbit, wmk, key, 'embed');
        param_pad.sig_prefix = sig_prefix;  
        param_pad.sig_suffix = sig_suffix;
        param_pad.pn_prefix = pn_prefix;
        param_pad.pn_suffix = pn_suffix;
        
        param_pad.watermark_type = Wmk_Type;  
        param_pad.key = Key;
        param_pad.fs = Fs; 
        %fprintf('=====================acquire_embed ccsk3=====================\n');
        [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk_v2(sig_center, param_pad.fs, nbit, wmk, param_pad.key, 'embed', param_pad);
        
    end

    Current_Bit_Index = next_bit_index;
    
    Pnmod_Buffer(1:Npad_Prefix, 1:nchan) = param_out.pn_moded(end-Npad_Prefix+1:end, 1:nchan);    

end

outdata = double(stego_pcm);


pcmWMKdata = [pcmWMKdata;outdata];

   %putdata(ao, outdata);

% % % % % % % % % % % % % % % % % % 
if Plot_Enable(1)
    if Plot_IO
        plot(Hplot(1), acqdata);
    else
        plot(Hplot(1), outdata);
    end
    set(Hplot(1), 'xlim', [1 len_seg], 'ylim', [-1 1]);
    title(Hplot(1), 'Acquired Samples');
    ylabel(Hplot(1), 'Amplitude');
end

if Plot_Enable(2)
    if Plot_IO
        X = abs(fft(acqdata(:,1), nfft));
    else
        X = abs(fft(outdata(:,1), nfft));
    end
   X = X(1:end/2);
    axes_x = [0:fs/nfft:(fs/2-fs/nfft)]/1000;
    plot(Hplot(2), axes_x, 20*log10(X/(max(X)+eps)+1e-8));
    set(Hplot(2), 'xlim', [0 max(axes_x)], 'ylim', [-100 0]);
    title(Hplot(2), 'Power Spectrum');
    xlabel(Hplot(2), 'Frequency (kHz)');
    ylabel(Hplot(2), 'Power (dB)');

    nout = stego_pcm-cover_pcm;
    Nout = abs(fft(nout(:,1), nfft));
    Nout = Nout(1:end/2);
    hold(Hplot(2), 'on');     
    plot(Hplot(2), axes_x, 20*log10(Nout/(max(X)+eps)+1e-8), 'r');
  

    snr_db = SNR(cover_pcm, stego_pcm);
    text(max(axes_x), 0, ['SWR=', num2str(snr_db, '%.1f'), 'dB'], ...
        'parent', Hplot(2), 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

     hold(Hplot(2), 'off');
end

    end;

et = etime(clock, t1);
% if et>len_seg/fs
%     warning(['Real-time processing may not be achievable (', datestr(clock), ')']);
% end

%%
function minstr = sec2minstr(t)
m = floor(t/60);
s = round(t-m*60);
minstr = [num2str(m), ':', num2str(s, '%.2d')];


