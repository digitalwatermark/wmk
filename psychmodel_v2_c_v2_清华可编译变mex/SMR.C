#include "common.h"
#include "encoder.h"
//**********************************************
//**** psycho analysis of buffered data  *******
//**********************************************

FILE *fptest;
//FILE * fpana;

//extern FILE *ltmintest;
void smr_calc(buffer, fr_ps, model, sb_sample, ltmin)
double buffer[2][1152];
frame_params *fr_ps;
int model;
SBS *sb_sample;
double ltmin[2][SBLIMIT];
{

	layer info = *(fr_ps->header);
	int   stereo = 1;//fr_ps->stereo;

	typedef double IN[2][HAN_SIZE];
    static IN   FAR        *win_que;
    static short FAR **win_buf;
	static double FAR **win_buf1;
	static unsigned int scalar[2][3][SBLIMIT];
	static double max_sc[2][SBLIMIT];
    static FLOAT snr32[32];
    static short sam[2][1056];
	
	int i,j,k;
	static char init = 0;

	FILE *ofp;

	if (!init) {			// allocated memory will not be released !!!!!
		win_que = (IN FAR *) mem_alloc(sizeof(IN), "Win_que");
		win_buf = (short FAR **) mem_alloc(sizeof(short *)*2, "win_buf");
			win_buf1 = (double FAR **) mem_alloc(sizeof(double *)*2, "win_buf1");
		
		memset((char *) scalar, 0, sizeof(scalar));
		memset((char *) max_sc, 0, sizeof(max_sc));
		memset((char *) snr32, 0, sizeof(snr32));
		memset((char *) sam, 0, sizeof(sam));

		init = 1;
	}			
    win_buf1[0] = &buffer[0][0];
    win_buf1[1] = &buffer[1][0];

	
   //fpana=fopen("test/anawin.txt", "wt");

      switch (info.lay) {
 
//***************************** Layer I **********************************
 
          case 1 :
			   for (k=0;k<stereo;k++)
							for (j=0;j<SCALE_BLOCK;j++)
							 {
									window_subband(&win_buf1[k], &(*win_que)[k][0], k);
									filter_subband(&(*win_que)[k][0], &(*sb_sample)[k][0][j][0]);//384*32 filter samples

							

							 }
						

             I_scale_factor_calc(*sb_sample, scalar, stereo);
 
             put_scale(scalar, fr_ps, max_sc);
						 /*
						 for (k=0;k<stereo;k++) for (i=0;i<SBLIMIT;i++)
								max_sc[k][i] = multiple[scalar[k][0][i]];
						 */
             if (model == 1)
			 {
				 I_Psycho_One(buffer, max_sc, ltmin, fr_ps);


  
			 }

             else {
                for (k=0;k<stereo;k++) {
                   psycho_anal(&buffer[k][0],&sam[k][0], k, info.lay, snr32,
                               (FLOAT)s_freq[info.sampling_frequency]*1000);
                   for (i=0;i<SBLIMIT;i++) ltmin[k][i] = (double) snr32[i];											 
                }
             }

          break;

//***************************** Layer 2 **********************************
 
          case 2 :
             for (i=0;i<3;i++) for (j=0;j<SCALE_BLOCK;j++)
							 for (k=0;k<stereo;k++) {
                   window_subband(&win_buf[k], &(*win_que)[k][0], k);
                   filter_subband(&(*win_que)[k][0], &(*sb_sample)[k][i][j][0]);
							 }
 
							II_scale_factor_calc(*sb_sample, scalar, stereo, fr_ps->sblimit);
						  pick_scale(scalar, fr_ps, max_sc);
 
              if (model == 1) II_Psycho_One(buffer, max_sc, ltmin, fr_ps);
              else {
                 for (k=0;k<stereo;k++) {
                    psycho_anal(&buffer[k][0],&sam[k][0], k, 
                                 info.lay, snr32,
                                 (FLOAT)s_freq[info.sampling_frequency]*1000);
                    for (i=0;i<SBLIMIT;i++) ltmin[k][i] = (double) snr32[i];
                   }
							}
              
          break;
 
//***************************** Layer 3 **********************************

          case 3 : break;

       }
}