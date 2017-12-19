
/***********************************************************************
*
*  Global Conditional Compile Switches
*
***********************************************************************/

/* #define      UNIX            /* Unix conditional compile switch */
/* #define      MACINTOSH       /* Macintosh conditional compile switch */
/* #define      MS_DOS          /* IBM PC conditional compile switch */
/* #define      MSC60           /* Compiled for MS_DOS with MSC v6.0 */
/* #define      AIX             /* AIX conditional compile switch    */
/* #define      CONVEX          /* CONVEX conditional compile switch */




/* 
 * Don't define FAR to far unless you're willing to clean up the 
 * prototypes
 */
#define FAR /*far*/


/***********************************************************************
*
*  Global Include Files
*
***********************************************************************/

#include        <stdio.h>
#include        <string.h>
#include        <math.h>
#include        <stdlib.h>
//#include        <memory.h>


/***********************************************************************
*
*  Global Definitions
*
***********************************************************************/

/* General Definitions */

#define         FLOAT                   double

#define         FALSE                   0
#define         TRUE                    1
//#define         NULL_CHAR               '\0'

//#define         MAX_U_32_NUM            0xFFFFFFFF
#define         PI                      3.14159265358979
#define         PI4                     PI/4
#define         PI64                    PI/64
#define         LN_TO_LOG10             0.2302585093

/*
#define         VOL_REF_NUM             0
#define         MPEG_AUDIO_ID           1
#define         MAC_WINDOW_SIZE         24

#define         MONO                    1
#define         STEREO                  2

#define         BITS_IN_A_BYTE          8
#define         WORD                    16
*/
#define         MAX_NAME_SIZE           81

#define         SBLIMIT                 32
//#define         SSLIMIT                 18
#define         FFT_SIZE                1024
#define         HAN_SIZE                512
#define         SCALE_BLOCK             12
#define         SCALE_RANGE             64
#define         SCALE                   32768
//#define         CRC16_POLYNOMIAL        0x8005


/***********************************************************************
*
*  Global Type Definitions
*
***********************************************************************/

/* Structure for Reading Layer II Allocation Tables from File */

typedef struct {
    unsigned int    steps;
    unsigned int    bits;
    unsigned int    group;
    unsigned int    quant;
} sb_alloc, *alloc_ptr;

typedef sb_alloc        al_table[SBLIMIT][16];

/* Header Information Structure */

typedef struct {
    //int version;
    int lay;
    //int error_protection;
    int bitrate_index;
    int sampling_frequency;
    //int padding;
    //int extension;
    //int mode;
    //int mode_ext;
    //int copyright;
    //int original;
    //int emphasis;
} layer, *the_layer;

/* Parent Structure Interpreting some Frame Parameters in Header */

typedef struct {
    layer       *header;        /* raw header information */
    //int         actual_mode;    /* when writing IS, may forget if 0 chs */
    //al_table    *alloc;         /* bit allocation table read in */
    //int         tab_num;        /* number of table as loaded */
    int         stereo;         /* 1 for mono, 2 for stereo */
    //int         jsbound;        /* first band of joint stereo coding */
    int         sblimit;        /* total number of sub bands */
} frame_params;




/***********************************************************************
*
*  Global Variable External Declarations
*
***********************************************************************/

extern char     *mode_names[4];
extern char     *layer_names[3];
extern double   s_freq[4];
extern int      bitrate[3][15];
extern double FAR multiple[64];


/***********************************************************************
*
*  Global Function Prototype Declarations
*
***********************************************************************/

/* The following functions are in the file "common.c" */

//extern FILE           *OpenTableFile(char*);
//extern int            read_bit_alloc(int, al_table*);
extern int            pick_table(frame_params*);
//extern int            js_bound(int, int);
//extern void           hdr_to_frps(frame_params*);

extern void           WriteHdr(frame_params*, FILE*);
/*
extern void           WriteBitAlloc(unsigned int[2][SBLIMIT], frame_params*,
                        FILE*);
extern void           WriteScale(unsigned int[2][SBLIMIT],
                        unsigned int[2][SBLIMIT], unsigned int[2][3][SBLIMIT],
                        frame_params*, FILE*);
extern void           WriteSamples(int, unsigned int FAR [SBLIMIT],
                        unsigned int[SBLIMIT], frame_params*, FILE*);
extern int            NumericQ(char*);
*/
extern int            BitrateIndex(int layer, int bitrate);
extern int            SmpFrqIndex(long fs);
//extern int            memcheck(char*, int, int);
extern void           FAR *mem_alloc(unsigned long, char*);
extern void           mem_free(void**);
//extern void           double_to_extended(double*, char[10]);
//extern void           extended_to_double(char[10], double*);
//extern int            aiff_read_headers(FILE*, IFF_AIFF*);
//extern int            aiff_seek_to_sound_data(FILE*);
//extern int            aiff_write_headers(FILE*, IFF_AIFF*);
/*
extern int            refill_buffer(Bit_stream_struc*);
extern void           empty_buffer(Bit_stream_struc*, int);
extern void           open_bit_stream_w(Bit_stream_struc*, char*, int);
extern void           open_bit_stream_r(Bit_stream_struc*, char*, int);
extern void           close_bit_stream_r(Bit_stream_struc*);
extern void           close_bit_stream_w(Bit_stream_struc*);
extern void           alloc_buffer(Bit_stream_struc*, int);
extern void           desalloc_buffer(Bit_stream_struc*);
extern void           back_track_buffer(Bit_stream_struc*, int);
extern unsigned int   get1bit(Bit_stream_struc*);
extern void           put1bit(Bit_stream_struc*, int);
extern unsigned long  look_ahead(Bit_stream_struc*, int);
extern unsigned long  getbits(Bit_stream_struc*, int);
extern void           putbits(Bit_stream_struc*, unsigned int, int);
extern void           byte_ali_putbits(Bit_stream_struc*, unsigned int, int);
extern unsigned long  byte_ali_getbits(Bit_stream_struc*, int);
extern unsigned long  sstell(Bit_stream_struc*);
extern int            end_bs(Bit_stream_struc*);
extern int            seek_sync(Bit_stream_struc*, long, int);
extern void           I_CRC_calc(frame_params*, unsigned int[2][SBLIMIT],
                        unsigned int*);
extern void           II_CRC_calc(frame_params*, unsigned int[2][SBLIMIT],
                        unsigned int[2][SBLIMIT], unsigned int*);
extern void           update_CRC(unsigned int, unsigned int, unsigned int*);
extern unsigned int   hget1bit(); //* MI
extern unsigned long  hgetbits(int);
extern unsigned long  hsstell();
extern void           hputbuf(unsigned int,int);
*/

//extern void           read_absthr(FLOAT*, int);
