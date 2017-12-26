#include "user.h"

extern double SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];
extern double SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];

extern double SigLwmk[FRAMEL];
extern double SigRwmk[FRAMEL];

extern  _SigInoiseStruct inoise;
extern  _SigInoiseStruct bufferx;

extern  float  nmr_gain;

double onoise[FRAMEL+Npad_Prefix+Npad_Prefix];

extern double plotx[FRAMEL];
extern double pny[FRAMEL];
extern double musicy[FRAMEL];

void noise_masking(_table *Param)
{

        int bufxlen = bufferx.length;

        int i=0,j=0;

        //������
        for(j=0; j<FRAMEL+Npad_Prefix+Npad_Prefix;j++)  //ǰ9216����
		{
			bufferx.data[j] = SigBufL[j];
		}
		for(j=FRAMEL+Npad_Prefix+Npad_Prefix;j<bufxlen;j++) //��768��0
		{
			bufferx.data[j] = 0.0;
		}
        Param->channlecut = 0 ;

		noise_masking_sub(Param);

        for(i=0; i<FRAMEL;i++)
		{
            plotx[i] = i+1;
            pny[i] = pow(10,(nmr_gain/20.0))*onoise[i+Npad_Prefix];
            musicy[i] = SigBufL[i+Npad_Prefix];
            SigLwmk[i] = pny[i] + musicy[i];
		}
	
        //������
        for( j=0; j<FRAMEL+Npad_Prefix+Npad_Prefix;j++)  //ǰ9216����
		{
			bufferx.data[j] = SigBufR[j];
		}

		for(j=FRAMEL+Npad_Prefix+Npad_Prefix;j<bufxlen;j++) //��768��0
		{
			bufferx.data[j] = 0.0;
		}

        Param->channlecut = 1 ;

		noise_masking_sub(Param);

		for( i=0; i<FRAMEL;i++)
		{
            SigRwmk[i] = pow(10,(nmr_gain/20.0))*onoise[i+Npad_Prefix]+SigBufR[i+Npad_Prefix];
        }



}
