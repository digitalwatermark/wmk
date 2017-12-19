
/***********************************************************************
*
*  Encoder Include Files
*
***********************************************************************/

/***********************************************************************
*
*  Encoder Definitions
*
***********************************************************************/

/* Psychacoustic Model 1 Definitions */

#define CB_FRACTION     0.33
#define MAX_SNR         1000
#define NOISE           10
#define TONE            20
#define DBMIN           -200.0
#define LAST            -1
#define STOP            -100
#define POWERNORM       90.3090 /* = 20 * log10(32768) to normalize */
                                /* max output power to 96 dB per spec */

/* Psychoacoustic Model 2 Definitions */

#define LOGBLKSIZE      10
#define BLKSIZE         1024
#define HBLKSIZE        513
#define CBANDS          63
#define LXMIN           32.0

/***********************************************************************
*
*  Encoder Type Definitions
*
***********************************************************************/

/* Psychoacoustic Model 1 Type Definitions */

typedef int        IFFT2[FFT_SIZE/2];
typedef int        IFFT[FFT_SIZE];
typedef double     D9[9];
typedef double     D10[10];
typedef double     D640[640];
typedef double     D1408[1408];
typedef double     DFFT2[FFT_SIZE/2];
typedef double     DFFT[FFT_SIZE];
typedef double     DSBL[SBLIMIT];
typedef double     D2SBL[2][SBLIMIT];

typedef double SBS[2][3][SCALE_BLOCK][SBLIMIT];

typedef struct {
        int        line;
        double     bark, hear, x;
} g_thres, *g_ptr;

typedef struct {
        double     x;
        int        type, next, map;
} mask, *mask_ptr;

/* Psychoacoustic Model 2 Type Definitions */

typedef int        ICB[CBANDS];
typedef int        IHBLK[HBLKSIZE];
typedef FLOAT      F32[32];
typedef FLOAT      F2_32[2][32];
typedef FLOAT      FCB[CBANDS];
typedef FLOAT      FCBCB[CBANDS][CBANDS];
typedef FLOAT      FBLK[BLKSIZE];
typedef FLOAT      FHBLK[HBLKSIZE];
typedef FLOAT      F2HBLK[2][HBLKSIZE];
typedef FLOAT      F22HBLK[2][2][HBLKSIZE];
typedef double     DCB[CBANDS];

/***********************************************************************
*
*  Global Tables External Declarations
*
***********************************************************************/

extern double AnaWin[HAN_SIZE];
extern double AbsThr[3][HBLKSIZE];

extern int CritBand_1CB0[];
extern int CritBand_1CB1[];
extern int CritBand_1CB2[];
extern int CritBand_2CB0[];
extern int CritBand_2CB1[];
extern int CritBand_2CB2[];

extern double AbsThr_1TH0[][3];
extern double AbsThr_1TH1[][3];
extern double AbsThr_1TH2[][3];
extern double AbsThr_2TH0[][3];
extern double AbsThr_2TH1[][3];
extern double AbsThr_2TH2[][3];


/***********************************************************************
*
*  Encoder Function Prototype Declarations
*
***********************************************************************/

/* The following functions are in the file "encode.c" */

//extern unsigned long    read_samples(FILE*, short[2304], unsigned long, unsigned long);
//extern unsigned long    get_audio(FILE*, short[2][1152], unsigned long, int, int);
//extern void   read_ana_window(double[HAN_SIZE]);
extern void   window_subband(double**, double[HAN_SIZE], int);
extern void   create_ana_filter(double[SBLIMIT][64]);
extern void   filter_subband(double[HAN_SIZE], double[SBLIMIT]);
//extern void   encode_info(frame_params*, Bit_stream_struc*);
extern double mod(double);
/*
extern void   I_combine_LR(double[2][3][SCALE_BLOCK][SBLIMIT],
                           double[3][SCALE_BLOCK][SBLIMIT]);
extern void   II_combine_LR(double[2][3][SCALE_BLOCK][SBLIMIT],
                           double[3][SCALE_BLOCK][SBLIMIT], int);
*/
extern void   I_scale_factor_calc(double[][3][SCALE_BLOCK][SBLIMIT],
                           unsigned int[][3][SBLIMIT], int);
extern void   II_scale_factor_calc(double[][3][SCALE_BLOCK][SBLIMIT],
                           unsigned int[][3][SBLIMIT], int, int);
extern void   pick_scale(unsigned int[2][3][SBLIMIT], frame_params*,
                           double[2][SBLIMIT]);
extern void   put_scale(unsigned int[2][3][SBLIMIT], frame_params*,
                           double[2][SBLIMIT]);
