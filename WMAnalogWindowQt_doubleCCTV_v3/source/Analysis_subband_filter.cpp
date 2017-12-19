#include "user.h"

double Z[512];
double Y[64];
extern _DataStruct buffer[N];
void Analysis_subband_filter(double *S,_DataStruct *buffer_pr,_table *Param)
{
	int k = 0;
    int j = 0;
	int i=0;

	_DataStruct *X;

	if(Param->channlecut==0)
	{
		X= &buffer[4];  //×óÉùµÀµÄÂË²¨Æ÷£»
	}
	else if(Param->channlecut==1)
	{
		X= &buffer[5];  //ÓÒÉùµÀµÄÂË²¨Æ÷£»
	}
	else if(Param->channlecut==2)
	{
		X= &buffer[6];  //PNµÄÂË²¨Æ÷£»
	}
   
	for (k=0 ; k<12; k++)
	{
		
		for( j=479; j>=0; j--)
		{
			X->subdata[j+32] = X->subdata[j];
		}
		
		for( j=0; j<32; j++)
		{
			X->subdata[j] = buffer_pr->subdata[k*32+31-j];		
		}


		for(j=0; j<512; j++)
		{
			Z[j] = X->subdata[j] * C[511-j];
		}
		
		for(j=0; j<64; j++)
		{
			Y[j]=0;
			for(i=0; i<8; i++)
			{
				Y[j] =Y[j]+Z[j+64*i];
			}
	
		}
		for(i=0; i<32; i++)
		{
			S[k+i*12]=0;
			for(j=0; j<64; j++)
			{
				S[k+i*12] =	S[k+i*12]+ M[i][j] * Y[j];
				
			}
		
		}

	}

}
