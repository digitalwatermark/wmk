% % Find in binary vector
% % Peng Zhang     Tsinghua Univ.    2009.12.10
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function index = binvecfind(x, pattern)


function index = binvecfind(x, pattern)

% error check
if ~all((x(:)==0)+(x(:)==1)) || ~all((pattern(:)==0)+(pattern(:)==1))
    error('Input vector must be binary.');
end


if ( size(x,1) == 1)         
    x = x(:);
end
pattern_str = char(pattern(:).'+'0');
index = [];

for ii=1:size(x, 2)
%     x_str = int2str(x(:, ii)).';     
    x_str = char(x(:,ii).'+'0');
    pos = strfind(x_str, pattern_str);

%{
    r = linxcorr_fft(1-2*x(:, ii), 1-2*pattern(:));  
    pos = find(abs(r-length(pattern))<1e-8)-length(pattern)+1;
%}
    
    if size(x, 2)==1
        index = pos(:);
    else
        index = [index; [pos(:) repmat(ii, length(pos), 1)]];
    end
end

return