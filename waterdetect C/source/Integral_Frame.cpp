#include "user.h"



extern short musicdataL[FRAMEL];
extern short musicdataR[FRAMEL];


extern double SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];
extern double SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];

extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

void Integral_Frame()
{

		data_convert();

		frame_perfix();

	
}