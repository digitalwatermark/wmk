#include "user.h"



void 	Hanning_Win(_DataStruct *datain ,Complex *fft_data)
{
	double sqrt_8_over_3;
	int i;
	double window[512];
	//ººÄþ´° 0.5*[1£­cos[2*PI*n/(N-1)]]   0¡Ün¡ÜN-1

//	sqrt(8/3)  * 0.5 * {1 - cos[2 * p * (i)/(N-1)]}
/*	for(int i=0; i< datain->length; i++)
	{
		fft_data[i].real =0.5*(1-cos(2*pi*i/(N-1)));
		fft_data[i].image = 0;
	}
	for(int j = 0; j < 512; j++)
	{
		(fft_data+j)->real = sqrt(8/3) * (fft_data+j)->real;
	}

	
	//s .* h
	for(i = 0; i < 512; i++)
	{
		(fft_data+i)->real = datain->data[0][i] * (fft_data+i)->real;
	}*/
	sqrt_8_over_3 = pow(8.0/3.0, 0.5);
    for(i=0;i<512;i++){
      /* Hann window formula */
      window[i]=sqrt_8_over_3*0.5*(1-cos(2.0*PI*i/512))/512;
    }
  
	for( i=0; i<datain->length; i++)
	{
		fft_data[i].real = datain->subdata[i]*window[i]; 

		fft_data[i].image = 0;
	
	}

}