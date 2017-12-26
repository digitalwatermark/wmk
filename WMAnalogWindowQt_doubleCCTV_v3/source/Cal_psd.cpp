#include "user.h"
	

extern _DataStruct buffer[N];

void Cal_psd(_DataStruct *Data_in, _DataStruct *fft_normalize, _DataList *SPL)
{
    Complex *fft_data = (Complex *)malloc(512*sizeof(Complex));
	
    Music_Piecewise(Data_in,&buffer[3]);

	Hanning_Win(&buffer[3],fft_data);

	ifft_fft(fft_data,buffer[3].length);
	
	fft_96db_normalize(fft_data,fft_normalize,SPL);

    free(fft_data);

}
