/*******************************************************************************
 *  FILE        :  Finding_tonal_component.c
 *  AUTHOR      :  dina@abs.ac.cn
 *  DATE        :  2015/5/29
 *  DESCRIPTION :  Identifie and list both tonal components of the 
                   audio signal. It is assume in this implementation that the 
				   frequency sampling fs is 48000 Hz.
 *  Revision    :  none
 *  All rights reserved
 ********************************************************************************/

#include "user.h"


void Finding_tonal_component(_DataList *SPL,_table *Param)
{
	int length = SPL->Count,cnt=0;
	double tmp_db;
	 

	for(int i=2; i<length-6;i++)
	{
		double tonal_max = SPL->Spl[i];
					
		if ( (tonal_max > SPL->Spl[i-1]) && (tonal_max > SPL->Spl[i+1]) )//X(k) > X(k-1)   and   X(k) >= X(k+1)
		{
			
			if(i==2)

			{	
				tmp_db= db_add(SPL->Spl[i],SPL->Spl[i-1]);
				SPL->Spl[i] = db_add( tmp_db,SPL->Spl[i+1] );
				SPL->Index[i] = i;
				SPL->flag[i] ='T';
			}
			else if ( (i>2)&&(i<63) )
			{
					if ( (tonal_max - SPL->Spl[i-2])>=7 && (tonal_max - SPL->Spl[i+2])>=7 )
					{
							tmp_db= db_add(SPL->Spl[i],SPL->Spl[i-1]);
							SPL->Spl[i] = db_add( tmp_db,SPL->Spl[i+1] );

							SPL->Spl[i-1] = SPL->Spl[i+1] = SPL->Spl[i-2] = SPL->Spl[i+2] = MIN_POWER;

							SPL->Index[i] = i;
							SPL->flag[i] ='T';

							cnt++;					
					}

			}
			else if( (i>=63) && (i<127))
			{
					if ( (tonal_max - SPL->Spl[i-2])>=7 && (tonal_max - SPL->Spl[i+2])>=7 && 
						(tonal_max - SPL->Spl[i-3])>=7 && (tonal_max - SPL->Spl[i+3])>=7)
					{
						
						tmp_db= db_add(SPL->Spl[i],SPL->Spl[i-1]);	//	Tonallist->Spl[cnt] = tonal_max;
						SPL->Spl[i] = db_add( tmp_db,SPL->Spl[i+1] );
						SPL->Spl[i-3] = SPL->Spl[i+3]  =SPL->Spl[i-1] = SPL->Spl[i+1] = SPL->Spl[i-2] = SPL->Spl[i+2] =MIN_POWER;
						SPL->Index[i] = i;
						SPL->flag[i] ='T';
						cnt++;					
					}
			
			}
			else if((i>=127) && (i<250) )
			{
				if ( (tonal_max - SPL->Spl[i-2])>=7 && (tonal_max - SPL->Spl[i+2])>=7 
					&& (tonal_max - SPL->Spl[i-3])>=7 && (tonal_max - SPL->Spl[i+3])>=7 
					&& (tonal_max - SPL->Spl[i-4])>=7 && (tonal_max - SPL->Spl[i+4])>=7
					&& (tonal_max - SPL->Spl[i-5])>=7 && (tonal_max - SPL->Spl[i+5])>=7
					&&	(tonal_max - SPL->Spl[i-6])>=7 && (tonal_max - SPL->Spl[i+6])>=7)
					{
					
						tmp_db= db_add(SPL->Spl[i],SPL->Spl[i-1]);	//	Tonallist->Spl[cnt] = tonal_max;
						SPL->Spl[i]= db_add( tmp_db,SPL->Spl[i+1] );
						SPL->Spl[i-6] = SPL->Spl[i+6]  =SPL->Spl[i-5] = SPL->Spl[i+5] = SPL->Spl[i-4] = SPL->Spl[i+4] =
						SPL->Spl[i-3] = SPL->Spl[i+3]  =SPL->Spl[i-2] = SPL->Spl[i+2] = SPL->Spl[i-1] = SPL->Spl[i+1] = MIN_POWER;

						SPL->Index[i] = i;
						SPL->flag[i] ='T';

						cnt++;
					
					}			
			}

		}
	}

	
	SPL->Count = cnt;		

}
