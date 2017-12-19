
#include "user.h"

extern _DataStruct buffer[N];


void fft_96db_normalize(Complex *data_in ,_DataStruct *dataout,_DataList *SPL)
{
    double * BufferDestiPow = (double*)malloc((FFT_SIZE/2)*sizeof(double));
	int j=0,m=0;
	for (int i=0; i<FFT_SIZE/2; i++)
	{
		buffer[0].subdata[i] = pow(data_in[i].real,2) + pow(data_in[i].image,2) ;

		if(buffer[0].subdata[i]<1e-20)
		{
			buffer[0].subdata[i] =1e-20;
		}
		
		
		BufferDestiPow[i] = 10.0*log10( (buffer[0].subdata[i]) )+POWERNORM;
	
		SPL->Spl[i] = 10*log10( (buffer[0].subdata[i]) )+POWERNORM;
		SPL->flag[i] = 'F';
		SPL->Index[i] = i;
		SPL->Count =0;

		j=i+1;
		if( j%8==0 )
		{
			dataout->subdata[(j>>3)-1] = pow(10.0,0.1*MIN_POWER);
			for ( m=1; m<=8; m++)
			{
				dataout->subdata[(j>>3)-1] +=pow(10.0, 0.1*BufferDestiPow[j-m]);
			
			}

			dataout->subdata[(j>>3)-1] = 10.0*log10(dataout->subdata[(j>>3)-1]);
		
		}

	
	}

    dataout->length =32;
    SPL->Count = 256;

    free(BufferDestiPow);

}
