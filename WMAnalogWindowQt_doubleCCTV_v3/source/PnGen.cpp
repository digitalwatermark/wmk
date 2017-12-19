#include "user.h"

double G[FRAMEL][13];

double radnpn[FRAMEL];

extern double PNinput[FRAMEL];

char *pnopenname;

void PnGen(_SigInoiseStruct inoise)
{
    int i;
    FILE *PnSe = fopen(pnopenname,"rb");
	if(PnSe==NULL) 
    {
        MessageBox(NULL,TEXT("Error path of pn.txt!"),TEXT("Waring"),MB_OK);
    }
		
    fread(PNinput,sizeof(double),FRAMEL,PnSe);


	for (i=0; i<FRAMEL; i++)
	{		
		inoise.data[i+576] = PNinput[i];
	}

	for( i=0; i<BUFFERSHIFT;i++)
	{
		inoise.data[i] =0;
	}

	for(i=0; i<512;i++)
	{
		inoise.data[i+BUFFERSHIFT] =PNinput[FRAMEL-512+i];
	}

	for(i=inoise.length-512-768;i<inoise.length;i++)
	{
		inoise.data[i] =0;
    }
    fclose(PnSe);



}
