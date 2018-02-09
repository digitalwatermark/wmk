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
extern    int     input_lenght;
extern    int       *input_txt_int;
extern    char      *input_txt;
extern    double   vmaxL,vmaxR;
extern    FILE    *WaveRdFp;

extern long wavendlen;

MyThread::MyThread()
: QThread()
{
}

MyThread::~MyThread()
{
}

void MyThread::run()
{
    int j,i;
    int input_i,a,b;

    for(loopcount=0; loopcount<=Param->looptime; loopcount=loopcount+(input_lenght+1)*one_pn_frame)
    {

        if(loopcount == Param->looptime - Param->looptime%((input_lenght+1)*one_pn_frame))
        {

            for(loopcount=loopcount; loopcount<=Param->looptime; loopcount++)
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
                        b = loopcount*FRAMEL+j;
                        fSigLwmk[b] = SigLwmk[j];
                        fSigRwmk[b] = SigRwmk[j];
                        if(fabs(SigLwmk[j])>vmaxL)
                            vmaxL =fabs(SigLwmk[j]);
                        else
                            vmaxL = vmaxL;
                        if(fabs(SigLwmk[j])>vmaxR)
                            vmaxR = fabs(SigLwmk[j]);
                        else
                            vmaxR = vmaxR;
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
                        b = loopcount*FRAMEL+j;
                        fSigLwmk[b] = SigLwmk[j];
                        fSigRwmk[b] = SigRwmk[j];
                        if(fabs(SigLwmk[j])>vmaxL)
                            vmaxL =fabs(SigLwmk[j]);
                        else
                            vmaxL = vmaxL;
                        if(fabs(SigLwmk[j])>vmaxR)
                            vmaxR = fabs(SigLwmk[j]);
                        else
                            vmaxR = vmaxR;
                    }
                }
            }
        }else{
            for(input_i=0; input_i<=input_lenght; input_i++)
            {
                pnopenname = pnopenname_array[input_txt_int[input_i]];
                PnGen(inoise);

                for(a=0; a<one_pn_frame; a++)
                {
                    fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);

                    for(j=0; j<FRAMEL;j++)
                    {
                        musicdataL[j] = musicdata[2*j];
                        musicdataR[j] = musicdata[2*j+1];
                    }

                    wmk_gen(Param);

                    if(loopcount == 0)
                    {
                        //不要把初始化的512点数据写入文件
                        Param->body_start_point = Npad_Prefix;
                        Param->bodylen = FRAMEL- Npad_Prefix;
                    }
                    else
                    {
                        Param->body_start_point= 0;
                        Param->bodylen = FRAMEL;
                    }

                    for(j=0; j<FRAMEL; j++)
                    {
                        b = (loopcount+input_i*one_pn_frame+a)*FRAMEL+j;
                        fSigLwmk[b] = SigLwmk[j];
                        fSigRwmk[b] = SigRwmk[j];
                        if(fabs(SigLwmk[j])>vmaxL)
                            vmaxL =fabs(SigLwmk[j]);
                        else
                            vmaxL = vmaxL;
                        if(fabs(SigLwmk[j])>vmaxR)
                            vmaxR = fabs(SigLwmk[j]);
                        else
                            vmaxR = vmaxR;
                    }
                }
            }
        }


    }//end of looptime

    loopcount = Param->looptime;
    wavwrite(Param->looptime, Param->last);

    for(i=0;i<wavendlen;i++)
    {
        j=fgetc(WaveRdFp);
        fwrite(&j,1,1,music_with_wm);
    }
    fclose(music_with_wm);
    fclose(WaveRdFp);
    delete(input_txt);
    delete(input_txt_int);

    ifisrunning = false;
    MessageBox(NULL,TEXT("Success!"),TEXT("Success"),MB_OK);

    ThreadState = false;


}
