/**********************************************************************
 * ISO MPEG Audio Subgroup Software Simulation Group (1991-1996)
 * ISO 11172-3 MPEG-1 Audio Codec
 * Revision 4.4 March 1996
 *
 * encode.c
 **********************************************************************/
/**********************************************************************
 *   changes made since last update:                                  *
 *   date   programmers         comment                               *
 * 3/01/91  Douglas Wong,       start of version 1.1 records          *
 *          Davis Pan                                                 *
 * 3/06/91  Douglas Wong        rename: setup.h to endef.h            *
 *                                      efilter to enfilter           *
 *                                      ewindow to enwindow           *
 *                              integrated "quantizer", "scalefactor",*
 *                              and "transmission" files              *
 *                              update routine "window_subband"       *
 * 3/31/91  Bill Aspromonte     replaced read_filter by               *
 *                              create_an_filter                      *
 * 5/10/91  W. Joseph Carter    Ported to Macintosh and Unix.         *
 *                              Incorporated Jean-Georges Fritsch's   *
 *                              "bitstream.c" package.                *
 *                              Incorporated Bill Aspromonte's        *
 *                              filterbank coefficient matrix         *
 *                              calculation routines and added        *
 *                              roundoff to coincide with specs.      *
 *                              Modified to strictly adhere to        *
 *                              encoded bitstream specs, including    *
 *                              "Berlin changes".                     *
 *                              Modified PCM sound file handling to   *
 *                              process all incoming samples and fill *
 *                              out last encoded frame with zeros     *
 *                              (silence) if needed.                  *
 *                              Located and fixed numerous software   *
 *                              bugs and table data errors.           *
 * 19jun91  dpwe (Aware)        moved "alloc_*" reader to common.c    *
 *                              Globals sblimit, alloc replaced by new*
 *                              struct 'frame_params' passed as arg.  *
 *                              Added JOINT STEREO coding, layers I,II*
 *                              Affects: *_bit_allocation,            *
 *                              subband_quantization, encode_bit_alloc*
 *                              sample_encoding                       *
 * 6/10/91  Earle Jennings      modified II_subband_quantization to   *
 *                              resolve type cast problem for MS_DOS  *
 * 6/11/91  Earle Jennings      modified to avoid overflow on MS_DOS  *
 *                              in routine filter_subband             *
 * 7/10/91  Earle Jennings      port to MsDos from MacIntosh version  *
 * 8/ 8/91  Jens Spille         Change for MS-C6.00                   *
 *10/ 1/91  S.I. Sudharsanan,   Ported to IBM AIX platform.           *
 *          Don H. Lee,                                               *
 *          Peter W. Farrett                                          *
 *10/ 3/91  Don H. Lee          implemented CRC-16 error protection   *
 *                              newly introduced function encode_CRC  *
 *11/ 8/91  Kathy Wang          Documentation of code                 *
 *                              All variablenames are referred to     *
 *                              with surrounding pound (#) signs      *
 * 2/11/92  W. Joseph Carter    Ported new code to Macintosh.  Most   *
 *                              important fixes involved changing     *
 *                              16-bit ints to long or unsigned in    *
 *                              bit alloc routines for quant of 65535 *
 *                              and passing proper function args.     *
 *                              Removed "Other Joint Stereo" option   *
 *                              and made bitrate be total channel     *
 *                              bitrate, irrespective of the mode.    *
 *                              Fixed many small bugs & reorganized.  *
 * 6/16/92  Shaun Astarabadi    Changed I_scale_factor_calc() and     *
 *                              II_scale_factor_calc() to use scale   *
 *                              factor 0 thru 62 only and not to      *
 *                              encode index 63 into the bit stream.  *
 * 7/27/92  Mike Li             (re-)Port to MS-DOS                   *
 * 9/22/92  jddevine@aware.com  Fixed _scale_factor_calc() defs       *
 * 3/31/93  Giogio Dimino       changed II_a_bit_allocation() from:   *
 *                              if( ad > ...) to if(ad >= ...)        *
 * 8/05/93  TEST                changed I_a_bit_allocation() from:    *
 *                              if( ad > ...) to if(ad >= ...)        *
 **********************************************************************/
 
