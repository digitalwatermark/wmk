#include "user.h"

extern HWAVEIN      m_hWaveIn;//输入设备
extern CHAR			m_cBufferIn[BLOCK_COUNT][MAX_BUFF_SOUNDSIZE];
extern bool			IsRecord;
//===================================
extern HWAVEOUT     m_hWaveOut;
extern WAVEHDR      m_pWaveHdrOut[BLOCK_COUNT];
//================================================
extern	_table	*Param;

extern  bool   WMAdd;
extern  bool   EmbedOrDetect;
extern    _SigInoiseStruct inoise;
extern  int       *input_txt_int;
extern  int    input_lenght;
extern  int    one_pn_frame;
extern  int    analog_loopcount;
extern    char      *pnopenname;
extern    char      *pnopenname_array[PN_NUM];


volatile bool threadStarted = false;

void __cdecl WmkGenFunc( LPVOID )
{
    if(threadStarted)
    {
        if(analog_loopcount == (input_lenght+1)*one_pn_frame)
        {
            analog_loopcount=0;
            pnopenname = pnopenname_array[input_txt_int[analog_loopcount/one_pn_frame]];
            PnGen(inoise);
        }
        else
        {
            pnopenname = pnopenname_array[input_txt_int[analog_loopcount/one_pn_frame]];
            PnGen(inoise);
        }
        wmk_gen(Param);

    }
    analog_loopcount++;
    threadStarted = false;
}


DWORD CALLBACK waveInProc(HWAVEIN hwi, UINT uMsg, DWORD dwInstance, DWORD dwParam1, DWORD dwParam2)
{
	if (uMsg==WIM_DATA)
	{
        WAVEHDR*p=(WAVEHDR*)dwParam1;//dwParam1指向WAVEHDR的地址

		int BoxNum=p->dwUser;
		if (!IsRecord) //0表示停止了
		{
			waveInUnprepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //释放缓冲区
			return 0;
		}
		else
		{
//=========================psy_top=========================================
			AnalogData_swich(BoxNum);
            //if(EmbedOrDetect == true)
            //{
                if(WMAdd == true)
                {
                    if(!threadStarted)
                    {
                        threadStarted = true;
                        _beginthread( WmkGenFunc, 0, 0 );
                    }
                }
                else if(WMAdd == false)
                {}
            //}
            //else if(EmbedOrDetect == false)
            //{
                //Detect()
            //}

            //printf("%d\n", clock());

            AnalogOutDataWrite(BoxNum);

			waveOutPrepareHeader(m_hWaveOut, &m_pWaveHdrOut[BoxNum], sizeof(WAVEHDR));
			waveOutWrite(m_hWaveOut, &m_pWaveHdrOut[BoxNum], sizeof(WAVEHDR));

			waveInUnprepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //释放缓冲区
//=========================psy_top end=========================================
		}
		p->lpData=m_cBufferIn[BoxNum];
		p->dwBufferLength=MAX_BUFF_SOUNDSIZE;
		p->dwBytesRecorded=0;
		p->dwUser=BoxNum;
		p->dwFlags=0;
		waveInPrepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //准备内存块录音
		waveInAddBuffer(m_hWaveIn,p,sizeof(WAVEHDR)); //增加内存块
	}
	if (uMsg==WIM_OPEN)
	{
		printf("open\n");
	}
	if (uMsg==WIM_CLOSE)
	{
		printf("close\n");
	}
	return 0;
}
