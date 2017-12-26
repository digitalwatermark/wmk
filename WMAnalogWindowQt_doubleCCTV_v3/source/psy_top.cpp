#include "user.h"

extern  _State State_Switch;
extern  _table *Param;
extern _SigInoiseStruct inoise;
extern _SigInoiseStruct bufferx;
extern  FILE   *WaveRdFp;
extern  FILE   *music_with_wm;

/*short musicdataL[FRAMEL];
short musicdataR[FRAMEL];
short musicdata[FRAMEL*2];*/

int psy_top()
{
    /*int i,j;

    wavhead_get(Param);

    for(i=0;i<=Param->looptime;i++)
	{
		if(i==Param->looptime)
		{
			fread(musicdata,sizeof(short),Param->last,WaveRdFp);	

            for(j=0; j<FRAMEL;j++)
            {
                if(j<Param->last/2)
                {
                    musicdataL[j] = musicdata[2*j];
                    musicdataR[j] = musicdata[2*j+1];
                }
                else
                {
                    musicdataL[j] =0;
                    musicdataR[j] =0;
                }
            }

            wmk_gen(Param);         //最后一帧补零处理

            Param->body_start_point =0;
            Param->bodylen = Param->last/2+Npad_Prefix;

            wavwrite(Param);
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

            if(i==0)
            {
                Param->body_start_point = Npad_Prefix;  //不要把初始化的512点数据写入文件
                Param->bodylen = FRAMEL- Npad_Prefix;
            }
            else
            {
                    Param->body_start_point= 0;
                    Param->bodylen = FRAMEL;
            }

            wavwrite(Param);
		}
	
    }//end of looptime
    waveend();
    fclose(music_with_wm);
    fclose(WaveRdFp);
    free(inoise.data);
    free(bufferx.data);

    MessageBox(NULL,TEXT("Success!"),TEXT("Success"),MB_OK);
    return 1;*/

		

}


