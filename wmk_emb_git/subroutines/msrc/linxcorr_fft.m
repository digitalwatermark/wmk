% % Peng Zhang     Tsinghua Univ.    2008.10.15
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function z = linxcorr_fft(x,y)
% 
%--------------------------------------------------------------------------

function z = linxcorr_fft(x,y)
x = x(:);
y = y(:);
Nx = length(x);
Ny = length(y);
Nout = Nx+Ny-1;                    

NFFT = 2^nextpow2(Nout);     
y_r = conj(y(end:-1:1));            

X = fft([x;zeros(NFFT-Nx,1)]); 
                                                   
Y = fft([y_r;zeros(NFFT-Ny,1)]);
z = ifft(X.*Y, NFFT);

z = z(1:Nout);                             
return