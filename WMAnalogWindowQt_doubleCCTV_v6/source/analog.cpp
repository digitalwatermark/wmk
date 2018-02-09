#include "user.h"

extern WAVEFORMATEX  m_soundFormat;//������ʽ
extern HWAVEIN       m_hWaveIn;//�����豸
extern WAVEHDR       m_pWaveHdrIn[BLOCK_COUNT];//�ɼ���Ƶʱ�������ݻ���Ľṹ��
extern CHAR			 m_cBufferIn[BLOCK_COUNT][MAX_BUFF_SOUNDSIZE];
extern bool			 IsRecord;
//===================================================
extern HWAVEOUT      m_hWaveOut;
extern WAVEHDR       m_pWaveHdrOut[BLOCK_COUNT];
//======================================================
extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

extern double       SigLwmk[FRAMEL];
extern double       SigRwmk[FRAMEL];

extern bool WMAdd;
extern    int       SmpRate;

void AnalogInit()
{
	int AnalogNum;

	AnalogNum = waveInGetNumDevs();
	if (AnalogNum<1)
	{
        MessageBox(NULL,TEXT("NO WAVE IN DEVS!"),TEXT("Waring"),MB_OK);
		exit(0);
	}

	memset(&m_soundFormat,0,sizeof(m_soundFormat));//����������ʽ
	m_soundFormat.wFormatTag = WAVE_FORMAT_PCM;//������ʽΪPCM        
	m_soundFormat.nChannels = 2;    //���������������ڵ�������Ƶ����Ϊ1������������Ϊ2
	m_soundFormat.wBitsPerSample = 16;//��������  16bits/��
    if(SmpRate == 1)
        m_soundFormat.nSamplesPerSec = 48000; //������ 96000 ��/��
    else if(SmpRate == 2)
        m_soundFormat.nSamplesPerSec = 44100;
    else
        m_soundFormat.nSamplesPerSec = 48000;
	m_soundFormat.nBlockAlign = m_soundFormat.nChannels * m_soundFormat.wBitsPerSample/8; //һ����Ĵ�С������bit���ֽ�������������
	m_soundFormat.nAvgBytesPerSec = m_soundFormat.nSamplesPerSec * m_soundFormat.nBlockAlign; //ÿ��������ʣ�����ÿ���ܲɼ������ֽڵ�����
	m_soundFormat.cbSize = 0;//һ��Ϊ0
	
	if (waveInOpen(&m_hWaveIn, WAVE_MAPPER, &m_soundFormat, (DWORD)(waveInProc), 0, CALLBACK_FUNCTION) !=0)
	{
		printf("open waveIn err!\n");
		exit(0);
	}
	unsigned int WavInDevsID;
	waveInGetID(m_hWaveIn,&WavInDevsID);//����ʹ�õ������豸ID��-1ΪĬ�������豸
	printf("����ʹ�õ������豸ID:%d\n",WavInDevsID);
	//===================================out=========================================
	if(waveOutOpen(&m_hWaveOut, WAVE_MAPPER, &m_soundFormat, 0, 0, CALLBACK_FUNCTION ) != MMSYSERR_NOERROR)
	{
		printf("unable to open wave mapper device\n");
		ExitProcess(1);
	}
	unsigned int WavOutDevsID;
	waveOutGetID(m_hWaveOut,&WavOutDevsID);//����ʹ�õ������豸ID��-1ΪĬ�������豸
	printf("����ʹ�õ������豸ID:%d\n",WavOutDevsID);
	//===================================end=========================================
	int i;
	for (i=0;i<BLOCK_COUNT;i++) //�����ڴ���ʽ
	{
		m_pWaveHdrIn[i].lpData=m_cBufferIn[i];
		m_pWaveHdrIn[i].dwBufferLength=MAX_BUFF_SOUNDSIZE;
		m_pWaveHdrIn[i].dwBytesRecorded=0;
		m_pWaveHdrIn[i].dwUser=i;
		m_pWaveHdrIn[i].dwFlags=0;
		waveInPrepareHeader(m_hWaveIn,&m_pWaveHdrIn[i],sizeof(WAVEHDR)); //׼���ڴ��¼��
		waveInAddBuffer(m_hWaveIn,&m_pWaveHdrIn[i],sizeof(WAVEHDR)); //�����ڴ��
		//===================================out=========================================
		m_pWaveHdrOut[i].lpData=m_cBufferIn[i];
		m_pWaveHdrOut[i].dwBufferLength=MAX_BUFF_SOUNDSIZE;
		m_pWaveHdrOut[i].dwBytesRecorded=0;
		m_pWaveHdrOut[i].dwUser=i;
		m_pWaveHdrOut[i].dwFlags=0;
        waveOutPrepareHeader(m_hWaveOut, &m_pWaveHdrOut[i], sizeof(WAVEHDR));
		//===================================end=========================================
	}

}


void AnalogData_swich(int BoxNum)
{
	int one,two,three,four;

	for(int i=0;i<FRAMEL;i++)
	{
		if(int(m_cBufferIn[BoxNum][i*4]) < 0) { one = int(m_cBufferIn[BoxNum][i*4]) + 256; } else { one = int(m_cBufferIn[BoxNum][i*4]); }
		if(int(m_cBufferIn[BoxNum][i*4+1]) < 0) { two = int(m_cBufferIn[BoxNum][i*4+1]) + 256; } else { two = int(m_cBufferIn[BoxNum][i*4+1]); }
		if(int(m_cBufferIn[BoxNum][i*4+2]) < 0) { three = int(m_cBufferIn[BoxNum][i*4+2]) + 256; } else { three = int(m_cBufferIn[BoxNum][i*4+2]); }
		if(int(m_cBufferIn[BoxNum][i*4+3]) < 0) { four = int(m_cBufferIn[BoxNum][i*4+3]) + 256; } else { four = int(m_cBufferIn[BoxNum][i*4+3]); }
        if(WMAdd == true)
        {
            FrameL[i] = double( short( two*256 + one ) )/32768;
            FrameR[i] = double( short( four*256 + three ) )/32768;
        }
        else if(WMAdd == false)
        {
            SigLwmk[i] = double( short( two*256 + one ) )/32768;
            SigRwmk[i] = double( short( four*256 + three ) )/32768;
        }
	 }
 }

