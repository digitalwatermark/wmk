#include "user.h"

extern HWAVEIN      m_hWaveIn;//�����豸
extern CHAR			m_cBufferIn[BLOCK_COUNT][MAX_BUFF_SOUNDSIZE];
extern bool			IsRecord;
//===================================
extern HWAVEOUT     m_hWaveOut;
extern WAVEHDR      m_pWaveHdrOut[BLOCK_COUNT];
//================================================
extern	_table	*Param;

extern  bool   WMAdd;
extern  bool   EmbedOrDetect;

DWORD CALLBACK waveInProc(HWAVEIN hwi, UINT uMsg, DWORD dwInstance, DWORD dwParam1, DWORD dwParam2)
{
	if (uMsg==WIM_DATA)
	{
        WAVEHDR*p=(WAVEHDR*)dwParam1;//dwParam1ָ��WAVEHDR�ĵ�ַ

		int BoxNum=p->dwUser;
		if (!IsRecord) //0��ʾֹͣ��
		{
			waveInUnprepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //�ͷŻ�����
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
                    wmk_gen(Param);
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

			waveInUnprepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //�ͷŻ�����
//=========================psy_top end=========================================
		}
		p->lpData=m_cBufferIn[BoxNum];
		p->dwBufferLength=MAX_BUFF_SOUNDSIZE;
		p->dwBytesRecorded=0;
		p->dwUser=BoxNum;
		p->dwFlags=0;
		waveInPrepareHeader(m_hWaveIn,p,sizeof(WAVEHDR)); //׼���ڴ��¼��
		waveInAddBuffer(m_hWaveIn,p,sizeof(WAVEHDR)); //�����ڴ��
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
