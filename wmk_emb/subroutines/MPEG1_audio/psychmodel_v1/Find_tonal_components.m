
% Revised by Peng Zhang, Tsinghua Univ., 2009-02-28
% accelerated (1~2 times faster); Layer II supported
% 1 bug fixed: error using mean()
%-------------------------------------------------------------------------------

function [Flags, Tonal_list, Non_tonal_list] = ...
   Find_tonal_components(X, TH, Map, CB) % assume fs = 44100 fs
%[Flags, Tonal_list, Non_tonal_list] = Find_tonal_components(X, TH, Map, CB)
%
%   Identifie and list both tonal and non-tonal components of the audio
%   signal. It is assume in this implementation that the frequency
%   sampling fs is 44100 Hz. Details bare given in [1, pp. 112].
%
%   See also Decimation
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2003 by Fabien A. P. Petitcolas
%   Find_tonal_components.m
%   Last modified: 11 August 2003

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%
%   Legal notice:
%    This computer program is based on ISO/IEC 11172-3:1993, Information
%    technology -- Coding of moving pictures and associated audio for digital
%    storage media at up to about 1,5 Mbit/s -- Part 3: Audio, with the
%    permission of ISO. Copies of this standards can be purchased from the
%    British Standards Institution, 389 Chiswick High Road, GB-London W4 4AL, 
%    Telephone:+ 44 181 996 90 00, Telefax:+ 44 181 996 74 00 or from ISO,
%    postal box 56, CH-1211 Geneva 20, Telephone +41 22 749 0111, Telefax
%    +4122 734 1079. Copyright remains with ISO.
%-------------------------------------------------------------------------------
global_mpeg;

% Check input parameters
if (length(X) ~= FFT_SIZE)
   error('Unexpected power density spectrum size.');
end

% List of flags for all the frequency lines (1 to FFT_SIZE / 2)
Flags = zeros(FFT_SIZE / 2, 1) + NOT_EXAMINED;
%%
% Label the local maxima

% local_max_list = [];
% counter = 1;
% for k = 2:FFT_SIZE / 2 -  1, % Don't care about the borders
%    if (X(k) > X(k-1) && X(k) >= X(k+1) && k > 2 && k <= 250)    % 250: below will process
%       local_max_list(counter, INDEX) = k;
%       local_max_list(counter, SPL) = X(k);
%       counter = counter + 1;
%    end
% end

% new code
% k>250 can be a local maxima but can not be a tonal
a = (X(2:end/2-1) > X(1:end/2-2));
b = (X(2:end/2-1) > X(3:end/2));
idx = find(a&b)+1;
local_max_list = [idx, X(idx)];         % DO NOT change: INDEX=1, SPL=2

% max(max(abs(local_max_list2-local_max_list)))

if (DRAW)
    t = 1:length(X);
   disp('Local maxima.');
   plot(t, X(t), local_max_list(:, INDEX), local_max_list(:, SPL), 'ko');
   xlabel('Frequency index'); ylabel('dB'); title('Local maxima.');
   axis([0 256 0 100]); pause;
end

%%
% List tonal components and compute sound pressure level
Tonal_list = [];
counter = 1;
if not(isempty(local_max_list))
    for i = 1:length(local_max_list(:, 1))
        k = local_max_list(i, INDEX);
        is_tonal = 1;

        % Layer I
        % Examine neighbouring frequencies
        J = [];
        if (2 < k && k < 63)
            J = [-2 2];
        elseif (63 <= k && k < 127)
            J = [-3 -2 2 3];
        elseif (127 <= k && k <= 250)
            J = [-6:-2, 2:6];
        elseif FFT_SIZE==1024                % for Layer II: FFT_SIZE=1024
            if (250 <= k && k < 255)
                J = [-6:-2, 2:6];
            elseif (255 <= k && k <= 500)
                J = [-12:-2, 2:12];
            else
                is_tonal = 0;
            end
        else
            is_tonal = 0;
        end

