
% Revised by Peng Zhang , Tsinghua Univ., 2009-03-01
% matrixed but slower
%-------------------------------------------------------------------------------

function  [LTt, LTn] = Individual_masking_thresholds2(X, Tonal_list, ...
   Non_tonal_list, TH, Map)
%[LTt, LTn] = Individual_masking_thresholds(X, Tonal_list, ...
%   Non_tonal_list, TH, Map)
%
%   Compute the masking effect of both tonal and non_tonal components on
%   the neighbouring spectral frequencies [1, pp. 113]. The strength os the
%   masker is summed with the masking index and the masking function.
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Individual_masking_thresholds.m 4     18/07/02 14:38 Fabienpe $
%   $Id: Individual_masking_thresholds.m,v 1.3 1998-06-24 13:34:17+01 fapp2 Exp $

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

% Individual masking thresholds for both tonal and non-tonal 
% components are set to -infinity since the masking function has
% infinite attenuation beyond -3 and +8 barks, that is the component
% has no masking effect on frequencies beyond thos ranges [1, pp. 113--114]
if isempty(Tonal_list)
   LTt = [];
else
   LTt = zeros(length(Tonal_list(:, 1)), length(TH(:, 1))) + MIN_POWER;
end
LTn = zeros(length(Non_tonal_list(:, 1)), length(TH(:, 1))) + MIN_POWER;

% Only a subset of the samples are considered for the calculation of
% the global masking threshold. The number of these samples depends
% on the sampling rate and the encoding layer. All the information
% needed is in TH which contains the frequencies, critical band rates
% and absolute threshold.
if ~isempty(Tonal_list)
    for i = 1:length(TH(:, 1))
        zi = TH(i, BARK);  % Critical band rate of the frequency considered

        zj = TH(Map(Tonal_list(:, INDEX)), BARK); % Critical band rate of the masker
        dz = zi - zj;          % Distance in Bark to the masker

        Xt = X(Tonal_list(:, INDEX));
        % Masking index
        avtm = -1.525 - 0.275 * zj - 4.5;

        % Masking function
        vf = (-3 <= dz & dz < -1).*(17 * (dz + 1) - (0.4 * Xt + 6)) ...
            + (-1 <= dz & dz < 0).*((0.4 * Xt + 6) .* dz) ...
            + (0 <= dz & dz < 1).*(-17 * dz) ...
            + (1 <= dz & dz < 8).*(- (dz - 1) .* (17 - 0.15 * Xt) - 17);


        LTt(:, i) = (dz >= -3 & dz < 8).*(Tonal_list(:, SPL) + avtm + vf) ...
            + (dz < -3 | dz > 8).*MIN_POWER;
    end
end

for i = 1:length(TH(:, 1))
    zi = TH(i, BARK);  % Critical band rate of the frequency considered

    zj = TH(Map(Non_tonal_list(:, INDEX)), BARK); % Critical band rate of the masker
    dz = zi - zj;          % Distance in Bark to the masker

    Xn = X(Non_tonal_list(:, INDEX));
    % Masking index
    avnm = -1.525 - 0.175 * zj - 0.5;

    % Masking function
    vf = (-3 <= dz & dz < -1).*(17 * (dz + 1) - (0.4 * Xn + 6)) ...
        + (-1 <= dz & dz < 0).*((0.4 * Xn + 6) .* dz) ...
        + (0 <= dz & dz < 1).*(-17 * dz) ...
        + (1 <= dz & dz < 8).*(- (dz - 1) .* (17 - 0.15 * Xn) - 17);

    LTn(:, i) = (dz >= -3 & dz < 8).*(Non_tonal_list(:, SPL) + avnm + vf) ...
        + (dz < -3 | dz > 8).*MIN_POWER;
end


% Add the indicudual masking thresholds to the existing graph
if (DRAW)
    if not(isempty(Tonal_list))
        hold on;
        for j = 1:length(Tonal_list(:, 1))
            plot(TH(:, INDEX), LTt(j, :), 'r:');
        end
        disp('Masking threshold for tonal components.');
        pause;
    end
    for j = 1:length(Non_tonal_list(:, 1))
        plot(TH(:, INDEX), LTn(j, :), 'g:');
    end
    hold off;
    disp('Masking threshold for non-tonal components.');
    pause;
end
