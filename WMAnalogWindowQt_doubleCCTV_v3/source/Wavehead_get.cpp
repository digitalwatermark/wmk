#include "user.h"

extern FILE *WaveRdFp;
extern FILE *music_with_wm; 
extern char *fileopenname;

void wavhead_get(_table *Param)//  ��ȡ������waveͷ�ļ�
{
	int i=0;
	int ch[4]={0};// ��������wav�ļ���ͷ��Ϣ
	long datasize = 0;
    char *fileclosename = 0;

    WaveRdFp = fopen(fileopenname,"rb");
    if(WaveRdFp == NULL)
        MessageBox(NULL,TEXT("can not open wav file!"),TEXT("Warning"),MB_OK);
    i = strlen(fileopenname)-4;
    fileclosename = (char *)malloc((i+12)*sizeof(char));
    strncpy(fileclosename,fileopenname,i);
    fileclosename[i] = '\0';
    sprintf(fileclosename,"%swithwm.wav",fileclosename);
    music_with_wm = fopen(fileclosename,"wb");
    free(fileclosename);

BT:	while(ch[0]!=100)
	{
		ch[0]=fgetc(WaveRdFp); //ÿ�ζ�ȡһ���ַ�������ch��
		fwrite(&(ch[0]),1,1,music_with_wm);
        fflush(music_with_wm);
	}
	ch[1]=fgetc(WaveRdFp);
	ch[2]=fgetc(WaveRdFp);
	ch[3]=fgetc(WaveRdFp);
	if(ch[1]==97 && ch[2]==116 && ch[3]==97)
	{
		fread(&datasize,4,1,WaveRdFp);	
	}

	if(ch[1]==97 && ch[2]==116 && ch[3]==97)// �������data�ֶ�
	{
		for(i=1;i<4;i++)// д��data
		{
			fwrite(&(ch[i]),1,1,music_with_wm);
            fflush(music_with_wm);
		}
	
		fwrite(&datasize,4,1,music_with_wm);
        fflush(music_with_wm);
	}
	else//��� ����data�ֶ�
	{
		for(i=1;i<4;i++)// д��data
		{
			fwrite(&(ch[i]),1,1,music_with_wm);
            fflush(music_with_wm);
		}
		ch[0]=fgetc(WaveRdFp);
		fwrite(&(ch[0]),1,1,music_with_wm);
        fflush(music_with_wm);
		goto BT;
	}

	Param->looptime = (datasize)/(FRAMEL*4);//������֡
	Param->last =(datasize - Param->looptime*FRAMEL*4)/2; //������֮֡�����µ�����������������short����
	
}
