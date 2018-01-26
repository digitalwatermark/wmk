% % Noise Shaping and Masking using Psychoacoustic Model in MPEG-1 version 2
% % Peng Zhang     Tsinghua Univ.    2010.03.13
% % % % % % % % % % % % % % % % % % % % 

%-------------------------------------------------------------------------------
function onoise = noise_masking_v2(x, fs, inoise, mpeg_param, option)
%fprintf('=====================noise_masking_v2=====================\n');

valid_option_field = {'Draw'; 'SMRmin'; 'Pad_x'; 'Pad_inoise'}; 

if nargin>=5 
    if ~isstruct(option)
        error('Option must be a struct array.');
    else
        names = fieldnames(option);     
        if length(union(names, valid_option_field))>length(valid_option_field)
            warning('Option contains invaild field names.');
        end
    end
end
    
if nargin>=5 && isfield(option, 'Draw') && ~isempty(option.Draw)
    draw_enable = 1;
else
    draw_enable = 0;
end
if nargin>=5 && isfield(option, 'SMRmin') && ~isempty(option.SMRmin)
    SMRmin_dB = option.SMRmin;
else
    SMRmin_dB = 0;
end
if nargin>=5 && isfield(option, 'Pad_x') 
    x_pad = option.Pad_x;
else
    x_pad = [];
end
if nargin>=5 && isfield(option, 'Pad_inoise') 
    inoise_pad = option.Pad_inoise;
else
    inoise_pad = [];
end

if ~isequal(size(x), size(inoise))
    error('Input noise and audio vectors must be of the same size.');
end
if ~isequal(size(x_pad), size(inoise_pad))
    error('Padding noise and audio vectors must be of the same size.');
end


layer = mpeg_param.Layer;
model = mpeg_param.Model;
bitrate = mpeg_param.Bitrate;


