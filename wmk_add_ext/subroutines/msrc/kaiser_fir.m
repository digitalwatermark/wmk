% FIR design using Kaiser window
% % % % % % % % % 

function h=kaiser_fir(fcuts, fs, Rpass, Astop, type)

fcuts = fcuts/(fs/2);

if strcmpi(type, 'LPF')
    mags = [1, 0];
    devs = [Rpass, 10^(Astop/20)];
elseif strcmpi(type, 'BPF')
    mags = [0, 1, 0];
    devs = [10^(Astop/20), Rpass, 10^(Astop/20)];
elseif strcmpi(type, 'HPF')
    mags = [0, 1];
    devs = [10^(Astop/20), Rpass];
else
    error('Filter type must be ''LPF'', ''BPF'' or ''HPF''.');
end

[N, wn,beta,ftype] = kaiserord(fcuts, mags, devs);
h = fir1(N, wn, ftype, kaiser(N+1,beta), 'noscale');

return