/*
extern void   II_transmission_pattern(unsigned int[2][3][SBLIMIT],
                           unsigned int[2][SBLIMIT], frame_params*);
extern void   II_encode_scale(unsigned int[2][SBLIMIT],
                           unsigned int[2][SBLIMIT],
                           unsigned int[2][3][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern void   I_encode_scale(unsigned int[2][3][SBLIMIT],
                           unsigned int[2][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern int    II_bits_for_nonoise(double[2][SBLIMIT], unsigned int[2][SBLIMIT],
                           frame_params*);
extern void   II_main_bit_allocation(double[2][SBLIMIT],
                           unsigned int[2][SBLIMIT], unsigned int[2][SBLIMIT],
                           int*, frame_params*);
extern int    II_a_bit_allocation(double[2][SBLIMIT], unsigned int[2][SBLIMIT],
                           unsigned int[2][SBLIMIT], int*, frame_params*);
extern int    I_bits_for_nonoise(double[2][SBLIMIT], frame_params*);
extern void   I_main_bit_allocation(double[2][SBLIMIT],
                           unsigned int[2][SBLIMIT], int*, frame_params*);
extern int    I_a_bit_allocation(double[2][SBLIMIT], unsigned int[2][SBLIMIT],
                           int*, frame_params*);
extern void   I_subband_quantization(unsigned int[2][3][SBLIMIT],
                           double[2][3][SCALE_BLOCK][SBLIMIT], unsigned int[3][SBLIMIT],
                           double[3][SCALE_BLOCK][SBLIMIT], unsigned int[2][SBLIMIT],
                           unsigned int[2][3][SCALE_BLOCK][SBLIMIT], frame_params*);
extern void   II_subband_quantization(unsigned int[2][3][SBLIMIT],
                           double[2][3][SCALE_BLOCK][SBLIMIT], unsigned int[3][SBLIMIT],
                           double[3][SCALE_BLOCK][SBLIMIT], unsigned int[2][SBLIMIT],
                           unsigned int[2][3][SCALE_BLOCK][SBLIMIT], frame_params*);
extern void   II_encode_bit_alloc(unsigned int[2][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern void   I_encode_bit_alloc(unsigned int[2][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern void   I_sample_encoding(unsigned int[2][3][SCALE_BLOCK][SBLIMIT],
                           unsigned int[2][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern void   II_sample_encoding(unsigned int[2][3][SCALE_BLOCK][SBLIMIT],
                           unsigned int[2][SBLIMIT], frame_params*,
                           Bit_stream_struc*);
extern void   encode_CRC(unsigned int, Bit_stream_struc*);
*/

/*
extern void   create_syn_filter(double[64][SBLIMIT]);
extern int    SubBandSynthesis (double*, int, short*);
extern void   read_syn_window(double[HAN_SIZE]);
extern void   window_sample(double*, double*);
*/

/* The following functions are in the file "tonal.c" */

extern void        read_cbound(int, int);
extern void        read_freq_band(g_ptr*, int, int);
extern void        make_map(mask[HAN_SIZE], g_thres*);
extern double      add_db(double, double);
extern void        II_f_f_t(double[FFT_SIZE], mask[HAN_SIZE]);
extern void        II_hann_win(double[FFT_SIZE]);
extern void        II_pick_max(mask[HAN_SIZE], double[SBLIMIT]);
extern void        II_tonal_label(mask[HAN_SIZE], int*);
extern void        noise_label(mask*, int*, g_thres*);
extern void        subsampling(mask[HAN_SIZE], g_thres*, int*, int*);
extern void        threshold(mask[HAN_SIZE], g_thres*, int*, int*, int);
extern void        II_minimum_mask(g_thres*, double[SBLIMIT], int);
extern void        II_smr(double[SBLIMIT], double[SBLIMIT], double[SBLIMIT],
                           int);
extern void        II_Psycho_One(short[2][1152], double[2][SBLIMIT],
                           double[2][SBLIMIT], frame_params*);
extern void        I_f_f_t(double[FFT_SIZE/2], mask[HAN_SIZE/2]);
extern void        I_hann_win(double[FFT_SIZE/2]);
extern void        I_pick_max(mask[HAN_SIZE/2], double[SBLIMIT]);
extern void        I_tonal_label(mask[HAN_SIZE/2], int*);
extern void        I_minimum_mask(g_thres*, double[SBLIMIT]);
extern void        I_smr(double[SBLIMIT], double[SBLIMIT], double[SBLIMIT]);
extern void        I_Psycho_One(double[2][1152], double[2][SBLIMIT],
                           double[2][SBLIMIT], frame_params*);


/* The following functions are in the file "psy.c" */

extern void        psycho_anal(short int*, short int[1056], int, int,
                           FLOAT[32], double);


/* The following functions are in the file "subs.c" */

extern void        fft(FLOAT[BLKSIZE], FLOAT[BLKSIZE], FLOAT[BLKSIZE],
                           FLOAT[BLKSIZE], int );


/* The following functions are in the file "SMR.c" */
void smr_calc(double buffer[2][1152], frame_params *fr_ps, int model, SBS *sb_sample, double SMRsb[2][SBLIMIT]);
//void Printf(double a);
