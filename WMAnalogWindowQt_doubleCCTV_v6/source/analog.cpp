#include "user.h"

extern WAVEFORMATEX  m_soundFormat;//声音格式
extern HWAVEIN       m_hWaveIn;//输入设备
extern WAVEHDR       m_pWaveHdrIn[BLOCK_COUNT];//采集音频时包含数据缓存的结构体
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

	memset(&m_soundFormat,0,sizeof(m_soundFormat));//设置声音格式
	m_soundFormat.wFormatTag = WAVE_FORMAT_PCM;//声音格式为PCM        
	m_soundFormat.nChannels = 2;    //采样声道数，对于单声道音频设置为1，立体声设置为2
	m_soundFormat.wBitsPerSample = 16;//采样比特  16bits/次
    if(SmpRate == 1)
        m_soundFormat.nSamplesPerSec = 48000; //采样率 96000 次/秒
    else if(SmpRate == 2)
        m_soundFormat.nSamplesPerSec = 44100;
    else
        m_soundFormat.nSamplesPerSec = 48000;
	m_soundFormat.nBlockAlign = m_soundFormat.nChannels * m_soundFormat.wBitsPerSample/8; //一个块的大小，采样bit的字节数乘以声道数
	m_soundFormat.nAvgBytesPerSec = m_soundFormat.nSamplesPerSec * m_soundFormat.nBlockAlign; //每秒的数据率，就是每秒能采集多少字节的数据
	m_soundFormat.cbSize = 0;//一般为0
	
	if (waveInOpen(&m_hWaveIn, WAVE_MAPPER, &m_soundFormat, (DWORD)(waveInProc), 0, CALLBACK_FUNCTION) !=0)
	{
		printf("open waveIn err!\n");
		exit(0);
	}
	unsigned int WavInDevsID;
	waveInGetID(m_hWaveIn,&WavInDevsID);//你所使用的输入设备ID，-1为默认输入设备
	printf("正在使用的输入设备ID:%d\n",WavInDevsID);
	//===================================out=========================================
	if(waveOutOpen(&m_hWaveOut, WAVE_MAPPER, &m_soundFormat, 0, 0, CALLBACK_FUNCTION ) != MMSYSERR_NOERROR)
	{
		printf("unable to open wave mapper device\n");
		ExitProcess(1);
	}
	unsigned int WavOutDevsID;
	waveOutGetID(m_hWaveOut,&WavOutDevsID);//你所使用的输入设备ID，-1为默认输入设备
	printf("正在使用的输入设备ID:%d\n",WavOutDevsID);
	//===================================end=========================================
	int i;
	for (i=0;i<BLOCK_COUNT;i++) //设置内存块格式
	{
		m_pWaveHdrIn[i].lpData=m_cBufferIn[i];
		m_pWaveHdrIn[i].dwBufferLength=MAX_BUFF_SOUNDSIZE;
		m_pWaveHdrIn[i].dwBytesRecorded=0;
		m_pWaveHdrIn[i].dwUser=i;
		m_pWaveHdrIn[i].dwFlags=0;
		waveInPrepareHeader(m_hWaveIn,&m_pWaveHdrIn[i],sizeof(WAVEHDR)); //准备内存块录音
		waveInAddBuffer(m_hWaveIn,&m_pWaveHdrIn[i],sizeof(WAVEHDR)); //增加内存块
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

