#include "user.h"

extern FILE *WaveRdFp;
char musicname[80]; 
void Wave_Rd()
{
	
	static 	char fileopenname[89];
	
	printf("请以“男女生朗诵”格式输入要进行水印嵌入处理的文件名称：");
	scanf("%s",musicname);
	sprintf(fileopenname,".\\\\test\\\\%s.wav",musicname);
	WaveRdFp=fopen(fileopenname,"rb");   

	if(WaveRdFp==NULL) 
    {
        printf("无法打开音频源文件。\n");
        exit(0);
    }

}