#include "common.h"
#include "encoder.h"

//#ifdef MS_DOS
//extern unsigned _stklen = 16384;
//#endif
extern FILE *fptest;

/*=======================================================================\
|                                                                       |
| This segment contains all the core routines of the encoder,           |
| except for the psychoacoustic models.                                 |
|                                                                       |
| The user can select either one of the two psychoacoustic              |
| models. Model I is a simple tonal and noise masking threshold         |
| generator, and Model II is a more sophisticated cochlear masking      |
| threshold generator. Model I is recommended for lower complexity      |
| applications whereas Model II gives better subjective quality at low  |
| bit rates.                                                            |
|                                                                       |
| Layers I and II of mono, stereo, and joint stereo modes are supported.|
| Routines associated with a given layer are prefixed by "I_" for layer |
| 1 and "II_" for layer 2.                                              |
\=======================================================================*/
 
/************************************************************************/
/*
/* read_samples()
/*
/* PURPOSE:  reads the PCM samples from a file to the buffer
/*
/*  SEMANTICS:
/* Reads #samples_read# number of shorts from #musicin# filepointer
/* into #sample_buffer[]#.  Returns the number of samples read.
/*
/************************************************************************/
/*
unsigned long read_samples(musicin, sample_buffer, num_samples, frame_size)
FILE *musicin;
short sample_buffer[2304];
unsigned long num_samples, frame_size;
{
    unsigned long samples_read;
    static unsigned long samples_to_read;
    static char init = 1;

    if (init) {
        samples_to_read = num_samples;
        init = 0;
    }
    if (samples_to_read >= frame_size)
        samples_read = frame_size;
    else
        samples_read = samples_to_read;
    if ((samples_read =
         fread(sample_buffer, sizeof(short), (int)samples_read, musicin)) == 0)
        printf("Hit end of audio data\n");
    samples_to_read -= samples_read;
    if (samples_read < frame_size && samples_read > 0) {
        printf("Insufficient PCM input for one frame - fillout with zeros\n");
        for (; samples_read < frame_size; sample_buffer[samples_read++] = 0);
        samples_to_read = 0;
    }
    return(samples_read);
}
*/
/************************************************************************/
/*
/* get_audio()
/*
/* PURPOSE:  reads a frame of audio data from a file to the buffer,
/*   aligns the data for future processing, and separates the
/*   left and right channels
/*
/*  SEMANTICS:
/* Calls read_samples() to read a frame of audio data from filepointer
/* #musicin# to #insampl[]#.  The data is shifted to make sure the data
/* is centered for the 1024pt window to be used by the psychoacoustic model,
/* and to compensate for the 256 sample delay from the filter bank. For
/* stereo, the channels are also demultiplexed into #buffer[0][]# and
/* #buffer[1][]#
/*
/************************************************************************/
/*
unsigned long get_audio(musicin, buffer, num_samples, stereo, lay)
FILE *musicin;
short FAR buffer[2][1152];
unsigned long num_samples;
int stereo, lay;
{
   int j;
   short insamp[2304];
   unsigned long samples_read;
 
   if (lay == 1){
      if(stereo == 2){ // layer 1, stereo
         samples_read = read_samples(musicin, insamp, num_samples,
                                     (unsigned long) 768);
         for(j=0;j<448;j++) {
            if(j<64) {
               buffer[0][j] = buffer[0][j+384];
               buffer[1][j] = buffer[1][j+384];
            }
            else {
               buffer[0][j] = insamp[2*j-128];
               buffer[1][j] = insamp[2*j-127];
            }
         }
      }
      else { // layer 1, mono 
         samples_read = read_samples(musicin, insamp, num_samples,
                                     (unsigned long) 384);
         for(j=0;j<448;j++){
            if(j<64) {
               buffer[0][j] = buffer[0][j+384];
               buffer[1][j] = 0;
            }
            else {
               buffer[0][j] = insamp[j-64];
               buffer[1][j] = 0;
            }
         }
      }
   }
   else {
      if(stereo == 2){ // layer 2 (or 3), stereo 
         samples_read = read_samples(musicin, insamp, num_samples,
                                     (unsigned long) 2304);
         for(j=0;j<1152;j++) {
            buffer[0][j] = insamp[2*j];
            buffer[1][j] = insamp[2*j+1];
         }
      }
      else { // layer 2 (or 3), mono 
         samples_read = read_samples(musicin, insamp, num_samples,
                                     (unsigned long) 1152);
         for(j=0;j<1152;j++){
            buffer[0][j] = insamp[j];
            buffer[1][j] = 0;
         }
      }
   }
   return(samples_read);
}
 */
