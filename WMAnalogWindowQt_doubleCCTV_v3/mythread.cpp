#include "mythread.h"
#include "user.h"

extern  _State State_Switch;
extern  _table *Param;
extern _SigInoiseStruct inoise;
extern _SigInoiseStruct bufferx;
extern  FILE   *WaveRdFp;
extern  FILE   *music_with_wm;
extern  bool   ThreadState;
extern  int    loopcount;//当前循环次数

short musicdataL[FRAMEL];
short musicdataR[FRAMEL];
short musicdata[FRAMEL*2];

extern  double SigLwmk[FRAMEL];
extern  double SigRwmk[FRAMEL];
extern  double fSigLwmk[FRAMEL*FCNT];
extern  double fSigRwmk[FRAMEL*FCNT];
extern  char   *pnopenname;

extern    int     one_pn_frame;
extern    char    *pnopenname_array[PN_NUM];
extern    bool    ifisrunning;

MyThread::MyThread()
: QThread()
{
}

MyThread::~MyThread()
{
}

void MyThread::run()
{
    int j;
    pnopenname = pnopenname_array[1];
    PnGen(inoise);

    for(loopcount=0; loopcount<=Param->looptime; loopcount++)
    {
        if(loopcount == Param->looptime)//最后一帧
        {
            fread(musicdata,sizeof(short),Param->last,WaveRdFp);

            for(j=0; j<FRAMEL;j++)
            {
                if(j<Param->last/2)
                {
                    musicdataL[j] = musicdata[2*j];
                    musicdataR[j] = musicdata[2*j+1];
                }
                else//最后一帧补零处理
                {
                    musicdataL[j] =0;
                    musicdataR[j] =0;
                }
            }

            wmk_gen(Param);

            Param->body_start_point =0;
            Param->bodylen = Param->last/2+Npad_Prefix;

            for(j=0; j<FRAMEL; j++)
            {
                fSigLwmk[loopcount*FRAMEL+j] = SigLwmk[j];
                fSigRwmk[loopcount*FRAMEL+j] = SigRwmk[j];
            }
        }
        else
        {
            fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);

            for(j=0; j<FRAMEL;j++)
            {
                musicdataL[j] = musicdata[2*j];
                musicdataR[j] = musicdata[2*j+1];
            }

            wmk_gen(Param);

            Param->body_start_point= 0;
            Param->bodylen = FRAMEL;

            for(j=0; j<FRAMEL; j++)
            {
                fSigLwmk[loopcount*FRAMEL+j] = SigLwmk[j];
                fSigRwmk[loopcount*FRAMEL+j] = SigRwmk[j];
            }
        }

    }//end of looptime
    wavwrite(Param->looptime, Param->last);
    fclose(music_with_wm);
    fclose(WaveRdFp);

    ifisrunning = false;
    MessageBox(NULL,TEXT("Success!"),TEXT("Success"),MB_OK);


    ThreadState = false;


}
