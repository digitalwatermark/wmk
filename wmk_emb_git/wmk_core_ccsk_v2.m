% usage:
% [wmk_embed, cover_pcm, stego_pcm, param_out] = wmk_core_ccsk(x, fs, nbit, wmk, key, 'embed', param_in);
% [wmk_extract, param_out] = wmk_core_ccsk(x, fs, nbit, [], key, 'extract', param_in);

function varargout= wmk_core_ccsk_v2(x, fs, nbit, wmk, key, type, param_in)
%fprintf('=====================wmk_core_ccsk_v2===================\n');
% global_mpeg;
% initial_global_mpeg;

%% default parameter values (could be modified via param_in)
var_before_record = whos;
var_before_record = {var_before_record(:).name};

% % % % % % % % % % % % % % 
% write down default parameters:
% watermark_type = 'extractable';         % extractable, detectable
N = 2^11;
M = 2^1;
mod_type = 'ccsk'; 
polar = 'bi';                      
code_type = 'none';                      

orthogonal_pn = 1;

ss_type = 'ss';
psychoacoustic_enable = 1;
nmr_gain = -3;
mpeg_param = struct('Layer', 1, 'Model', 1, 'Bitrate', 128);
mask_opt = struct('SMRmin', 0, 'Draw','');
matched_filter_enable = 0;


filter_type = 'hpf';
fcuts = [2, 3]*1e3;
Awmk = 0.002;

adapt = 0;
target_snr = 46;


% extract_filter_type = 'bpf';
% %  extract_fcuts = [2, 3]*1e3;
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


if strcmpi(filter_type, 'lpf')
    fcuts = [2, 3]*1e3;                   % LPF 
elseif strcmpi(filter_type, 'bpf')
    fcuts = [2, 3, 15, 17]*1e3;          % BPF
elseif strcmpi(filter_type, 'hpf')
    fcuts = [2, 3]*1e3;                     % HPF
elseif strcmpi(filter_type, 'apf')      % All Pass Filter
    fcuts = 0;
else
    error('Filter type must be ''lpf'', ''bpf'', ''hpf'', or ''apf''.');
end

% if strcmpi(extract_filter_type, 'lpf')
% %     extract_fcuts = [10, 12]*1e3;                   % LPF 
% elseif strcmpi(extract_filter_type, 'bpf')
% %     extract_fcuts = [2, 3, 15, 17]*1e3;          % BPF
% elseif strcmpi(extract_filter_type, 'hpf')
% %     extract_fcuts = [3, 4]*1e3;                        % HPF
% elseif strcmpi(extract_filter_type, 'apf')      % All Pass Filter
% else
%     error('Filter type must be ''lpf'', ''bpf'', ''hpf'', or ''apf''.');
% end

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




if  ~strcmpi(filter_type, 'apf') % && ~psychoacoustic_enable
    Astop = -30;                 % stopband attenuation in dB
    Rpass = 0.01;              % passband ripple
    h=kaiser_fir(fcuts, fs, Rpass, Astop, filter_type);
%       [a,freq] = freqz(h);figure; plot(freq/pi*fs/2/1e3,20*log10(abs(a))); grid;xlim([0 fs/2/1e3]);xlabel('Frequency (kHz)');
     pn_filter = filter(h,1,pn);  
    for ii=1:size(pn, 2)
        pn(:,ii) = pn_filter(:,ii)/std(pn_filter(:,ii));
    end
end

 rx_filter_enable = 1;

w = 1;
w_inv = inv(w);

nchan = size(x,2);

if strcmpi(type, 'embed')
  
      coded_bit = zeros(1,nchan);    % embed all '0's (or all '1's)      
  
     src_bit = coded_bit;
     

    pn_moded = zeros(N, nchan);
%     r = NaN*ones(nsym, nchan);
               

    for nn=1:nchan        
                
        if strcmpi(mod_type, 'ccsk')
            wmk_ch = ccsk_modem(coded_bit(:,nn),pn,M,'mod', polar);              
        end

            pn_moded(:, nn) = wmk_ch(end-N+1:end);
            
            if psychoacoustic_enable
                if ~isempty(sig_prefix)
                    wmk_ch = 10^(nmr_gain/20)*noise_masking_v2([sig_prefix(:,nn); x(:,nn); sig_suffix(:,nn)], ...
                                       fs, [pn_prefix(:,nn); wmk_ch; pn_suffix(:,nn)], mpeg_param, mask_opt);
                    wmk_ch = wmk_ch(length(pn_prefix)+1:end-length(pn_suffix));                
                else
                    wmk_ch = 10^(nmr_gain/20)*noise_masking_v2(x(:,nn), fs, wmk_ch, mpeg_param, mask_opt);
                end
                
            else
                wmk_ch = Awmk*wmk_ch;
            end
         
            if strcmpi(ss_type, 'ss')
                if ~psychoacoustic_enable
                    if adapt
                        for ii=1:nsym
                            c_temp = x((ii-1)*N+1:ii*N, nn);  
                            w_temp = wmk_ch((ii-1)*N+1:ii*N);
                            pow_c = std(c_temp);

                            if mean(abs(c_temp))<1e-3   % embed in silent region in case of bit errors !!!
                                wmk_temp = w_temp/std(w_temp)*2^-12;
                            else
                                wmk_temp = pow_c*10^(-target_snr/20)*w_temp/std(w_temp);
                            end

                            y((ii-1)*N+1:ii*N, nn) = c_temp + wmk_temp;
                        end
                    else
                        y(:, nn) = x(:, nn)+wmk_ch;
                    end
                elseif psychoacoustic_enable
                    y(:, nn) =x(:, nn)+wmk_ch;
                end

            end        

        end
    if hist_on
        figure; hist(r(:), 100);
        pause
    end
    
    varargout{1} = src_bit;
    varargout{2} = x;  
    varargout{3} = y;
    
    for ii=1:length(outparam_name)
        str = outparam_name{ii};
        if exist(str)
            eval(['param_out.', str, ' = ', str, ';']);
        end
    end
    varargout{4} = param_out;
    
elseif strcmpi(type, 'initial')

    for ii=1:length(outparam_name)
        str = outparam_name{ii};
        if exist(str)
            eval(['param_out.', str, ' = ', str, ';']);
        end
    end
    varargout{2} = param_out;

else
    error('Type must be ''embed'' or ''initial''.');
end
return
