/*******************************************************************************
 *  FILE        :  Tonal_Ntonal_decimate.c
 *  AUTHOR      :  dina@abs.ac.cn
 *  DATE        :  2015/6/3
 *  DESCRIPTION :  Components which are below the auditory threshold or are less than 
                   one half of a critical band width from a neighbouring component are
                   eliminated.
 *  Revision    :  none
 *  All rights reserved
 ********************************************************************************/

#include "user.h"



void Tonal_Ntonal_decimate(_DataList *SPL,_table *param)
{
    int i,index,cnt=0;

	int	T_index[102];
	double T_bark[102];

	for(i=0;i<256;i++)
	{
		
		if( SPL->flag[i] == 'T'|| SPL->flag[i] == 'N')
		{
			index = param->Map[i];
			
			if( SPL->Spl[i] <= param->TLq[index])
			{
				SPL->flag[i] = 'F';
				SPL->Spl[i] = MIN_POWER;
				
            }
        }
	}


	for(i=0 ;i<256;i++)
	{
		if(SPL->flag[i] == 'T')
		{
			T_index[cnt] = i;

			T_bark[cnt] = param->bark[param->Map[i]];

			cnt++;
		}
	
	}

	for(i=0 ;i<cnt-1;i++)
	{
		if( (T_bark[i+1] - T_bark[i])<0.5 )
		{	
			if( SPL->Spl[T_index[i+1]] > SPL->Spl[T_index[i]] )
			{
				SPL->flag[T_index[i]] = 'F';
				SPL->Spl[T_index[i]] = MIN_POWER;
			}
				
			else
			{
				SPL->flag[T_index[i+1]] = 'F';
				SPL->Spl[T_index[i+1]] = MIN_POWER;
				T_bark[i+1]= T_bark[i];
				T_index[i+1] = T_index[i];
			}
		}
	
	}

}
