#include "user.h"

extern short musicdataL[FRAMEL];
extern short musicdataR[FRAMEL];
extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

void data_convert()
{
	for(int i=0; i<FRAMEL; i++)
	{
		
		if(musicdataL[i]>=32768)
		{
            FrameL[i] = (musicdataL[i] - 32768)/32767.0;
		}
			
		else
		{
            FrameL[i] = musicdataL[i]/32767.0;
			
		}

		if(musicdataR[i]>=32768)
		{
            FrameR[i] = (musicdataR[i] - 32768)/32767.0;
		}
			
		else
		{
            FrameR[i] = musicdataR[i]/32767.0;
			
		}
	}

}
