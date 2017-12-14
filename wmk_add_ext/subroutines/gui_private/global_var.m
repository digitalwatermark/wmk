
% Global paths and files (default: [])
global Dir_Home;
global Dir_Output;
global Dir_Attack;
global Filename_Cover;
global Filename_Stego;
global Files_Wav;
global Files_Watermark;
global Files_Config;
global Algorithm_Emb_Extr;
global Algorithm_Sync;
global Key_Emb;
global Key_Extr;

% Attack enable/disable (default: 1)
global Attack_On_AWGN;
global Attack_On_AS;
global Attack_On_Filter;
global Attack_On_MP3;
global Attack_On_AAC;
global Attack_On_Resamp;
global Attack_On_Requantz;
global Attack_On_Crop;
global Attack_On_Echo;
global Attack_On_TSM;
global Attack_On_PS;
global Attack_On_Jitter;

% Attack options
global Attack_Option_Filter;
global Attack_Option_MP3;
global Attack_Option_AAC;
% global Attack_Option_Resamp;
global Attack_Option_Crop;
global Attack_Option_TSM;
global Attack_Option_PS;

% Attack parameters (default: [])
global Attack_Param_AWGN;
global Attack_Param_AS;
global Attack_Param_Filter;
global Attack_Param_MP3;
global Attack_Param_AAC;
global Attack_Param_Resamp;
global Attack_Param_Requantz;
global Attack_Param_Crop;
global Attack_Param_Echo;
global Attack_Param_TSM;
global Attack_Param_PS;
global Attack_Param_Jitter;

% Sweeping enable/disable (default: 0)
global Sweep1_On;
global Sweep2_On;

% Sweeping parameters (default: [])
global Sweep_Param1;
global Sweep_Param2;

% Sequential Reading Enable/Disable (default: 0)
global Sequential_On;


%%
% % % % % % % % % % % % % % % % % % % % % % % % % % 
% Other global variables which need not to be configured manually
% % % % % % % % % % % % % % % % % % % % % % % % % % 
global PLAYER;
global Report_Filename;
global Log_Filename;
global XLS_Startcolumn;
global XLS_Extrarow;

% Attack option table (contant)
global Table_Attack_Option_Filter;
global Table_Attack_Option_MP3;
global Table_Attack_Option_AAC;
% global Table_Attack_Option_Resamp;
global Table_Attack_Option_Crop;
global Table_Attack_Option_TSM;
global Table_Attack_Option_PS;

% Attacked filename template (constant)
global Attack_Filename_AWGN;
global Attack_Filename_AS;
global Attack_Filename_Filter;
global Attack_Filename_MP3;
global Attack_Filename_AAC;
global Attack_Filename_Resamp;
global Attack_Filename_Requantz;
global Attack_Filename_Crop;
global Attack_Filename_Echo;
global Attack_Filename_TSM;
global Attack_Filename_PS;
global Attack_Filename_Jitter;

global Attack_Suffix_Name;


% Current sweeping variable (default: [])
global Sweep_Var1;
global Sweep_Var2;

% Statistics vs. sweeping variables (default: [])
global Sweep_CAP;
global Sweep_SNR;
global Sweep_ODG;
global Sweep_BER;

% Temp variables (default: [])
global Temp_CAP;
global Temp_SNR;
global Temp_ODG;
global Temp_BER;

