#include "user.h"

/*******************************************************************************
 *  FILE        :  Finding_tonal_component.c
 *  AUTHOR      :  dina@abs.ac.cn
 *  DATE        :  2015/6/3
 *  DESCRIPTION :  Identifie and list non-tonal components of the 
                   audio signal. It is assume in this implementation that the 
				   frequency sampling fs is 48000 Hz.
 *  Revision    :  none
 *  All rights reserved
 ********************************************************************************/


void Finding_Ntonal_component(_DataList *SPL,_table *Param)
{
    int length = SPL->Count,centre=0,j;

	double weight,sum,index;

		for(int i=0; i<CBL-1; i++)
		{
			
			for( j = Param->index[Param->CB[i]-1],weight=0.0,sum = MIN_POWER; j<Param->index[Param->CB[i+1]-1]; j++ )
				{
					
					if( SPL->flag[j] != 'T')
					{

						if (SPL->Spl[j]!=MIN_POWER)
						{
							sum = db_add(sum ,SPL->Spl[j]);
							weight = weight + pow(10.0, SPL->Spl[j]/10.0)*(j-  Param->index[Param->CB[i]-1])/(Param->index[Param->CB[i+1]-1]-Param->index[Param->CB[i]-1]);
								SPL->Spl[j] = MIN_POWER;
						}
					
					}

				}
				if(sum<=-200)
				{
					centre = ( Param->index[Param->CB[i+1]-1]+ Param->index[Param->CB[i]-1]) /2;
				}
				else
				{
					index = weight/pow(10.0,sum/10.0);

					centre = (int)(index*( Param->index[Param->CB[i+1]-1]- Param->index[Param->CB[i]-1])) +  Param->index[Param->CB[i]-1];
				}

				if(SPL->flag[centre]=='T')
                {
					if(SPL->flag[centre+1]=='T')
						centre++;
					else
						centre--;
                }

					SPL->Spl[centre] = sum;

					SPL->flag[centre] = 'N';
	
		}


}
