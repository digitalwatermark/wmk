
% % % % % % % % % % % % % % % % % % % % % % % % %
% %                  Pseudorandom sequence generator                    %
% %            Peng Zhang     Tsinghua Univ.    2008.01.01             %
% % % % % % % % % % % % % % % % % % % % % % % % %
% function y = pngenerator(pn_len, pn_range, pn_seed)

%--------------------------------------------------------------------------

function y = pngenerator(pn_len, pn_range, pn_seed)

rand('seed', pn_seed);              % initialize
% s = rand('pn_seed');              % save state     
% y = round(pn_range(1)+(pn_range(2)-pn_range(1))*rand(pn_len,1));

% rand('seed', pn_seed);              % initialize
y = randint(pn_len,1,pn_range);