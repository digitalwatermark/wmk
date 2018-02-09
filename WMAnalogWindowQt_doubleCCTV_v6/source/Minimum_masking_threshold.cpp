/*******************************************************************************
 *  FILE        :  Minimum_masking_threshold.c
 *  AUTHOR      :  dina@abs.ac.cn
 *  DATE        :  2015/6/9
 *  DESCRIPTION :  Compute the global masking threshold for the subset of frequency 
                   lines defined in table. Find the minimum of the global masking 
				   threshold for each subband.
 *  Revision    :  none
 *  All rights reserved
 ********************************************************************************/

#include "user.h"



void Minimum_masking_threshold(_DataStruct *LTg,double *LTminn,_table *param)
{
//FILE * fp = fopen("./test\\testspl.txt","wt");
	int i,len = LTg->length,j=0;
	double min;




	for (i=0; i<N_SUBBAND;i++)
	{
		if(j>=len-1)
		{
			LTminn[i] = param->TLq[len-1];
		}
		else
		{
			min = LTg->subdata[j];
			while ( (param->index[j])>>3==i)
			{
				if( min >  LTg->subdata[j])
					min = LTg->subdata[j];

					j++;
			
			}
		
			LTminn[i] = min;
		}
			
			
			
	
	//	fprintf(fp,"%f\n",	LTminn[i]);
	
	
		
	}
//fclose(fp);

}