%         for j = J
%             is_tonal = is_tonal && (X(k) - X(k + j) >= 7);
%         end

        % new code
        if is_tonal
            is_tonal = all(X(k) - X(k + J) >= 7);
        end

        % If X(k) is actually a tonal component then the following are listed
        %    - index number k of the spectral line
        %    - sound pressure level
        %    - set tonal flag
        if is_tonal
            Tonal_list(counter, INDEX) = k;
            % 	      Tonal_list(counter, SPL) = 10*log10(10^(X(k-1)/10)+10^(X(k)/10)+10^(X(k+1)/10));
            Tonal_list(counter, SPL) = 10*log10(sum(10.^(X(k-1:k+1)/10)));

            Flags(k) = TONAL;
            % 	      for j = [J -1 1],
            % 	         Flags(k + j) = IRRELEVANT;
            %           end
            Flags(k + [J, -1, 1]) = IRRELEVANT;
            counter = counter + 1;
        end
    end
    if (DRAW)
        disp('Tonal components');
        plot(t, X(t), Tonal_list(:, INDEX), Tonal_list(:, SPL), 'ro');
        xlabel('Frequency index'); ylabel('dB'); title('Tonal components');
        axis([0 FFT_SIZE/2 0 100]); pause;
    end
end

%%
% List the non tonal components and compute power
% All the spectral lines that have not been examined during the previous
% search are summed together to form the non-tonal component.
Non_tonal_list = [];
% counter = 1;
for i = 1:length(CB(:, 1)) - 1
   % For each critical band, compute the power
   % in non-tonal components
   
%    power  = MIN_POWER; % Partial sum
%    weight = 0; % Used to compute the geometric mean of the critical band
%    for k = TH(CB(i), INDEX):TH(CB(i + 1), INDEX) - 1, % In each critical band
%       if (Flags(k) == NOT_EXAMINED),
%          power    = 10 * log10(10^(power / 10) + 10^(X(k) / 10));     % slow !
%          weight   = weight + 10^(X(k) / 10) * (TH(Map(k), BARK) - TH(CB(i), BARK)');
%          Flags(k) = IRRELEVANT;
%       end
%    end
   
   % TH(Map(k), BARK)-TH(CB(i), BARK)<=1 in one critial band !!!
   % new code (fast)
    idx = find(Flags(TH(CB(i), INDEX):TH(CB(i + 1), INDEX)-1) == NOT_EXAMINED) ...
        +TH(CB(i), INDEX)-1;
    power = 10*log10(sum(10.^([X(idx);MIN_POWER]/10)));
    if ~isempty(idx)
        weight = sum(10.^(X(idx)/10) .* (TH(Map(idx), BARK) - TH(CB(i), BARK)));
    else
        weight = 0;
    end
    Flags(idx) = IRRELEVANT;

   
   % The index number for the non tonal component is the index nearest
   % to the geometric mean of the critical band
   if (power <= MIN_POWER)
%       index = round(mean(TH(CB(i), INDEX), TH(CB(i + 1), INDEX)));  % bug: mean(a,b)~=mean([a,b])
      index = round(mean([TH(CB(i), INDEX), TH(CB(i + 1), INDEX)]));  
   else
      index = TH(CB(i), INDEX) + round(weight / 10^(power / 10) * ...
         (TH(CB(i + 1), INDEX) - TH(CB(i), INDEX)));
   end
   
   if (index < 1)
      index = 1;
   elseif (index > length(Flags))
      index = length(Flags);
   end
   if (Flags(index) == TONAL)
      index = index + 1;            % Two tonal components cannot be consecutive
   end
   
   % For each subband
   %   - index of the non-tonal component
   %   - sound pressure level of this component
   Non_tonal_list(i, INDEX) = index;
   Non_tonal_list(i, SPL) = power;
   Flags(index) = NON_TONAL;
end

if not(isempty(Tonal_list))
    if (DRAW),
        disp('Tonal and non-tonal components');
        plot(t, X(t), Tonal_list(:, INDEX), Tonal_list(:, SPL), 'ro', ...
            Non_tonal_list(:, INDEX), Non_tonal_list(:, SPL), 'go');
        xlabel('Frequency index'); ylabel('dB'); 
        title('Tonal and non-tonal components'); 
        axis([0 256 0 100]); pause;
    end
end
