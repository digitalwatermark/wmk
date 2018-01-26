#include "user.h"


extern FILE *music_with_wm;

extern  double fSigLwmk[FRAMEL*FCNT];
extern  double fSigRwmk[FRAMEL*FCNT];

void wavwrite(int looptime, int last)
{
    int i=0;
    int dout;
    int douttmpL,douttmpR;
    int writepoint =0;// body_start_point;
    double vmaxL,vmaxR,absvL,absvR;

  /*  vmaxL =fabs(fSigLwmk[writepoint]);
    vmaxR =fabs(fSigRwmk[writepoint]);

    for(i=writepoint+1;i<looptime*8192+last/2;i++)
    {
        if(fabs(fSigLwmk[i])>vmaxL)
            vmaxL =fabs(fSigLwmk[i]);
        else
            vmaxL = vmaxL;

        if(fabs(fSigRwmk[i])>vmaxR)
            vmaxR = fabs(fSigRwmk[i]);
        else
            vmaxR = vmaxR;
    }*/

    for( i=writepoint;i<looptime*8192+last/2;i++)
    {
        douttmpL=int( (fSigLwmk[i]) *32767.0);
        //������
       if (douttmpL < -32768)
            dout = -32768;
        else if (douttmpL >32767)
            dout = 32767;
        else
            dout = douttmpL;

        fwrite(&dout,2,1,music_with_wm);
        fflush(music_with_wm);
//      ������
        douttmpR=int( (fSigRwmk[i]) *32767.0);
        if (douttmpR < -32768)
            dout = -32768;
        else if (douttmpR >32767)
            dout = 32767;
        else
            dout = douttmpR;

        fwrite(&dout,2,1,music_with_wm);
        fflush(music_with_wm);
    }
}
