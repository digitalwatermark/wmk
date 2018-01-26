% % Zhang Peng    Tsinghua Univ.    2008.11.20
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [y, sym, peak] = ccsk_modem(x, pn, M, modem, csk_polar)

% ---------------------------------------------------------------

function [y, sym, peak] = ccsk_modem(x, pn, M, modem, csk_polar)

x = x(:);
pn = pn(:);
nbit_per_sym = log2(M);
len_pn = length(pn);    
sym = [];
peak = [];

if strncmpi(csk_polar, 'uni', 3)
    if len_pn<M
        error('Length of PN sequence must be no less than M');
    end
    if ~mod(len_pn,M)      
        delta_phi = len_pn/M;
    else
        delta_phi = floor((len_pn+1)/M);
    end
elseif strncmpi(csk_polar, 'bi', 2)
    if len_pn<M/2
        error('Length of PN sequence must be no less than M/2');
    end
    if ~mod(len_pn,M/2)
        delta_phi = len_pn/(M/2);
    else
        delta_phi = floor((len_pn+1)/(M/2));
    end
else
    error('csk_polar must be ''uni'' for unipolar or ''bi'' for bipolar');
end

% Modulation
if strncmpi(modem, 'mod', 3) 
    src_bit = x;
    nbit = length(src_bit);                                     
    if mod(nbit, nbit_per_sym)~=0
        error('Number of source bits must be multiple of log2(M)');
    end
    
    nsym = nbit/nbit_per_sym;             % number of symbols
    temp = reshape(src_bit, nbit_per_sym, nsym);
    src_msg = temp.'*2.^(nbit_per_sym-1:-1:0).';           

    y = zeros(nsym*len_pn,1);
    if strncmpi(csk_polar, 'uni', 3)                    
        for k=1:nsym
            cycpn = circshift_vec(pn, delta_phi*src_msg(k)); 
            y((k-1)*len_pn+1:k*len_pn) = cycpn; 
        end
    elseif strncmpi(csk_polar, 'bi', 2)              
        for k=1:nsym        
            if src_msg(k)<M/2                     
                cycpn = circshift_vec(pn, delta_phi*src_msg(k)); 
                y((k-1)*len_pn+1:k*len_pn) = cycpn; 
            else                                               
                cycpn = circshift_vec(pn, delta_phi*(src_msg(k)-M/2)); 
                y((k-1)*len_pn+1:k*len_pn) = -cycpn;
            end
        end
    end
    
% Demodulation
elseif  strncmpi(modem, 'demod', 5) 
    rx_sig = x;
    nchip = length(rx_sig);          
    if mod(nchip, len_pn)~=0
        error('Number of chips must be multiple of length of PN sequence');
    end
    nsym = nchip/len_pn;            
    sym = zeros(nsym,1);
    peak = zeros(nsym,1);
    
    if strncmpi(csk_polar, 'uni', 3)             
        for k=1:nsym
            r = cycxcorr_fft(rx_sig((k-1)*len_pn+1:k*len_pn), pn)/len_pn; 
            r_M = r([delta_phi*(1:M-1), end]);      
            peak(k) = max(r_M);                 
            pos = find(r_M == peak(k));
            pos = pos(1);   
            if pos==M
                sym(k) = 0;             % M-->0
            else
                sym(k) = pos;  
            end
        end
    elseif strncmpi(csk_polar, 'bi', 2)         
        for k=1:nsym
            r = cycxcorr_fft(rx_sig((k-1)*len_pn+1:k*len_pn), pn)/len_pn;
            r_M = r([delta_phi*(1:M/2-1), end]);  
            r_M_abs = abs(r_M);     
            pos = find(r_M_abs == max(r_M_abs));
            pos = pos(1);
            peak(k) = r_M(pos);
            msb = (r_M(pos)<0);               
            if pos==M/2
                sym(k) = 0+msb*M/2;
            else
                sym(k) = pos+msb*M/2;
            end
        end       
    end
    
    y = dec2bin(sym, nbit_per_sym)-'0';    
    y = y.';
    y = y(:);
%     figure; plot(r);
%     hold; plot([delta_phi*(1:M-1), len_pn], r_M,'ro');
else
    error('modem must be ''mod'' for modulation or ''demod'' for demodulation');
end

return
% % % % % % EOF ---- ccsk_modem.m


function y = circshift_vec(x, shiftlen)
if ~isvector(x)
    error('Matrix is not supported. Please refer to circshift');
end
ort = size(x,1);    % assure that x, if one dimensional, has the correct orientation
if ort==1
    x = x(:);
end
pos = mod(shiftlen, length(x));
if pos~=0
    y = [x(end-pos+1:end); x(1:end-pos)];       
else
    y = x;
end

if ort==1
    y = y(:).';
end
return
% % % % % % EOF ---- circshift_vec.m

