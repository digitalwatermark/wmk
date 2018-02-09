#include "user.h"

extern double SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];
extern double SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];
extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

void frame_perfix()
{
    int i=0;
	
    for(i=0;i<Npad_Prefix+Npad_Prefix;i++)
	{
		
		SigBufL[i] = SigBufL[FRAMEL+i];
		SigBufR[i] = SigBufR[FRAMEL+i];	
	}
	for(i=0;i<FRAMEL;i++)
	{
		SigBufL[i+Npad_Prefix+Npad_Prefix] = FrameL[i];
		SigBufR[i+Npad_Prefix+Npad_Prefix] = FrameR[i];	
	}

}
