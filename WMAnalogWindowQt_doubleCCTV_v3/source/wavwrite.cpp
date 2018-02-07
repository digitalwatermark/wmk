#include "user.h"

extern FILE *music_with_wm;

extern  double fSigLwmk[FRAMEL*FCNT];
extern  double fSigRwmk[FRAMEL*FCNT];

extern double SigLwmk[FRAMEL];
extern double SigRwmk[FRAMEL];



void wavwrite(int looptime, int last)
{
    int i=0;
    int dout;
    int douttmpL,douttmpR;
    int writepoint =0;// body_start_point;
    double vmaxL,vmaxR,absvL,absvR;

 /*   vmaxL =fabs(fSigLwmk[writepoint]);
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

  //  for( i=writepoint;i<looptime*8192+last/2;i++)
    for(i=0;i<last;i++)
    {
      /* douttmpL=int( (SigLwmk[i]) *32767.0);

        // douttmpL=int( (fSigLwmk[i]/vmaxL) *32768.0+0.5);
        //������
       if (douttmpL < -32768)
            dout = -32768;
        else if (douttmpL >32767)
            dout = 32767;
        else
            dout = douttmpL;

        fwrite(&dout,2,1,music_with_wm);
        fflush(music_with_wm);*/
        if (SigLwmk[i]>1)
        {

           dout = 32767;
        }
        else if(SigLwmk[i]<-1)
        {
            dout=(int)(-32768);
        }
        else
        {
            dout=(int)(SigLwmk[i]*32767);
        }
        fwrite(&dout,2,1,music_with_wm);
        fflush(music_with_wm);



//      ������
     /*   douttmpR=int( (SigRwmk[i]) *32767.0);
       //  douttmpR=int( (fSigRwmk[i]/vmaxR) *32768.0+0.5);
        if (douttmpR < -32768)
            dout = -32768;
        else if (douttmpR >32767)
            dout = 32767;
        else
            dout = douttmpR;

        fwrite(&dout,2,1,music_with_wm);
        fflush(music_with_wm);*/
         if(SigRwmk[i]>1)
         {
              dout = 32767;

         }
         else if(SigRwmk[i]<-1)
         {
             dout=(int)(-32768);
         }
         else
         {
             dout=(int)(SigRwmk[i]*32767);
         }
         fwrite(&dout,2,1,music_with_wm);
         fflush(music_with_wm);
    }
}