/************************************************************************/
/*
/* read_ana_window()
/*
/* PURPOSE:  Reads encoder window file "enwindow" into array #ana_win#
/*
/************************************************************************/
/*
void read_ana_window(ana_win)
double FAR ana_win[HAN_SIZE];
{
    int i,j[4];
    FILE *fp;
    double f[4];
    char t[150];
 
		//FILE *ofp;
		//ofp = fopen("anawindow.txt", "wt");

    if (!(fp = OpenTableFile("enwindow") ) ) {
       printf("Please check analysis window table 'enwindow'\n");
       exit(1);
    }
    for (i=0;i<512;i+=4) {
       fgets(t, 150, fp);
       sscanf(t,"C[%d] = %lf C[%d] = %lf C[%d] = %lf C[%d] = %lf\n",
              j, f,j+1,f+1,j+2,f+2,j+3,f+3);
       if (i==j[0]) {
          ana_win[i] = f[0];
          ana_win[i+1] = f[1];
          ana_win[i+2] = f[2];
          ana_win[i+3] = f[3];
       }
       else {
          printf("Check index in analysis window table\n");
          exit(1);
       }
       fgets(t,150,fp);
    }
    fclose(fp);

		//for (i=0;i<512;i++) fprintf(ofp, "%.9f\n", ana_win[i]);
		//fclose(ofp);
}
*/

/************************************************************************/
/*
/* window_subband()
/*
/* PURPOSE:  Overlapping window on PCM samples
/*
/* SEMANTICS:
/* 32 16-bit pcm samples are scaled to fractional 2's complement and
/* concatenated to the end of the window buffer #x#. The updated window
/* buffer #x# is then windowed by the analysis window #c# to produce the
/* windowed sample #z#
/*
/************************************************************************/

 //extern FILE *fpana;
void window_subband(buffer, z, k)
//short FAR **buffer;
double FAR **buffer;
double FAR z[HAN_SIZE];
int k;
{	
	typedef double  XX[2][HAN_SIZE];
    static XX  *x;
    int i, j;
    static off[2] = {0,0};
    static char init = 0;
    //static double FAR *c;
 // FILE *fpana;
	
//	fpana=fopen("test/anawin.txt", "wt");

    if (!init) {
        //c = (double FAR *) mem_alloc(sizeof(double) * HAN_SIZE, "window");
        //read_ana_window(c);
				
			
			/*	for (i=0;i<HAN_SIZE/4;i++)	// generate table
					fprintf(fp, "%.9f, %.9f, %.9f, %.9f,\n", c[4*i],c[4*i+1],c[4*i+2],c[4*i+3]);
				fclose(fp);
				*/
        x =mem_alloc(sizeof(XX),"x");
        for (i=0;i<2;i++)
            for (j=0;j<HAN_SIZE;j++)
                (*x)[i][j] = 0;
        init = 1;
    }

    /* replace 32 oldest samples with 32 new samples */
    for (i=0;i<32;i++) 
	{
		(*x)[k][31-i+off[k]] = (double) *(*buffer)++;///SCALE; //32 bitwide shift register for input PCM  

		//	fprintf(fpana,"%d\n",31-i+off[k]);
	}
    /* shift samples into proper window positions */
    for (i=0;i<HAN_SIZE;i++) {
			//z[i] = (*x)[k][(i+off[k])&HAN_SIZE-1] * c[i];
			z[i] = (*x)[k][(i+off[k])&HAN_SIZE-1] * AnaWin[i]; //32 PCMS for filter filter coffi =512

			//	fprintf(fpana,"%d\n",(i+off[k])&HAN_SIZE-1 );
		
		}

//	fflush(fpana);

 
    off[k] += 480;              /*offset is modulo (HAN_SIZE-1)*/
    off[k] &= HAN_SIZE-1;
//	fprintf(fpana,"%d\n", off[k] );

//	fflush(fpana);
}
 
