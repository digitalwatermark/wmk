#include "user.h"

extern double       SigLwmk[FRAMEL];
extern double       SigRwmk[FRAMEL];

extern WAVEHDR      m_pWaveHdrOut[BLOCK_COUNT];
extern CHAR			m_cBufferIn[BLOCK_COUNT][MAX_BUFF_SOUNDSIZE];

extern bool         WMAdd;
extern double       plotx[FRAMEL];
extern double       musicy[FRAMEL];
extern double       pny[FRAMEL];

extern long t1;
extern long t2;

void AnalogOutDataWrite(int BoxNum)
{
	int dout;
	for(int i=0; i<FRAMEL; i++)
	{
        if(WMAdd == false)
        {
            plotx[i] = i+1;
            musicy[i] = SigLwmk[i];
            pny[i] = 0;
        }
        else{}

//      ×óÉùµÀ
		if(SigLwmk[i]>1)// ¼ì²âÒç³ö´íÎó
		{
			dout=(int)(32767);	
		}
		else if(SigLwmk[i]<-1)
		{
			dout=(int)(-32768);
		}
		else
		{
		    dout=(int)(SigLwmk[i]*32768);
		}
		m_cBufferIn[BoxNum][i*4] = (CHAR)(dout);
		m_cBufferIn[BoxNum][i*4+1] = (CHAR)(dout>>8);


//      ÓÒÉùµÀ
		if(SigRwmk[i]>1)
		{
			dout=(int)(32767);
		}
		else if(SigRwmk[i]<-1)
		{
			dout=(int)(-32768);
		}
		else
		{
			dout=(int)(SigRwmk[i]*32768);
		}
		m_cBufferIn[BoxNum][i*4+2] = (CHAR)(dout);
		m_cBufferIn[BoxNum][i*4+3] = (CHAR)(dout>>8);

        long t2=GetTickCount();

        printf("time:%ld\n",t2-t1);
	}

}
