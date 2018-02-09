#include "user.h"


extern FILE *music_with_wm;

extern  double fSigLwmk[FRAMEL*FCNT];
extern  double fSigRwmk[FRAMEL*FCNT];
extern  double vmaxL,vmaxR;

void wavwrite(int looptime, int last)
{
    int i=0;
    int dout;
    int douttmpL,douttmpR;
    int writepoint =0;// body_start_point;

    for( i=writepoint;i<looptime*8192+last/2;i++)
    {
        if(i%50==0)
            fflush(music_with_wm);
        douttmpL=int( (fSigLwmk[i]/vmaxL) *32768.0+0.5);
        //◊Û…˘µ¿
        if (douttmpL < -32768)
            dout = -32768;
        else if (douttmpL >32767)
            dout = 32767;
        else
            dout = douttmpL;

        fwrite(&dout,2,1,music_with_wm);
//      ”“…˘µ¿
        douttmpR=int( (fSigRwmk[i]/vmaxR) *32768.0+0.5);
        if (douttmpR < -32768)
            dout = -32768;
        else if (douttmpR >32767)
            dout = 32767;
        else
            dout = douttmpR;

        fwrite(&dout,2,1,music_with_wm);
    }

}
