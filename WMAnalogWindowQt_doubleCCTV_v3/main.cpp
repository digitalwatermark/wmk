#include "mainwindow.h"
#include <QApplication>

#include "user.h"

_DataStruct buffer[N];
_SigInoiseStruct inoise;
_SigInoiseStruct bufferx;
_table *Param;
_State State_Switch;

double SigLwmk[FRAMEL];
double SigRwmk[FRAMEL];

double FrameL[FRAMEL];
double FrameR[FRAMEL];

double pntmp[FRAMEL];

double PNinput[FRAMEL];

bool   WMAdd;//是否添加水印
bool   EmbedOrDetect;//true时刻选Embed false时刻选Detect
bool   AnalogOrRead;//true时刻选Anolog false时刻选Readfile
bool   ThreadState;
float  nmr_gain;//功率
double plotx[FRAMEL];//绘图横坐标数据
double pny[FRAMEL];//绘图pn序列纵坐标数据
double musicy[FRAMEL];//绘图音频纵坐标数据
int    SmpRate;//采样率
FILE   *WaveRdFp;//输入音频文件指针
FILE   *music_with_wm;//输出音频文件指针
int    loopcount;//当前循环次数

double fSigLwmk[FRAMEL*FCNT];
double fSigRwmk[FRAMEL*FCNT];

int    one_pn_frame;//每个pn嵌入的帧数
char   *pnopenname_array[PN_NUM];
bool   ifisrunning;

//==========================================================================================================

WAVEFORMATEX  m_soundFormat;//声音格式
HWAVEIN       m_hWaveIn;//输入设备
WAVEHDR       m_pWaveHdrIn[BLOCK_COUNT];//采集音频时包含数据缓存的结构体
CHAR          m_cBufferIn[BLOCK_COUNT][MAX_BUFF_SOUNDSIZE];
bool		  IsRecord;//停止标志，因为这里在WIM_DATA 是不断AddBuff，要靠其它变量去控制，停止

//===================================
HWAVEOUT      m_hWaveOut;
WAVEHDR       m_pWaveHdrOut[BLOCK_COUNT];


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    //Param  = new _table;
    Param = (struct _table *)malloc(sizeof(struct _table));
    State_Switch.Sync_State = 0;
    sys_int(Param);

    ThreadState = false;
    IsRecord = false;
    WMAdd = false;
    EmbedOrDetect = true;//开启嵌入功能，false开启检出功能
    AnalogOrRead = false;//开启声卡读写，false开启文件读写模式
    nmr_gain = 3;
    one_pn_frame = 3;
    ifisrunning = false;

    return a.exec();
}
