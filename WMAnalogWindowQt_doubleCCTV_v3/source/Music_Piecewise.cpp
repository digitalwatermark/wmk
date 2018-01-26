#include "user.h"


FILE *index1_fp = fopen("index1.txt","wb");
FILE *index2_fp = fopen("index2.txt","wb");
void Music_Piecewise(_DataStruct *datain, _DataStruct *dataout)
{
    int i=0;

	 static double bufferptr[640] ={0.0};

	static	int offset = 256;

    int index1[384];
    int index2[512];

    for(i=0;i<384;i++)
	{
		bufferptr[(i+offset)%640]= datain->subdata[i];
        index1[i] = (i+offset)%640;
	}
    fwrite(index1,sizeof(int),384,index1_fp);

    fflush(index1_fp);
	for(i=0 ; i<512; i++)
	{
		dataout->subdata[i] = bufferptr[(i+448+offset)%640];
        index2[i] = (i+448+offset)%640;

	}
    fwrite(index2,sizeof(int),512,index2_fp);

    fflush(index2_fp);

	 offset += 384;
	 offset %= 640;

	 dataout->length = 512;



}
