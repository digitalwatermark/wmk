% usage:
% [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk(x, fs, nbit, wmk, key, 'embed', param_in);
% [wmk_extract, param_out] = wmk_core_ccsk(x, fs, nbit, [], key, 'extract', param_in);

function varargout= wmk_core_ccsk_v2(x, fs, nbit, wmk, key, type, param_in)
%fprintf('=====================wmk_core_ccsk_v2===================\n');
% global_mpeg;
% initial_global_mpeg;
data_class = 'single';      % precision of some large vectors; single and double have similar effects

%% default parameter values (could be modified via param_in)
var_before_record = whos;
var_before_record = {var_before_record(:).name};

% % % % % % % % % % % % % % 
% write down default parameters:
watermark_type = 'extractable';         % extractable, detectable
N = 2^11;
M = 2^1;
mod_type = 'ccsk'; 
polar = 'bi';                      
code_type = 'none';                      
map_order = 'gray';
orthogonal_pn = 1;

ss_type = 'ss';
psychoacoustic_enable = 1;
nmr_gain = 0;
mpeg_param = struct('Layer', 1, 'Model', 1, 'Bitrate', 128);
mask_opt = struct('SMRmin', 0, 'Draw','');
matched_filter_enable = 0;



adapt = 0;
target_snr = 46;


extract_filter_type = 'hpf';
  extract_fcuts = [10, 12]*1e3;
%  extract_fcuts = [2, 3, 15, 17]*1e3;  




hist_on = 0;

% END of default parameter values
% % % % % % % % % % % % % % 
% output the above parameters
var_after_record = whos;
var_after_record = {var_after_record(:).name};
var_after_record(ismember(var_after_record, 'var_before_record')) = [];    
outparam_name = setxor(var_before_record, var_after_record);      % cell of parameter names

% add output-only parameters
outparam_name = [outparam_name(:); {'fs'; 'nbit'; 'key'; 'pn'; 'extract_h'; 'pn_moded'; 'masked_pn'}];

% default input no-output parameters
sig_prefix = [];
sig_suffix = [];
pn_prefix = [];
pn_suffix = [];

%% parse specified parameter values

if nargin>=7 && isstruct(param_in)        % use specified parameters 
    inparam_name = fieldnames(param_in);
    for ii=1:length(inparam_name)
        eval([inparam_name{ii}, ' = param_in.', inparam_name{ii}, ';']);
    end
end

%%
global Sweep_Var1;
global Sweep_Var2;
if ~isempty(Sweep_Var1)
    nmr_gain = Sweep_Var1;
end
if ~isempty(Sweep_Var2)
    N = Sweep_Var2;
end




if strcmpi(extract_filter_type, 'lpf')
     extract_fcuts = [10, 12]*1e3;                   % LPF 
elseif strcmpi(extract_filter_type, 'bpf')
     extract_fcuts = [2, 3, 15, 17]*1e3;          % BPF
elseif strcmpi(extract_filter_type, 'hpf')
    extract_fcuts = [2, 3]*1e3;                        % HPF
elseif strcmpi(extract_filter_type, 'apf')      % All Pass Filter
else
    error('Filter type must be ''lpf'', ''bpf'', ''hpf'', or ''apf''.');
end

% generate PN  (2011-08-10)
if strcmpi(mod_type, 'ccsk')
    npn = 1;
end
global Key_wmk_core_ccsk_v2;
global Pn_wmk_core_ccsk_v2;
global Orthogonal_pn_wmk_core_ccsk_v2;
global Mod_type_wmk_core_ccsk_v2;

if ~isequal(Key_wmk_core_ccsk_v2, key) ... % use ~isequal instead of ~=, as the variable may be empty
        || ~isequal(size(Pn_wmk_core_ccsk_v2), [N, npn]) ...% if key or PN size changes, regenerate PN
        || ~isequal(Orthogonal_pn_wmk_core_ccsk_v2, orthogonal_pn) ...
        || ~isequal(Mod_type_wmk_core_ccsk_v2, mod_type)
    if orthogonal_pn
        rand('seed', key); 
        pn = 1-2*randint(N, 1);    
        pn_mask = walsh_gen(N, mod(key:key+npn-1, N)+1);
        pn = repmat(pn, 1, npn).*pn_mask;         % orthogonal
    else
        rand('seed', key); 
        pn = 1-2*randint(N, npn);
    end
    Key_wmk_core_ccsk_v2 = key;
    Pn_wmk_core_ccsk_v2 = pn;
    Orthogonal_pn_wmk_core_ccsk_v2 = orthogonal_pn;
    Mod_type_wmk_core_ccsk_v2 = mod_type;
else
    pn = Pn_wmk_core_ccsk_v2;
end

global Extract_filter_type_wmk_core_ccsk_v2;
global Extract_fcuts_wmk_core_ccsk_v2;
global Extract_h_wmk_core_ccsk_v2;
if ~isequal(Extract_filter_type_wmk_core_ccsk_v2, extract_filter_type) ...
        || ~isequal(Extract_fcuts_wmk_core_ccsk_v2, extract_fcuts)
    if  ~strcmpi(extract_filter_type, 'apf')
        Astop = -20;                 % stopband attenuation in dB
        Rpass = 0.01;              % passband ripple
        extract_h = kaiser_fir(extract_fcuts, fs, Rpass, Astop, extract_filter_type);
%         [a,freq] = freqz(extract_h);
        %figure; 
%         plot(freq/pi*fs/2/1e3,20*log10(abs(a))); grid;xlim([0 fs/2/1e3]);xlabel('Frequency (kHz)');
%         pn_filter = filter(extract_h,1,pn);  
%         for ii=1:size(pn, 2)
%             pn(:,ii) = pn_filter(:,ii)/std(pn_filter(:,ii));
%         end
    else
        extract_h = 1;
    end
    Extract_filter_type_wmk_core_ccsk_v2 = extract_filter_type;
    Extract_fcuts_wmk_core_ccsk_v2 = extract_fcuts;
    Extract_h_wmk_core_ccsk_v2 = extract_h;    
else
    extract_h = Extract_h_wmk_core_ccsk_v2;
end



 rx_filter_enable = 1;

w = 1;
w_inv = inv(w);

nchan = size(x,2);
if strcmpi(code_type, 'none') || strcmpi(watermark_type, 'detectable')  % for detectable watermarking, coding is unnecessary
    nsym = floor(size(x,1)/N);
    nbit_per_channel = nsym*log2(M);
else            % number of  coded symbols; must be multiple of coded blocks
    nsym = floor(size(x,1)/N/FEC_n) * FEC_n;
    nbit_per_channel = nsym/FEC_n*FEC_k*log2(M);
    if strcmpi(code_type, 'conv') && strcmpi(type, 'embed')  % pad for viterbi decoding
        nsym = nsym+conv_delay/FEC_k*FEC_n;
        nbit_per_channel = nbit_per_channel+conv_delay;
    end
end
% 
if ~strcmpi(class(x), 'double') && ~strcmpi(class(x), 'single')
    error('Unsupported data type.');
end
if ~strcmpi(class(x), data_class)
    eval(['x = ', data_class, '(x);']);
end
if ~strcmpi(class(wmk), data_class)
    eval(['wmk = ', data_class, '(wmk);']);
end


    
if strcmpi(type, 'extract')
    rx_s = zeros(N, 1, data_class);
    demoded_bit = zeros(nsym*log2(M), nchan);
    ber_tmp = zeros(nchan,1);
    
    if (psychoacoustic_enable==1 && matched_filter_enable==1)
        if strcmpi(mod_type, 'ccsk')
            if nsym==0
                masked_pn_ch = pn(1:size(x,1));
            else
                masked_pn_ch = repmat(pn, nsym, nchan); 
            end
            for nn=1:nchan
                masked_pn_ch(:,nn) = noise_masking_v2(x(:,nn), fs, masked_pn_ch(:, nn), mpeg_param, mask_opt);
            end
        else
        end
    end

    if  ~strcmpi(extract_filter_type, 'apf') && rx_filter_enable
        x = fir_aligned(x, extract_h);        
    end
            
    for nn=1:nchan
        for ii=1:nsym           
            s_temp = double(x((ii-1)*N+1:ii*N,nn));

            if (psychoacoustic_enable==1 && matched_filter_enable==1)
                if strcmpi(mod_type, 'ccsk')                                    
                    masked_pn = masked_pn_ch((ii-1)*N+1:ii*N, nn); 
                else
                end
            else
                masked_pn = pn;
            end
%                        
            if strcmpi(ss_type, 'ss')
                if psychoacoustic_enable==0 && adapt==1
                    pow_s = std(s_temp); 
                    if pow_s==0
                        rx_s(:) = 0;
                    else
                        rx_s = w*s_temp/pow_s/Awmk;
                    end
                else
                    rx_s = w*s_temp;
                end
                if strcmpi(mod_type, 'ccsk')
                    [demoded_bit((ii-1)*log2(M)+1:ii*log2(M),nn), sym, peak] = ...
                              ccsk_modem(rx_s,masked_pn,M,'demod', polar);                                
                end
                            
            end
                                                 
        end
        
% % % % % % % % % % % % % % % % %         
% channel decoding
        if strcmpi(code_type, 'none')
            sink_bit(:, nn) = demoded_bit(:, nn);
        elseif strcmpi(code_type, 'rs')
            demoded_msg = binstream2dec(demoded_bit(:, nn), log2(M), 'msb');
            decoded_msg = rscodec(demoded_msg, FEC_n, FEC_k, log2(M), 'dec');       % RS decoding
            sink_bit(:, nn) = dec2binstream(decoded_msg, log2(M), 'msb');
        elseif strcmpi(code_type, 'rm')
            sink_bit(:, nn) = rmdec(demoded_bit(:, nn), RM_r, RM_m, rm_V, rm_N, rm_K, rm_I);
        elseif strcmpi(code_type, 'conv')
            temp = vitdec(demoded_bit(:, nn), trel, tblen, 'cont', 'hard');
            sink_bit(:, nn) = temp(conv_delay+1:end);
        else
        end 
    end
% % % % % % % % % % % % % % % % % 
    varargout{1} = sink_bit;
        
    for ii=1:length(outparam_name)
        str = outparam_name{ii};
        if exist(str)
            eval(['param_out.', str, ' = ', str, ';']);
        end
    end
    varargout{2} = param_out;

else
    error('Type must be ''embed'' or ''extract''.');
end
return
