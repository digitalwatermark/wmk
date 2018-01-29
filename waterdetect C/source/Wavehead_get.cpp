#include "user.h"




extern FILE *WaveRdFp;

extern long wav_start_position;

void wavhead_get()//  读取并保存wave头文件
{
	int i=0;
	int ch[4]={0};// 用来缓存wav文件的头信息
	long datasize = 0;

	while(ch[0]!=100)
	{
		ch[0]=fgetc(WaveRdFp); //每次读取一个字符，存在ch中

	}
	ch[1]=fgetc(WaveRdFp);
	ch[2]=fgetc(WaveRdFp);
	ch[3]=fgetc(WaveRdFp);
	if(ch[1]==97 && ch[2]==116 && ch[3]==97)
	{
		fread(&datasize,4,1,WaveRdFp);	
		wav_start_position = ftell(WaveRdFp);
	}


}