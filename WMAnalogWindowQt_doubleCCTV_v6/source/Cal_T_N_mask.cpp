/*******************************************************************************
 *  FILE        :  Cal_T_N_mask.c
 *  AUTHOR      :  dina@abs.ac.cn
 *  DATE        :  2015/6/8
 *  DESCRIPTION :  Compute the masking effect of both tonal and non_tonal components 
                   on the neighbouring spectral frequencies.
 *  Revision    :  none
 *  All rights reserved
 ********************************************************************************/

#include "user.h"




void Cal_T_N_mask(_DataList *SPL,_DataStruct *LTg , _table *param)
{
    int j = 0;
    int cnt =0;
	double dz,avm,vf;

    for(int i =0;i<102;i++)
    {
        cnt=0;
        LTg->subdata[i] = MIN_POWER;

        for(j=0;j<256;j++)
        {
            if( SPL->flag[j]=='T' || SPL->flag[j]=='N')
            {
                dz = param->bark[i] - param->bark[param->Map[SPL->Index[j]]];

                if( (dz>=-3) && (dz<8))
                {
                    if ( (dz>=-3)&& (dz<-1) )
                    {
                        vf = 17*(dz+1) - ( 0.4*SPL->Spl[j] + 6);
                    }
                    else if ( (dz>=-1)&&(dz<0))
                    {
                        vf = (0.4*SPL->Spl[j] +6)*dz;
                    }
                    else if( (0<=dz)&&(dz<1))
                    {
                        vf = -17*dz;

                    }
                    else if( (dz>=1) && (dz<8))
                    {
                        vf = (-1*(dz-1))*( 17-0.15*SPL->Spl[j]) -17;
                    }
                    if(SPL->flag[j]=='T')
                    {
                        avm = -1.525 - 0.275*param->bark[param->Map[SPL->Index[j]]]-4.5+SPL->Spl[j]+vf;



                    }
                    else if (SPL->flag[j]=='N')
                    {
                        avm = -1.525 - 0.175*param->bark[param->Map[SPL->Index[j]]] - 0.5+SPL->Spl[j]+vf;


                    }
                    LTg->subdata[i] = db_add(LTg->subdata[i],avm);



                }

            }
        }


        LTg->subdata[i] = db_add(LTg->subdata[i],param->TLq[i]);

    }

    LTg->length = 102;

}
