
#include "common.h"
#include "encoder.h"
//#include <dos.h>
/* Global variable definitions for "musicin.c" */

FILE               *musicin;

//FILE  *ltmintest;


/* Implementations */


main(argc, argv)
int     argc;
char    **argv;
{
	//typedef double SBS[2][3][SCALE_BLOCK][SBLIMIT];
	FILE *musicout=fopen("test/musicout.dat","wb");
	FILE *music = fopen("fromvcmexmusic.txt","rb");
	SBS  FAR        *sb_sample;
	//typedef double IN[2][HAN_SIZE];
	//   IN   FAR        *win_que;
 
    frame_params fr_ps;
    layer info;
    char ifilename[MAX_NAME_SIZE];
	char ofilename[MAX_NAME_SIZE];
	FILE *ofp;

	static short FAR buffer[2][1152];

	static double buffer1[2][1152];
	static double FAR ltmin[2][SBLIMIT];
	//short FAR **win_buf;
	//static unsigned int scalar[2][3][SBLIMIT];
	//static double FAR max_sc[2][SBLIMIT];
 //   FLOAT snr32[32];
 //   short sam[2][1056];
    int model, stereo, file_stereo;
    int i, j, k, m;
    unsigned long num_samples, nsamp_per_ch, len_frame, nframe;
	int sfreq;
	int bitrate;

	unsigned short tmp;
	short *data[2];
	double data1[9984];//1152
	int count = 0;
	static short prevframe_buf[2][64];
	static short nextframe_buf[2][1151];
	unsigned long nsamp_left, read_offset;
	//ltmintest=fopen("ltmintest.txt","wt");

    /* Most large variables are declared dynamically to ensure
       compatibility with smaller machines */

    sb_sample = (SBS FAR *) mem_alloc(sizeof(SBS), "sb_sample");
    //win_que = (IN FAR *) mem_alloc(sizeof(IN), "Win_que");
    //win_buf = (short FAR **) mem_alloc(sizeof(short *)*2, "win_buf");
 
    /* clear buffers */
    memset((char *) buffer, 0, sizeof(buffer));    
    memset((char *) ltmin, 0, sizeof(ltmin));
	memset((char *) sb_sample, 0, sizeof(SBS));
	//memset((char *) scalar, 0, sizeof(scalar));
    //memset((char *) max_sc, 0, sizeof(max_sc));
    //memset((char *) snr32, 0, sizeof(snr32));
    //memset((char *) sam, 0, sizeof(sam));
 
    fr_ps.header = &info;
    //fr_ps.tab_num = -1;             /* no table loaded */
    //fr_ps.alloc = NULL;


    strcpy(ifilename, "sine1k.pcm");	//sine1k.pcm, originalpreech.pcm, originalbirdies.pcm
	strcpy(ofilename, "c_output.txt");
	file_stereo = 2;

	model = 1;
	info.lay = 1;
	sfreq = 48000;
	bitrate = 128;
	fr_ps.stereo = 2;
	

	info.sampling_frequency = SmpFrqIndex(sfreq);
	info.bitrate_index = BitrateIndex(info.lay, bitrate);
	stereo = fr_ps.stereo;

	if (info.lay == 2)          
		fr_ps.sblimit = pick_table(&fr_ps);
	else                        
		fr_ps.sblimit = SBLIMIT;

	musicin = fopen(ifilename, "rb");
	if (musicin == NULL) {
       printf("Could not find \"%s\".\n", ifilename);
       exit(1);
    }

	ofp = fopen(ofilename, "wt");

	for(num_samples=0;fread(&tmp,sizeof(short),1,musicin)>0;num_samples++) {}		
	
	nsamp_per_ch = (long) num_samples/file_stereo;

	rewind(musicin);

	if (file_stereo==1){
		data[0] = (short *) mem_alloc(nsamp_per_ch*2, "data[0]");
		for (i=0;i<nsamp_per_ch;i++)
			fread(&data[0][i],sizeof(short),1,musicin);
	}
	else
	{
		data[0] = (short *) mem_alloc(nsamp_per_ch*2, "data[0]");
		data[1] = (short *) mem_alloc(nsamp_per_ch*2, "data[1]");
		for (i=0;i<nsamp_per_ch;i++){
			fread(&data[0][i],sizeof(short),1,musicin);
		//	fprintf(musicout,"%c\n",&data[0][i]);
			fread(&data[1][i],sizeof(short),1,musicin);
		}
		fwrite(data[0],2,nsamp_per_ch,musicout);

		fflush(musicout);
		fclose(musicout);
	}

	/*
	if (file_stereo==1)
		for (i=0;i<nsamp_per_ch;i++)		fprintf(ofp, "%d\n", data[0][i]);
	else{
		for (i=0;i<nsamp_per_ch;i++){
			fprintf(ofp, "%d\n", data[0][i]);
			fprintf(ofp, "%d\n", data[1][i]);
		}
	}
	fflush(ofp);
	*/

	len_frame = 1024;
	nframe = (int)(nsamp_per_ch/len_frame);

	memset((char *) prevframe_buf, 0, sizeof(prevframe_buf));
	memset((char *) nextframe_buf, 0, sizeof(nextframe_buf));


	// initialize
	nsamp_left = nsamp_per_ch;
	read_offset = 0;
	if (info.lay==1){				// layer 1
		for (i=0;i<stereo;i++)
			for(j=0;j<64;j++)	  
				buffer[i][j+384] = prevframe_buf[i][j];
	}
	else 
	{									// layer 2, 3
	}
/*******************************888888**************************************/
	fread(data1,sizeof(double),9984,music);		//1152
	count = 0;
	while (nsamp_left>0){
		count++;
		printf("count = %d\n", count);
		//**********************************************
		//******** load PCM samples to buffer **********
		//**********************************************
		if (info.lay==1){				// layer 1
			for (i=0;i<stereo;i++)
				for(j=0;j<64;j++)  
					buffer1[i][j]=buffer1[i][j+384];

			if (nsamp_left<384) {	// lack of samples, pad with next frame
				for (i=0;i<stereo;i++) {
					for(j=64;j<64+nsamp_left;j++)  
						buffer[i][j]=data[i][j+read_offset-64];
					//	buffer1[i][j]=data1[i][j+read_offset-64];
					for(j=64+nsamp_left;j<448;j++) 
						buffer[i][j]=nextframe_buf[i][j-64-nsamp_left];
				}
				nsamp_left = 0;
			}
			else 
			{
				for (i=0;i<stereo;i++)
					for(j=64;j<448;j++)
						buffer1[i][j] = data1[j+read_offset-64];// buffer1[i][j] = data[i][j+read_offset-64];
				nsamp_left = nsamp_left-384;
			}
			read_offset = read_offset+384;
		}	// end of layer 1
		else 
		{		// layer 2 or 3
			if (nsamp_left<1152) {	// lack of samples, pad with next frame
				for (i=0;i<stereo;i++) {
					for(j=0;j<nsamp_left;j++)  
						buffer[i][j]=data[i][j+read_offset];
					for(j=nsamp_left;j<1152;j++) 
						buffer[i][j]=nextframe_buf[i][j-nsamp_left];
				}
				nsamp_left = 0;
			}
			else {
				for (i=0;i<stereo;i++)
					for(j=0;j<1152;j++) buffer[i][j] = data[i][j+read_offset];
				nsamp_left = nsamp_left-1152;
			}
			read_offset = read_offset+1152;
		}	// end of layer 2/3
		//********* end of loading to buffer **********
		
		smr_calc(buffer1, &fr_ps, model, sb_sample, ltmin);


		/*
		for (i=0;i<1152;i++) {
			fprintf(ofp, "%d\n", buffer[0][i]);
			fprintf(ofp, "%d\n", buffer[1][i]);
		}
		*/
		
		// write SMR
		for (i=0;i<stereo;i++) 
			for (j=0;j<SBLIMIT;j++) 
				fprintf(ofp, "%f\n", ltmin[i][j]);

		// write subband samples
		/*
		if (info.lay==1)
			for (i=0;i<stereo;i++)		// chn0[0:383], chn1[0:383]
				for (m=0;m<SBLIMIT;m++) // sb0[0:11],sb2[0:11], ..., sb31[0:11]
					for (k=0;k<SCALE_BLOCK;k++) 							
						fprintf(ofp, "%e\n", (*sb_sample)[i][0][k][m]);
		else
			for (i=0;i<stereo;i++)	 // chn0[0:1151], chn1[0:1151]
				for (j=0;j<3;j++)			 // block0[0:383], block1[0:383], block2[0:383]
					for (m=0;m<SBLIMIT;m++) // sb0[0:11],sb2[0:11], ..., sb31[0:11]
						for (k=0;k<SCALE_BLOCK;k++) 							
							fprintf(ofp, "%e\n", (*sb_sample)[i][j][k][m]);
		*/

	}	// end of while
	
	//**********************************************
	//**** save buffered data for next segment *****
	//**********************************************
	if (info.lay==1){				// layer 1
		for (i=0;i<stereo;i++)
			for(j=0;j<64;j++)  prevframe_buf[i][j] = buffer[i][j+384];
	}
	else {			// layer 2, 3
	}

	printf("count = %d\n", count);
	
	//WriteHdr(&fr_ps, ofp);

    if (fclose(musicin) != 0){
       printf("Could not close \"%s\".\n", ifilename);
       exit(2);
    }
		if (fclose(ofp) != 0){
       printf("Could not close \"%s\".\n", ofilename);
       exit(2);
    }


    printf("Encoding of \"%s\" with psychoacoustic model %d is finished\n", ifilename, model);

	free(data[0]);
	if (stereo==2)	free(data[1]);


    exit(0);
}
