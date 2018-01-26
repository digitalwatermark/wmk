#include "user.h"

extern double Frame_filter[FRAMEL+GROUP_DELAY];
extern double Y_filter[FRAMEL];

void filter()
{

	double bufferx[REV_FILTERL]={0};
	double y_f[FRAMEL+GROUP_DELAY];


	
	for(int i=0;i<FRAMEL+GROUP_DELAY;i++)
	{
	
		for(int k=REV_FILTERL-1;k>0;k--)
		{
			bufferx[k] = bufferx[k-1];
					
		}	
		
		bufferx[0] = Frame_filter[i];
		
		y_f[i]=0;

		for(int j=0;j<REV_FILTERL;j++)
		{
			y_f[i]=y_f[i]+bufferx[j]*h_extfilter[j];
		
		}
	}
	for(int k=0;k<FRAMEL;k++)
	{
		Y_filter[k] = y_f[k+GROUP_DELAY];
	}

}