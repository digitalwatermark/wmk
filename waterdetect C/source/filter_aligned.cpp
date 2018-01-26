#include "user.h"


extern double FrameL[FRAMEL];

extern double FrameR[FRAMEL];

double Frame_filter[FRAMEL+GROUP_DELAY];

double Y_filter[FRAMEL];

void filter_aligned()
{
	
	for(int i=0;i<FRAMEL;i++)
	{
		
		Frame_filter[i] = FrameL[i];
	}
	for(i=0;i<GROUP_DELAY;i++)
	{
		Frame_filter[i+FRAMEL] = 0.0;
	
	}

	filter();  //×óÉùµÀ

	for(i=0;i<FRAMEL;i++)
	{
		FrameL[i] = Y_filter[i];
		Frame_filter[i] = FrameR[i];
	
	}
	filter();  //ÓÒÉùµÀ

	for(i=0;i<FRAMEL;i++)
	{
		FrameR[i] = Y_filter[i];
		
	
	}

}