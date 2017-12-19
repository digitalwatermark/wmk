#include "user.h"


extern  _SigInoiseStruct inoise;

extern  _SigInoiseStruct bufferx;

extern double SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];

extern double SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];

extern double onoise[FRAMEL+Npad_Prefix+Npad_Prefix];


double Sx[384];

double SMRsb[32];

double smrbuffer[448];



void noise_masking_sub(_table *Param)
{
	double scf_bin[384];
	double sno_seg[384];
    int    cutoff,i=0,j=0;

	double *onoise_tmp = (double*)malloc(Nblk*Param->Nseg*sizeof(double));

	_DataStruct  inoise_slice;

	inoise_slice.length = Nblk;

	_DataStruct sni;
	sni.length = Nblk;

	cutoff = Param->channlecut;
   
    for(i=0; i<Param->Nseg; i++)
	{
		
        for(j=0; j<64;j++)
		{
			smrbuffer[j] = smrbuffer[Nblk+j];
		}

		for(j=0;j<Nblk;j++)
		{
			smrbuffer[64+j] = bufferx.data[i*Nblk+j];
			
			inoise_slice.subdata[j] = inoise.data[j+Nblk*i];
		}
		
		SMR(smrbuffer,SMRsb,Sx,Param);

		Param->channlecut = 2;				//PN–Ú¡–

		Analysis_subband_filter(sni.subdata,&inoise_slice,Param);

		SniMask(sni.subdata,SMRsb,Sx,scf_bin);

		Synthesis_subband_filter(sni.subdata,sno_seg);

		for(j=0 ; j<Nblk;j++)
		{	
			*onoise_tmp= sno_seg[j];

			onoise_tmp++;
		}
		if(cutoff==0)
			Param->channlecut =0;
		else
			Param->channlecut =1;
	}

	onoise_tmp = onoise_tmp-Param->Nseg*Nblk+SYNTD+BUFFERSHIFT;

	for(i=0; i<FRAMEL+Npad_Prefix+Npad_Prefix; i++)
	{
		onoise[i] = *onoise_tmp++;
	}

	onoise_tmp = onoise_tmp-FRAMEL-SYNTD-BUFFERSHIFT-Npad_Prefix-Npad_Prefix;  //‘Î…˘—” ±481+64

	free(onoise_tmp);
}