FFT_SIZE = 512;
Syn_Td = 481;               
Lblk = 384;                
[C, M, D, N] = init_subband_filter(); 
h = sqrt(8/3)*0.5*(1-cos(2*pi*(0:FFT_SIZE-1).'/(FFT_SIZE-1)));
if layer==1
    Nblk = 1;      
    Buffer_Shift = 64;
else
    Nblk = 3;           
    Buffer_Shift = 0;
end
Lseg = Lblk*Nblk; 


xlen = length(x); 
nchan = size(x, 2);

Nseg = ceil((xlen+Syn_Td+Buffer_Shift)/Lseg); 
len_pad = Lseg*Nseg-xlen;
if length(x_pad)>=len_pad
    x = [x; x_pad(1:len_pad, :)];
    inoise = [inoise; inoise_pad(1:len_pad, :)];
else
    x = [x; x_pad; zeros(len_pad-length(x_pad), nchan)];
    inoise = [inoise; inoise_pad; zeros(len_pad-length(inoise_pad), nchan)];
end





inoise_ana = [zeros(Buffer_Shift, nchan); inoise]; 


buffer = zeros(Lblk*3, nchan);
Vbuff = zeros(1024, nchan);
S = zeros(Lseg, size(x, 2));      
Sni = zeros(Lseg, size(inoise, 2));  
onoise = zeros(size(inoise));
if draw_enable
    SMR_buff = zeros(32*3,1);    
end



offset = 0;



SMR_seg = zeros(Nseg, 1);

for ii=1:Nseg

    buffer(1:Buffer_Shift,:) = buffer(Lseg+1:Lseg+Buffer_Shift, :);
    buffer(Buffer_Shift+1:Buffer_Shift+Lseg, :) = x(offset+1:offset+Lseg, :);



    [SMRsb, Sx] = SMRv2_MPEG1_mex(buffer, fs, bitrate, layer, model);




    for kk=1:Nblk

        Sni((kk-1)*Lblk+1:kk*Lblk, :) = Analysis_subband_filter_mex(inoise_ana, offset+1+(kk-1)*Lblk, C, M);
    end


    scf_bin = zeros(Lseg, 1);
    Px_bin = Sx.^2;
    SMR_bin = rectpulse(10.^(SMRsb/10), 12);
    
    adjust = 0;
  
  
    fcutl_bin = 0;
    fcuth_bin = Lblk;
    favail_bin = [fcutl_bin+1:fcuth_bin];

%     if alpha_dB<option.SMRmin
        alpha = 10.^(SMRmin_dB/10);
%     end
    
    SMR_bin(SMR_bin<alpha) = alpha;
    SMR_bin(1:fcutl_bin) = inf;
    SMR_bin(fcuth_bin+1:end) = inf;
    
  
    SMR_bin = repmat(SMR_bin, Nblk, 1);
    scf_bin = sqrt(Px_bin./(Sni.^2+eps)./SMR_bin);            

    
if adjust
        SMR_bin = rectpulse(10.^(SMRsb/10), 12); 
        snr_target = 22;
        fcutl = 4000;
        fcutl_bin = floor(fcutl/(fs/2)*384);
        for nn=1:size(x,2)
            for kk=1:Nblk
                Px_bin = Sx((kk-1)*Lblk+1:kk*Lblk, nn).^2;
                Pno_total = sum(Px_bin)/10.^(snr_target/10);
                Pno_bin_max = Px_bin./SMR_bin;
                fcuth_bin = find(cumsum(Pno_bin_max(fcutl_bin+1:end))<Pno_total, 1, 'last')+fcutl_bin;
                if isempty(fcuth_bin)
                    warning('Target power of output noise is zero.');
                    fcuth_bin = fcutl_bin;
                end
                fcuth = fcuth_bin/384*fs/2;
                Pno_bin = [eps*ones(fcutl_bin, 1); Pno_bin_max(fcutl_bin+1:fcuth_bin); eps*ones(384-fcuth_bin, 1)]; % use eps to avoid log of zeros
                scf_bin((kk-1)*Lblk+1:kk*Lblk) = sqrt(Pno_bin)./(abs(Sni((kk-1)*Lblk+1:kk*Lblk, nn))+eps);
            end
        end
    end

    Sno = Sni.*scf_bin;
    [onoise_seg, Vbuff] = Synthesis_subband_filter_mex(Sno, Vbuff, D, N);
    onoise((ii-1)*Lseg+1:ii*Lseg, :) = onoise_seg;


    offset = offset+Lseg;           
   

    if draw_enable
        warning off
        if strcmpi(option.Draw, 'ft')    % plot the spectrum based on FFT            
            SMR_buff(1:64) = SMR_buff(33:96);
            SMR_buff(65:96) = SMRsb(:,1);
            if (ii>=3)
                X = fft(x((ii-3)*Lseg+1:(ii-3)*Lseg+FFT_SIZE, 1).*h, FFT_SIZE);
                Nin = fft(inoise((ii-3)*Lseg+1:(ii-3)*Lseg+FFT_SIZE, 1).*h, FFT_SIZE);
                Nout = fft(onoise(Syn_Td+Buffer_Shift+(ii-3)*Lseg+1: ...
                            Syn_Td+Buffer_Shift+(ii-3)*Lseg+FFT_SIZE, 1).*h, FFT_SIZE);
                
                SMR_bin =rectpulse(SMR_buff(1:32), FFT_SIZE/2/32);
                Px_bin = 20*log10(abs(X(1:end/2)));
                SPL_sb = max(reshape(Px_bin(:), FFT_SIZE/2/32, 32));
                SPL_bin = rectpulse(SPL_sb(:), FFT_SIZE/2/32);
                LTmin_bin = SPL_bin-SMR_bin;      
                Delta_SPL = 96-max(SPL_bin);    
                
                xtick = (0:FFT_SIZE/2-1)/FFT_SIZE*fs;
                plot(xtick, Px_bin+Delta_SPL, 'b');
                hold on;
                plot(xtick, 20*log10(abs(Nin(1:end/2)))+Delta_SPL, 'k');
                plot(xtick, 20*log10(abs(Nout(1:end/2)))+Delta_SPL, 'r');
                plot(xtick, LTmin_bin+Delta_SPL, 'r--.');
                %                 plot(xtick, SMR_bin, 'g--.');
                
                title('Masking in Frequency Domain');
                xlabel('Frequency (Hz)'); ylabel('Normalized Power Spectrum (dB)');
                xlim([min(xtick) max(xtick)]);
                legend('Signal PSD', 'Input noise PSD', 'Output noise PSD', 'Minimum masking threshold', ...
                    ... % 'SMR',
                    'location','north');
            end
        elseif (strcmpi(option.Draw, 'sb'))  % plot the spectrum based on analysis subband filtering
            SMR_bin =rectpulse(SMRsb(1:32, 1), Lblk/32);
            Px_bin = 20*log10(abs(Sx(1:Lblk,1)));
            SPL_sb = max(reshape(Px_bin(:), Lblk/32, 32));
            SPL_bin = rectpulse(SPL_sb(:), Lblk/32);
            LTmin_bin = SPL_bin-SMR_bin;
            Delta_SPL = 96-max(SPL_bin);
            
            xtick = (0:Lblk-1)/Lblk*fs/2;
            plot(xtick, Px_bin+Delta_SPL, 'b');
            hold on;
            plot(xtick, 20*(abs(Sni(1:Lblk,1)))+Delta_SPL, 'k');
            plot(xtick, 20*log10(abs(Sno(1:Lblk,1)))+Delta_SPL, 'r');
            plot(xtick, LTmin_bin+Delta_SPL, 'r--.');
            %                 plot(xtick, SMR_bin, 'g--.');
            
            title('Masking in Subband Domain');
            xlabel('Frequency (Hz)'); ylabel('Normalized Power Spectrum (dB)');
            xlim([min(xtick) max(xtick)]);
            legend('Signal PSD', 'Input noise PSD', 'Output noise PSD', 'Minimum masking threshold', ...
                ... % 'SMR',
                'location','north');
        else
            error('Option.Draw must be ''ft'' or ''sb''.');
        end
%         legend off;
        drawnow
        hold off
        warning on
%         pause(0.5)
    end  % End of plotting
         
end

onoise = onoise(Syn_Td+Buffer_Shift+1:Syn_Td+Buffer_Shift+xlen, :);