/************************************************************************/
/*
/* create_ana_filter()
/*
/* PURPOSE:  Calculates the analysis filter bank coefficients
/*
/* SEMANTICS:
/* Calculates the analysis filterbank coefficients and rounds to the
/* 9th decimal place accuracy of the filterbank tables in the ISO
/* document.  The coefficients are stored in #filter#
/*
/************************************************************************/
 
void create_ana_filter(filter)
double FAR filter[SBLIMIT][64];
{
   register int i,k;
 
	 //FILE *ofp;
	 //ofp = fopen("anafilter.txt", "wt");

   for (i=0; i<32; i++)
      for (k=0; k<64; k++) {
          if ((filter[i][k] = 1e9*cos((double)((2*i+1)*(16-k)*PI64))) >= 0)
             modf(filter[i][k]+0.5, &filter[i][k]);
          else
             modf(filter[i][k]-0.5, &filter[i][k]);
          filter[i][k] *= 1e-9;
					
					//fprintf(ofp, "%f\n", filter[i][k]);					
			}
		//fclose(ofp);
}

/************************************************************************/
/*
/* filter_subband()
/*
/* PURPOSE:  Calculates the analysis filter bank coefficients
/*
/* SEMANTICS:
/*      The windowed samples #z# is filtered by the digital filter matrix #m#
/* to produce the subband samples #s#. This done by first selectively
/* picking out values from the windowed samples, and then multiplying
/* them by the filter matrix, producing 32 subband samples.
/*
/************************************************************************/
//extern  FILE *fptest;
void filter_subband(z,s)
double FAR z[HAN_SIZE], s[SBLIMIT];
{
   	
	double y[64];
   int i,j;
static char init = 0;
   typedef double MM[SBLIMIT][64];
static MM FAR *m;
#ifdef MS_DOS
   long    SIZE_OF_MM;
   SIZE_OF_MM      = SBLIMIT*64;
   SIZE_OF_MM      *= 8;
   if (!init) {
       m = (MM FAR *) mem_alloc(SIZE_OF_MM, "filter");
       create_ana_filter(*m);
       init = 1;
   }
#else
   if (!init) {
       m = (MM FAR *) mem_alloc(sizeof(MM), "filter");
       create_ana_filter(*m);
       init = 1;
   }
#endif
   for (i=0;i<64;i++) for (j=0, y[i] = 0;j<8;j++) y[i] += z[i+64*j];
   for (i=0;i<SBLIMIT;i++)
   {
	   for (j=0, s[i]= 0;j<64;j++) s[i] +=(*m)[i][j] * y[j];
	   	
	 //  fprintf(fptest,"%f\n",s[i]);
   }

  
//fflush(fptest);	   	
							
							
}


/*****************************************************************
/*
/* The following are the subband synthesis routines. They apply
/* to both layer I and layer II stereo or mono. The user has to
/* decide what parameters are to be passed to the routines.
/*
/***************************************************************/

/*************************************************************
/*
/*   Pass the subband sample through the synthesis window
/*
/**************************************************************/

/* create in synthesis filter */
/*
void create_syn_filter(filter)
double FAR filter[64][SBLIMIT];
{
    register int i,k;

		//FILE *ofp;
		//ofp = fopen("synfilter.txt", "wt");

    for (i=0; i<64; i++)
        for (k=0; k<32; k++) {
            if ((filter[i][k] = 1e9*cos((double)((PI64*i+PI4)*(2*k+1)))) >= 0)
                modf(filter[i][k]+0.5, &filter[i][k]);
            else
                modf(filter[i][k]-0.5, &filter[i][k]);
            filter[i][k] *= 1e-9;
						//fprintf(ofp, "%f\n", filter[i][k]);
        }
		//fclose(ofp);
}
*/
/***************************************************************
/*
/*   Window the restored sample
/*
/***************************************************************/

