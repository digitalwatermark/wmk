#include "user.h"



void Music_Piecewise(_DataStruct *datain, _DataStruct *dataout)
{
    int i=0;

	 static double bufferptr[640] ={0.0};

	static	int offset = 256;

    for(i=0;i<384;i++)
	{
		bufferptr[(i+offset)%640]= datain->subdata[i];
	}
	for(i=0 ; i<512; i++)
	{
		dataout->subdata[i] = bufferptr[(i+448+offset)%640];
	}

	 offset += 384;
	 offset %= 640;

	 dataout->length = 512;



}
