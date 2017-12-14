% global variables for real-time watermarking embedderglobal
global Timer t;
global Files_Wav;
global File outfile;
global fileclosename;
global writesignal;
global Key;
global AD_Polar;              % 1/-1: sound signals are non-inverted/inverted; check the devices before using
global DA_Polar;              % 1/-1: sound signals are non-inverted/inverted; check the devices before using
global pcmWMKdata;

global Mic_Enable;                 % 1:use microphone as sound input; 0: sound from file
global Input_Gain;                   % input gain (from Mic)
global Fs;

global Play_Mode;          % 'Once', 'Repeat', or 'Repeat all'
global Sync_Word;
global Wmk_Format;          % 'text'/'bin'/'mat'
global Wmk_Text;
global Wmk_Bit;

global Ai;
global Ao;
global Hplot;
global Plot_Enable;
global Plot_IO;

global Signal_Buffer;
global Pnmod_Buffer;
global Len_Buffer;
% global Nframe_In_Buffer;

global Fig_Handle;
global Mini_Display_On;


global Files_Wav;
global Files_Watermark;
global Files_Config;
global Algorithm_Param;

global Current_Bit_Index;
global Current_Wav_Index;
global Selected_Wav_Index;
global Current_Sample_Index;
global Current_Wav_Info;

global Obj_Handle;

global Npad_Prefix;
global Npad_Suffix;

global Bit_Format;            % format to display bits, 'bin' or 'hex'
global N_CharPerLine;    % number of characters in each line (invalid if Wmk_Type=='text')

global Wmk_Type;            % extractable or detectable
global Wmk_Bypass; 
global Nrow_TableHeader;

global Nframe_SoundDelay;