#include "user.h"

extern char musicdataL[FRAMEL];
extern char musicdataR[FRAMEL];
extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

//FILE *musicdatafile = fopen("./test/floatmusic.txt","wt");

void data_convert()
{
	for(int i=0; i<FRAMEL; i++)
	{
		
		if(musicdataL[i]>=32768)
		{
			FrameL[i] = (musicdataL[i] - 65536)/32768.0;
		}
			
		else
		{
			FrameL[i] = musicdataL[i]/32768.0;
			
		}

	//	fprintf(musicdatafile,"%f\n",FrameL[i] );
		if(musicdataR[i]>=32768)
		{
			FrameR[i] = (musicdataR[i] - 65536)/32768.0;
		}
			
		else
		{
			FrameR[i] = musicdataR[i]/32768.0;
			
		}
	}


//fflush(musicdatafile);
}