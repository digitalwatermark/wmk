% % Psychoacoustic Model in MPEG-1
% % 2009.03.02
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function [X, Lsb, LTmin, SMRsb, Delta_SPL, S] = psychoacoustic_model_mpeg( ...
%               x, fs, OFFSET, TH, Map, LTq, CB, C, h, M)
% I/O Arguments:
% see sub-functions
% Note:
% Example:
% Algorithm:
% Revision:
% 2010-03-02: return subband samples S
% See also:
% References:
% [1] Information technology -- Coding of moving pictures and associated
%      audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%      British standard. BSI, London. October 1993. Implementation of ISO/IEC
%      11172-3:1993. BSI, London. First edition 1993-08-01.
% [2] MPEG psychoacoustic model I for MATLAB - Version 1.2.8, 
%      Fabien A. P. Petitcolas, Computer Laboratory, University of Cambridge, 
%      www.cl.cam.ac.uk/~fapp2/software/mpeg/

% Computational cost:
% Profile report:

%-------------------------------------------------------------------------------

function [X, Lsb, LTmin, SMRsb, Delta_SPL, S] = psychoacoustic_model_mpeg( ...
              x, fs, OFFSET, TH, Map, LTq, CB, C, h, M)
            
% global_mpeg;                 
global FFT_SIZE;            % only declare used global variables !!
global FFT_OVERLAP;

%%% Psychoacoustic analysis.

% Compute the FFT for time frequency conversion [1, pp. 110].
[X, Delta_SPL] = FFT_Analysis(x, OFFSET, h, FFT_SIZE, FFT_OVERLAP);


%{
global_mpeg;

%%% Subband filter analysis. Layer 1 uses 12 samples per subband.
% Analysis subband filtering [1, pp. 67].
%    C = Table_analysis_window;
%    S = [];
%    for i = 0:11,
%       S = [S; Analysis_subband_filter(x, OFFSET + 32 * i, C)];
%    end

S = zeros(12, 32);
for i = 0:11
    S(i+1, :) = subband_filter_mpeg(x, OFFSET + 32 * i, C, M);
end

% Scalefactor calculation [1, pp. 70].
scf = Scale_factors(S);

% Determine the sound pressure level in each  subband [1, pp. 110].
Lsb = Sound_pressure_level(X, scf);          % size=1*32

% Find the tonal (sine like) and non-tonal (noise like) components
% of the signal [1, pp. 111--113]
[Flags Tonal_list Non_tonal_list] = Find_tonal_components(X, TH, Map, CB);

% Decimate the maskers: eliminate all irrelevant maskers [1, pp. 114]
[Flags Tonal_list Non_tonal_list] = ...
    Decimation(X, Tonal_list, Non_tonal_list, Flags, TH, Map);

% Compute the individual masking thresholds [1, pp. 113--114]
[LTt, LTn] = ...
    Individual_masking_thresholds(X, Tonal_list, Non_tonal_list, TH, Map);
%   [LTt2, LTn2] = ...
%       Individual_masking_thresholds2(X, Tonal_list, Non_tonal_list, TH, Map);
%   max(max(abs(LTt-LTt2)))
% max(max(abs(LTn-LTn2)))

% Compute the global masking threshold [1, pp. 114]
LTg = Global_masking_threshold(LTq, LTt, LTn);
%       disp('Global masking threshold');
%       hold on;
%       plot(TH(:, INDEX), LTg, 'k--');
%       hold off;
%       title('Masking components and masking thresholds.');

% Determine the minimum masking threshold in each subband [1, pp. 114]
LTmin = Minimum_masking_threshold(LTg, Map);
%       figure; plot(LTmin); title('Minimum masking threshold');
%       xlabel('Subband number'); ylabel('dB'); pause;

% Compute the singal-to-mask ratio
SMRsb = Lsb(:) - LTmin(:);

% S2 = S;
% Flags2 = Flags; Tonal_list2 = Tonal_list; Non_tonal_list2 = Non_tonal_list;
% LTt2 = LTt; LTn2 = LTn; LTg2 = LTg; LTmin2 = LTmin; Lsb2 = Lsb;
% SMRsb2 = SMRsb;

%}



% % use DLL (overhead in getting pointers)
% libname = 'Analysis_subband_filter_dll';
% if ~libisloaded(libname)
%     loadlibrary(libname,  [libname,'.h']);
% end
% S = zeros(12,32);
% px = libpointer('doublePtr', x);        %  see Primitive Types
% pC= libpointer('doublePtr', C);
% pM = libpointer('doublePtr', M);
% pS = libpointer('doublePtr', S);
% calllib(libname, 'Analysis_subband_filter', px, length(x), OFFSET, pC, pM, pS);
% S = get(pS, 'value');
% % unloadlibrary(libname);

% % use MEX (2 times faster than m-function)
S = Analysis_subband_filter_mex(x, OFFSET, C, M);

% Call Mex-function for SMR calculation
[Flags, Tonal_list, Non_tonal_list, LTt, LTn, LTg, LTmin, Lsb, SMRsb] = SMR_MPEG1(X, TH, Map, CB, S);


% for testing C functions
%{
 if max(max(abs(S-S2)))>1e-6        % test ok
        disp('S wrong');
 end
if ~isempty(Tonal_list2) || ~isempty(Tonal_list)
    if max(max(abs(Tonal_list - Tonal_list2)))>1e-6        % test ok
        disp('Tonal_list wrong');
    end
end
if ~isempty(Non_tonal_list2) || ~isempty(Non_tonal_list)
    if max(max(abs(Non_tonal_list - Non_tonal_list2)))>1e-6        % test ok
        disp('Non_tonal_list wrong');
    end
end
 if max(max(abs(Flags - Flags2)))>1e-6        % test ok
        disp('Flags wrong');
 end
if ~isempty(LTt2) || ~isempty(LTt)
    if max(max(abs(LTt2 - LTt)))>1e-6        % test ok
        disp('LTt wrong');
    end
end
if ~isempty(LTn2) || ~isempty(LTn)
    if max(max(abs(LTn2 - LTn)))>1e-6        % test ok
        disp('LTn wrong');
    end
end  
 if max(max(abs(LTg - LTg2.')))>1e-6        % test ok
        disp('LTg wrong');
 end
 if max(max(abs(LTmin - LTmin2.')))>1e-6        % test ok
       disp('LTmin wrong');
 end
  if max(max(abs(SMRsb - SMRsb2)))>1e-6        % test ok
        disp('SMRsb wrong');
  end
 %}