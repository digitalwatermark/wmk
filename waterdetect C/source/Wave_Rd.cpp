#include "user.h"

extern FILE *WaveRdFp;
char musicname[80]; 
void Wave_Rd()
{
	
	static 	char fileopenname[89];
	
	printf("���ԡ���Ů�����С���ʽ����Ҫ����ˮӡǶ�봦����ļ����ƣ�");
	scanf("%s",musicname);
	sprintf(fileopenname,".\\\\test\\\\%s.wav",musicname);
	WaveRdFp=fopen(fileopenname,"rb");   

	if(WaveRdFp==NULL) 
    {
        printf("�޷�����ƵԴ�ļ���\n");
        exit(0);
    }

}