#define MAX_BUFF_SOUNDSIZE FRAMEL*4//8192个样点
#define BLOCK_COUNT 10

struct RIFF_HEADER
{
	char szRiffID[4];//'R','I','F','F'
	DWORD dwRiffSize;//总文件长度-8
	char szRiffFormat[4];//'W','A','V','E'
};


struct WAVE_FORMAT//16字节
{
	WORD    wFormatTag;        /* format type */
    WORD    nChannels;         /* number of channels (i.e. mono, stereo...) */
    DWORD   nSamplesPerSec;    /* sample rate */
    DWORD   nAvgBytesPerSec;   /* for buffer estimation */
    WORD    nBlockAlign;       /* block size of data */
    WORD    wBitsPerSample;    /* Number of bits per sample of mono data */
};

struct FMT_BLOCK
{
	char  szFmtID[4]; // 'f','m','t',' '
	DWORD  dwFmtSize;//WAVE格式所占字节16
	WAVE_FORMAT wavFormat;
 };
 
 
struct DATA_BLOCK
{
	char  szDataID[4]; // 'd','a','t','a'
	DWORD  dwDataSize;
};
