#include "user.h" 


extern  _SigInoiseStruct inoise;

void noise_gen(_DataStruct *sni,_table *Param)
{

	_DataStruct  inoise_slice;

	inoise_slice.length =Nblk;
	
	for(int i=0;i<Param->Nseg;i++)
	{

		for(int j=0;j<inoise_slice.length;j++)
		{

			inoise_slice.subdata[j] = inoise.data[j+384*i];

		}
			Analysis_subband_filter(sni->subdata,&inoise_slice,Param);
	
	}
	
	
}
