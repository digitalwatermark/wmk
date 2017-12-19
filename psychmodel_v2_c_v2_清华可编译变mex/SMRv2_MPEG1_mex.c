// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 
// Psychoacoustic Model in MPEG-1 v2, written in MEX
// Peng Zhang,  Tsinghua Univ,  2010-03-05
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 
// modified from MPEG-1 ISO/IEC 11172-5, Software Simulation, audio part, 1998
// see also: SMR_MPEG1_mex.cpp
// Syntax: 
// [SMRsb, sb_sample] = SMRv2_MPEG1_mex(buffer, fs, bitrate, layer, model);
// buffer: buffered audio samples, two columns for stereo input
// fs: sampling frequency in Hz
// bitrate: bit rate in kbps
// layer: 1, 2, 3 for MPEG-I Layer I, Layer II, Layer III, respectively; Layer III not supported
// model: psychoacoustic model 1 or 2
// SMRsb: Signal-to-Mask Ratio in dB for 32 subbands, two columns for stereo input
// sb_sample: 384 (Layer I) or 384*3 (Layer II, III) subband samples, two columns for stereo input
// Usage:
// Segment the audio signal and load the samples to buffer according to the layer
/* Buffering method (matlab):
if layer==1
    Lseg = 384;
else
    Lseg = 384*3;
end
Nseg = ceil(length(x)/Lseg);
x = [x; zeros(Lseg*Nseg-length(x), size(x, 2))];
buffer = zeros(384*3, size(x,2));
offset = 0;
clear SMRv2_MPEG1_mex       % clear internal static variables for a new processing
for nn=1:Nseg
    if layer==1
        buffer(1:64,:) = buffer(385:448, :);
        buffer(65:448, :) = x(offset+1:offset+384, :);
    else
        buffer = x(offset+1:offset+384*3, :);
    end
    [SMRsb, sb_sample] = SMRv2_MPEG1_mex(buffer, fs, bitrate, layer, model);
    % other processing
    offset = offset+Lseg;
end
*/

// Notes:
// 1. Value of input audio samples must be in the range [-1, 1)
// 2. Use "clear SMRv2_MPEG1_mex" to clean up the mex function and all persistent variables 
// from memory, and reinitialize all subroutins at the next call; otherwise, two successive calls
// are dependent. But DONOT clear frequently as the memory allocated for static variables using malloc()
// cannot be freed until Matlab quits.
// 3. printf() used in C subroutines except in mexFunction() are invaild
// 4. If a no-prompt termination of Matlab occurs, check and disable all exit() commands in C subroutines
// 5. Some data types are different between different compliers, and the final results may slightly vary
// e.g., double precision will bring in about 1e-15 calculation errors between different compliers,
// and these errors may enlarge in the final results when some non-linear operations such as (int) 
// are performed.

// Revision:
// 2010-03-08: all tables are defined as global arrays to avoid no-prompt termination of Matlab 
//                        when the table files can not be found (file missed or current directory not the one 
//                        containing these table files)
// 2010-03-10: fix the output variations caused by double precision difference between 
//                       CEX (C executable) and MEX (Matlab executable)

// References:
// [1] Information technology -- Coding of moving pictures and associated
//      audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
//      British standard. BSI, London. October 1993. Implementation of ISO/IEC
//      11172-3:1993. BSI, London. First edition 1993-08-01.

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 

#include <string.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"

