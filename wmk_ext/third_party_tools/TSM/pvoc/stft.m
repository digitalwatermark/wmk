function d = stft(x, f, w, h)
% D = stft(X, F, W, H)                            Short-time Fourier transform.
%	Returns some frames of short-term Fourier transform of x.  Each 
%	column of the result is one F-point fft; each successive frame is 
%	offset by H points until X is exhausted.  Data is hamm-windowed 
%	at W pts..
%	See also 'istft.m'.
% dpwe 1994may05.  Uses built-in 'fft'
% $Header: /homes/dpwe/public_html/resources/matlab/RCS/stft.m,v 1.1 2002/02/13 16:15:55 dpwe Exp $

s = length(x);

if rem(w, 2) == 0   % force window to be odd-len
  w = w + 1;
end

halflen = (w-1)/2;
halff = f/2;   % midpoint of win
acthalflen = min(halff, halflen);

halfwin = 0.5 * ( 1 + cos( pi * (0:halflen)/halflen));
win = zeros(1, f);
win((halff+1):(halff+acthalflen)) = halfwin(1:acthalflen);
win((halff+1):-1:(halff-acthalflen+2)) = halfwin(1:acthalflen);

c = 1;

% pre-allocate output array
d = zeros((1+f/2),1+fix((s-f)/h));

for b = 0:h:(s-f)
  u = win.*x((b+1):(b+f));
  t = fft(u);
  d(:,c) = t(1:(1+f/2))';
  c = c+1;
end;
