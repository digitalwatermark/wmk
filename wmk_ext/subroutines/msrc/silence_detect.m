% Silence Detection for Sound Signals
% Peng Zhang, Tsinghua Univ. 2011-07-25

function [silence, output] = silence_detect(x, threshold)

if size(x, 1)==1
    x = x(:);
end

% default parameter values
default_threshold = struct();
default_threshold.Energy = 1e-5;
default_threshold.ZCR = 1e-3;

names = fieldnames(default_threshold);

% default parameter value
if nargin<2 || ~isstruct(threshold)
    threshold = default_threshold;
else    
    for ii=1:length(names)
        if ~isfield(threshold, names{ii})
            threshold.(names{ii}) = default_threshold.(names{ii});
        end
    end
end

N = length(x);
nchan = size(x, 2);

silence = zeros(1, nchan);
for ii=1:length(names)
    output.(names{ii}) = zeros(1, nchan);
end

for nn=1:nchan
%     Lseg = 256;
%     xseg = reshape(x(:,nn), Lseg, N/Lseg);
%     eseg = mean(xseg.^2,1);
%     papr = max(eseg)/mean(eseg);       
    
    energy = mean(x(:,nn).^2);            
    zcr = sum(abs(diff(x(:,nn)>0)))/N;      

    silence(nn) = energy<threshold.Energy || zcr<threshold.ZCR;
    
    output.Energy(nn) = energy;
    output.ZCR(nn) = zcr;
end

% semilogy(eseg)
% hold on
% semilogy(mean(eseg)*ones(length(eseg),1),'r')
% ylim([1e-8, 1])
% hold off
