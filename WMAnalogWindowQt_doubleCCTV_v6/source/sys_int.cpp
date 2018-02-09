#include "user.h"

extern  _SigInoiseStruct inoise;
extern  _SigInoiseStruct bufferx;
extern  double PNinput[FRAMEL];

void sys_int(_table *Param)
{
	Param->Nseg = (BUFFERL1+SYNTD)/Nblk+1; 	//384Ö¡Õû³ýNseg
	inoise.length= Param->Nseg *Nblk+BUFFERSHIFT;
    inoise.data =(double*)malloc(inoise.length*sizeof(double));
	bufferx.length =Param->Nseg *Nblk;
    bufferx.data = (double*)malloc(bufferx.length*sizeof(double));

    table_init48(MODSEL,Param);
}