#include "common.h"
#include "encoder.h"
#define FLOAT_TO_SHORT 32768

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //         
void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{
  //short buffer[2][1152]={0};
  double buffer[2][1152]={0};
  double *buffer_pt;
  long fs;
  int br;                       // DO NOT use 'bitrate' (predefined externally)
  int lay;                      // DO NOT use 'layer' (predefined externally)
  int model;
  int stereo;
  
  static frame_params fr_ps;  // DO NOT use * as the pointed structure has not been allocated memory
  static layer info;
  static int oldmodel;
 
  double *SMRsb;
  SBS sb_sample;
  double *sb_sample_pt;

  unsigned long len_buff;
  int i, j, k, m;
  int br_idx, fs_idx;
  
  static int init = 0;

  fr_ps.header = &info;       // pointer must be initialized to an allocated memory !!!
  
  // mexEvalString("cd"); // return current directory, not module path
          
  if (nrhs<5)
      mexErrMsgTxt("Not enough input arguments.");
  
  // Assign pointers to each input
  buffer_pt = mxGetPr(prhs[0]);
  fs = (int) mxGetScalar(prhs[1]);
  br = (int) mxGetScalar(prhs[2]);
  lay = (int) mxGetScalar(prhs[3]);
  model = (int) mxGetScalar(prhs[4]);
  
  // Error check for input parameters
  if (lay!=1 && lay!=2 && lay!=3) 
      mexErrMsgTxt("Layer must be 1, 2 or 3.");
  if (lay==3) 
      mexErrMsgTxt("Layer III not supported in this version.");
  if (model!=1 && model!=2) 
      mexErrMsgTxt("Psychoacousitc model must be 1 or 2.");
  fs_idx = SmpFrqIndex(fs);
  br_idx = BitrateIndex(lay, br);
  if (fs_idx<0)             // see SmpFrqIndex()
      mexErrMsgTxt("Legal sampling rate should be 48000, 44100 or 32000.");
  if (br_idx<0)             // see BitrateIndex()
      mexErrMsgTxt("Illegal bit rate.");
  
  stereo = mxGetN(prhs[0]);             // 1 for mono, 2 for stereo
  if (stereo!=1 && stereo!=2)
       mexErrMsgTxt("Input data must have one or two columns.");
  len_buff = mxGetM(prhs[0]); 
  if ((lay==1 && len_buff<448) || (lay!=1 && len_buff<1152))
      mexErrMsgTxt("Input data must have at lease 448 (Layer 1) or 1152 (Layer 2, 3) samples per channel.");
  fr_ps.stereo = stereo;
  
  
  // Create matrix for the return argument
  plhs[0] = mxCreateDoubleMatrix(SBLIMIT, stereo, mxREAL);   //  (stereo, SBLIMIT) wrong
  if (lay==1)       // 12*32=384 subband samples for each channel
      plhs[1] = mxCreateDoubleMatrix(SCALE_BLOCK*SBLIMIT, stereo, mxREAL); 
  else                 // 3*384=1152 subband samples for each channel
      plhs[1] = mxCreateDoubleMatrix(3*SCALE_BLOCK*SBLIMIT, stereo, mxREAL); 
  // SBS: double [2][3][SCALE_BLOCK][SBLIMIT]

  // Assign pointers to each output  
  SMRsb = mxGetPr(plhs[0]);
  sb_sample_pt = mxGetPr(plhs[1]);

  
  // Automatically initialize when some input parameters change,
  // but subroutins called by this mexFunction cannot be initialized
  // Use clear <mex filename> in an m-function or script to clean up the mex function and 
  // all persistent variables from memory, and reinitialize all subroutins at the next call
  if (lay !=  fr_ps.header->lay || br_idx != fr_ps.header->bitrate_index 
            || fs_idx != fr_ps.header->sampling_frequency || model != oldmodel)
      init = 0;

  if (!init)
  {
      // Generate or update arguments for subfunctions
      fr_ps.header->lay = lay;
      fr_ps.header->bitrate_index = br_idx;
      fr_ps.header->sampling_frequency = fs_idx;
      oldmodel = model;
      if (lay == 2)     fr_ps.sblimit = pick_table(&fr_ps);
	  else                 fr_ps.sblimit = SBLIMIT;
      
      /*
      printf("layer=%d\n", fr_ps.header->lay);
      printf("br_idx=%d\n", fr_ps.header->bitrate_index);
      printf("fs_idx=%d\n", fr_ps.header->sampling_frequency);
      printf("stereo=%d\n", fr_ps.stereo);
      printf("sblimit=%d\n", fr_ps.sblimit);
      printf("model=%d\n", oldmodel);
      */
      
      init = 1;
  }

  // Convert [-1.0~1.0) double values to 16-bit short integers
  // DO NOT change *buffer_pt as the input mxArray is constant
  if (lay==1)
      for (i=0; i<stereo; i++)
          for (j=0; j<448; j++)
              buffer[i][j] = buffer_pt[i*len_buff+j];//(int) (buffer_pt[i*len_buff+j]*FLOAT_TO_SHORT);
  else
      for (i=0; i<stereo; i++)
          for (j=0; j<1152; j++)
              buffer[i][j] = buffer_pt[i*len_buff+j];//(int) (buffer_pt[i*len_buff+j]*FLOAT_TO_SHORT);
  
  
 smr_calc(buffer, &fr_ps, model, sb_sample, SMRsb);
 /*for(i=0;i<488;i++)
 {
	 mexPrintf("buffer=%lf\n",buffer[i]);
 }*/


  

  if (lay==1)
      for (i=0; i<stereo; i++)                              // chn0[0:383], chn1[0:383]
              for (k=0;k<SCALE_BLOCK;k++)  // sb0[0:11],sb2[0:11], ..., sb31[0:11]
                  for (m=0;m<SBLIMIT;m++) 							
                      sb_sample_pt[i*SCALE_BLOCK*SBLIMIT+k+m*SCALE_BLOCK]
                              = sb_sample[i][0][k][m];
  else
      for (i=0; i<stereo; i++)                              // chn0[0:1151], chn1[0:1151]
          for (j=0; j<3; j++)                                   // block0[0:383], block1[0:383], block2[0:383]
              for (k=0;k<SCALE_BLOCK;k++) 
                  for (m=0;m<SBLIMIT;m++) 	  	  // sb0[0:11],sb2[0:11], ..., sb31[0:11]
                      sb_sample_pt[i*3*SCALE_BLOCK*SBLIMIT+j*SCALE_BLOCK*SBLIMIT+k+m*SCALE_BLOCK]
                              = sb_sample[i][j][k][m];


}
