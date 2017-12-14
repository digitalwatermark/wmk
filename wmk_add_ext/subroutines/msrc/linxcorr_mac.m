
function z = linxcorr_mac(x,y)
x = x(:);
y = y(:);
Nx = length(x);
Ny = length(y);
Nout = Nx+Ny-1;  
Nmin = min(Nx, Ny);

if Nmin>3*log2(max(Nx, Ny)) 
    warning('Sequences too long. Use linxcorr_fft() instead.to achieve better performance');
end

z = zeros(Nout,1);

if Nx<Ny
    for ii=1:Nx
        z = z+x(ii)*[zeros(ii-1,1); y(end:-1:1); zeros(Nx-ii,1)];
    end
else
    for ii=1:Ny
        z = z+y(ii)*[zeros(Ny-ii,1); x; zeros(ii-1,1)];
    end
end

return