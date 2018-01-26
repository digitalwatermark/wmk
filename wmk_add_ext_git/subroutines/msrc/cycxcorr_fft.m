% % Peng Zhang     Tsinghua Univ.    2008.10.15
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function z = cycxcorr_fft(x,y)

%--------------------------------------------------------------------------

function z = cycxcorr_fft(x,y)
x = x(:);
y = y(:);
Nx = length(x);
Ny = length(y);

y_r = conj(y(end:-1:1));            

if Nx>Ny                                    
    nrep = ceil(Nx/Ny);              
    y_r = repmat(y_r, nrep, 1);  
end

NFFT = length(y_r);

X = fft(x,NFFT,1);                      
                                                   
                                                  
                                                   
Y = fft(y_r,NFFT,1);                    
z = ifft(X.*Y,NFFT,1);

z = z(1:Ny);                               
return