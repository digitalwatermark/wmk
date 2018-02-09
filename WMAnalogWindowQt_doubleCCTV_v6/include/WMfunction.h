#include "WMdefine.h"
#include "ifft_fft.h"


int    psy_top();

void 	SMR(double *,double *,double *,_table *);

void	Cal_scf(_DataStruct *,double Scf[32], double *,_table *);

void	Cal_Lsb(_DataStruct *,double *,double *);

void    Cal_psd(_DataStruct *,_DataStruct *,_DataList *);

void    Cal_Smrsb(double *,double *,double *);

void    Phycho_layerone(_DataList *,double *,_table *);

void    table_init48(int,_table *);

void    table_init441(int,_table *);

void    Music_Piecewise(_DataStruct *,_DataStruct *);

void    Hanning_Win(_DataStruct *, Complex *);

void    ifft_fft(Complex *, int);

void    fft_96db_normalize(Complex *,_DataStruct *,_DataList*);

void    Finding_tonal_component(_DataList *,_table *);

void    Finding_Ntonal_component(_DataList *,_table *);

void    Tonal_Ntonal_decimate(_DataList *,_table * );

void    Cal_T_N_mask(_DataList *,_DataStruct *, _table *);

void    Minimum_masking_threshold(_DataStruct  *,double *,_table *);

void    Analysis_subband_filter(double *,_DataStruct *,_table *);//wyn

double  MAX(double a,double b);//wyn

void    Scale_factors(double *,double *);//wyn

void	FFT_Analysis(_DataStruct *,int);//wxg

void	DataTypeChange(unsigned char *, _DataStruct *);

void    GibbsWin(_DataStruct *,_DataStruct*);

double	db_add(double, double);

void    PnGen(_SigInoiseStruct );

//void  	Wave_Rd();

void    wavhead_get(_table *Param);

void    wavwrite(int looptime, int last);

void    waveend();

void    data_convert();

void    frame_perfix();

void    wmk_gen(_table *);
 
void    noise_masking(_table *);

void    noise_masking_sub(_table *);

void    sys_int(_table *);

void    noise_gen(_DataStruct *,_table *);

void    SniMask(double *, double *, double *,double *);

void    Synthesis_subband_filter(double*,double*);

void    AnalogOutDataWrite(int BoxNum);



double Abs(double);

void    extractor_init();

void    wmk_extrac();

void    dss_sync( );

void    extractor_acq();

void    process_acquireddata();

void    linxcorr_fft(Complex *);

double  Sig_Engergy(double *,int);