/* read in synthesis window */
/*
void read_syn_window(window)
double FAR window[HAN_SIZE];
{
    int i,j[4];
    FILE *fp;
    double f[4];
    char t[150];
		
		//FILE *ofp;
		//ofp = fopen("synwindow.txt", "wt");

    if (!(fp = OpenTableFile("dewindow") )) {
        printf("Please check synthesis window table 'dewindow'\n");
        exit(1);
    }
    for (i=0;i<512;i+=4) {
        fgets(t, 150, fp);
        sscanf(t,"D[%d] = %lf D[%d] = %lf D[%d] = %lf D[%d] = %lf\n",
               j, f,j+1,f+1,j+2,f+2,j+3,f+3);
        if (i==j[0]) {
            window[i] = f[0];
            window[i+1] = f[1];
            window[i+2] = f[2];
            window[i+3] = f[3];
        }
        else {
            printf("Check index in synthesis window table\n");
            exit(1);
        }
        fgets(t,150,fp);
    }
    fclose(fp);

		//for (i=0;i<512;i++)	fprintf(ofp, "%.9f\n", window[i]);
		//fclose(ofp);
}
*/
/*
int SubBandSynthesis (bandPtr, channel, samples)
double *bandPtr;
int channel;
short *samples;
{
    register int i,j,k;
    register double *bufOffsetPtr, sum;
    static int init = 1;
    typedef double NN[64][32];
    static NN FAR *filter;
    typedef double BB[2][2*HAN_SIZE];
    static BB FAR *buf;
    static int bufOffset[2] = {64,64};
    static double FAR *window;
    int clip = 0;               // count & return how many samples clipped

    if (init) {
        buf = (BB FAR *) mem_alloc(sizeof(BB),"BB");
        filter = (NN FAR *) mem_alloc(sizeof(NN), "NN");
        create_syn_filter(*filter);
        window = (double FAR *) mem_alloc(sizeof(double) * HAN_SIZE, "WIN");
        read_syn_window(window);
        init = 0;
    }
//    if (channel == 0)
    bufOffset[channel] = (bufOffset[channel] - 64) & 0x3ff;
    bufOffsetPtr = &((*buf)[channel][bufOffset[channel]]);

    for (i=0; i<64; i++) {
        sum = 0;
        for (k=0; k<32; k++)
            sum += bandPtr[k] * (*filter)[i][k];
        bufOffsetPtr[i] = sum;
    }
    //  S(i,j) = D(j+32i) * U(j+32i+((i+1)>>1)*64)
    //  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)
    for (j=0; j<32; j++) {
        sum = 0;
        for (i=0; i<16; i++) {
            k = j + (i<<5);
            sum += window[k] * (*buf) [channel] [( (k + ( ((i+1)>>1) <<6) ) +
                                                  bufOffset[channel]) & 0x3ff];
        }

//   {long foo = (sum > 0) ? sum * SCALE + 0.5 : sum * SCALE - 0.5;
     {long foo = sum * SCALE;
     if (foo >= (long) SCALE)      {samples[j] = SCALE-1; ++clip;}
     else if (foo < (long) -SCALE) {samples[j] = -SCALE;  ++clip;}
     else                           samples[j] = foo;
 }
    }
    return(clip);
}
*/

/************************************************************************/
/*
/* mod()
/*
/* PURPOSE:  Returns the absolute value of its argument
/*
/************************************************************************/
 
double mod(a)
double a;
{
    return (a > 0) ? a : -a;
}
 

/************************************************************************
/*
/* I_scale_factor_calc     (Layer I)
/* II_scale_factor_calc    (Layer II)
/*
/* PURPOSE:For each subband, calculate the scale factor for each set
/* of the 12 subband samples
/*
/* SEMANTICS:  Pick the scalefactor #multiple[]# just larger than the
/* absolute value of the peak subband sample of 12 samples,
/* and store the corresponding scalefactor index in #scalar#.
/*
/* Layer II has three sets of 12-subband samples for a given
/* subband.
/*
/************************************************************************/
 
