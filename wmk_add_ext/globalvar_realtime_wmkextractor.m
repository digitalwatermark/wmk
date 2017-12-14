% global variables for real-time watermarking extractor
global DA_Polar;                    % 1/-1: sound signals are non-inverted/inverted; check the devices before using
global AD_Polar;                    % 1/-1: sound signals are non-inverted/inverted; check the devices before using
global Phone_Enable;            % 1:use phone as sound output; 0: no sound outputs
global Mic_Enable;                 % 1: from microphone; 0: from file
global Input_Gain;                   % input gain
global Sync_State;                  % synchronization states and parameters

global SinkBit_Buffer;             % sink bit buffer
global Len_SinkBit_Buffer;    % length of sink bit buffer
global WP_SinkBit_Buffer;    % write pointer of sink bit buffer
global N_SinkBit;                     % total number of sink bits
global Start_SinkWord;           % start of sink words

global Rx_String;
global Str_Buffer;
global Sync_Word;

% global Fig_Handle;
% global Mini_Display_On;

global Transition_Matrix;        % transition matrix for sync states

global Rx_Buffer;
global Nframes_Rx_Buffer;
global Nframes_In_Rx_Buffer;

% global Pr_Rx_Buffer;
% global Pt_Rx_Buffer;

global Files_Config;
global Algorithm_Param;

global Fs;
global Key;
global Wmk_Format;          % 'text', 'bin', or 'mat'
global Hplot;                       % object handles for realtime plotting
global Plot_Enable;         % Plot_Enable(1)=1/0 for wavform on/off; (2) for psd
% global Plot_IO;            % 1: input; 0: output
global Ai;
global Ao;

global Len_Seg;

global Ref_Wmk_Text;            % reference watermark characters
global Ref_Wmk_Bit;               % reference watermark bits

global N_CurrentErrorBit; % number of bit errors in current sync
global N_PreviousErrorBit;  % number of bit errors in previous syncs
global BER;                       % bit error rate
global BER_Enable; 
global RP_BER;               % read pointer to calculate BER

global Bit_Format;            % format to display bits, 'bin' or 'hex'
global N_CharPerLine;    % number of characters in each line (invalid if Wmk_Type=='text')

global Wmk_Type;            % extractable or detectable
global Nrow_TableHeader;

global Nframe_SoundDelay;
global readfileID;
global ReadInital;
global fileclosename;
global Timer t;
global count;
global overtime;