void I_scale_factor_calc(sb_sample,scalar,stereo)
double FAR sb_sample[][3][SCALE_BLOCK][SBLIMIT];
unsigned int scalar[][3][SBLIMIT];
int stereo;
{
   int i,j, k;
   double s[SBLIMIT];
 
   for (k=0;k<stereo;k++) {
     for (i=0;i<SBLIMIT;i++)
       for (j=1, s[i] = mod(sb_sample[k][0][0][i]);j<SCALE_BLOCK;j++)
         if (mod(sb_sample[k][0][j][i]) > s[i])
            s[i] = mod(sb_sample[k][0][j][i]);
 
     for (i=0;i<SBLIMIT;i++)
       for (j=SCALE_RANGE-2,scalar[k][0][i]=0;j>=0;j--) /* $A 6/16/92 */
         if (s[i] <= multiple[j]) {
            scalar[k][0][i] = j;
            break;
         }
   }
}

/******************************** Layer II ******************************/
 
void II_scale_factor_calc(sb_sample,scalar,stereo,sblimit)
double FAR sb_sample[][3][SCALE_BLOCK][SBLIMIT];
unsigned int scalar[][3][SBLIMIT];
int stereo,sblimit;
{
  int i,j, k,t;
  double s[SBLIMIT];
 
  for (k=0;k<stereo;k++) for (t=0;t<3;t++) {
    for (i=0;i<sblimit;i++)
      for (j=1, s[i] = mod(sb_sample[k][t][0][i]);j<SCALE_BLOCK;j++)
        if (mod(sb_sample[k][t][j][i]) > s[i])
             s[i] = mod(sb_sample[k][t][j][i]);
 
  for (i=0;i<sblimit;i++)
    for (j=SCALE_RANGE-2,scalar[k][t][i]=0;j>=0;j--)    /* $A 6/16/92 */
      if (s[i] <= multiple[j]) {
         scalar[k][t][i] = j;
         break;
      }
      for (i=sblimit;i<SBLIMIT;i++) scalar[k][t][i] = SCALE_RANGE-1;
    }
}

/************************************************************************
/*
/* pick_scale  (Layer II)
/*
/* PURPOSE:For each subband, puts the smallest scalefactor of the 3
/* associated with a frame into #max_sc#.  This is used
/* used by Psychoacoustic Model I.
/* (I would recommend changin max_sc to min_sc)
/*
/************************************************************************/
 
void pick_scale(scalar, fr_ps, max_sc)
unsigned int scalar[2][3][SBLIMIT];
frame_params *fr_ps;
double FAR max_sc[2][SBLIMIT];
{
  int i,j,k,max;
  int stereo  = fr_ps->stereo;
  int sblimit = fr_ps->sblimit;
 
  for (k=0;k<stereo;k++)
    for (i=0;i<sblimit;max_sc[k][i] = multiple[max],i++)
      for (j=1, max = scalar[k][0][i];j<3;j++)
         if (max > scalar[k][j][i]) max = scalar[k][j][i];
  for (i=sblimit;i<SBLIMIT;i++) max_sc[0][i] = max_sc[1][i] = 1E-20;
}

/************************************************************************
/*
/* put_scale   (Layer I)
/*
/* PURPOSE:Sets #max_sc# to the scalefactor index in #scalar.
/* This is used by Psychoacoustic Model I
/*
/************************************************************************/
 
void put_scale(scalar, fr_ps, max_sc)
unsigned int scalar[2][3][SBLIMIT];
frame_params *fr_ps;
double FAR max_sc[2][SBLIMIT];
{
   int i,k;
   int stereo  = fr_ps->stereo;
   int sblimit = fr_ps->sblimit;
 
   for (k=0;k<stereo;k++) for (i=0;i<SBLIMIT;i++)
        max_sc[k][i] = multiple[scalar[k][0][i]];
}
 

 
