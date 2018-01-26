#include "user.h"


  _State State_Switch;

FILE   *WaveRdFp;

short musicdataL[FRAMEL];

short musicdataR[FRAMEL];

short musicdata[FRAMEL*2];

double FrameL[FRAMEL];

double FrameR[FRAMEL];

double PNinput[FRAMEL];
 
int successcount;

Complex *fft_pn = (Complex*)malloc(16384*sizeof(Complex));

void main()
{
	int count=0;
	int i;
	successcount = 0;

	FILE *PnSe = fopen(".\\test/pn°ü/pn2.txt","rb");
	fread(PNinput,sizeof(double),FRAMEL,PnSe);

	fclose(PnSe);
	
	sys_int();

	State_Switchini();
		

	while(1)
	{

		if(!(feof(WaveRdFp)))
		{
			fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);
					
			for(int j=0; j<FRAMEL;j++)
			{
				musicdataL[j] = musicdata[2*j];
				musicdataR[j] = musicdata[2*j+1];
			}
			for(i=1; i<OVERTIME; i++)
			{
				fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);
					
				for(int j=0; j<FRAMEL;j++)
				{
					musicdataL[j] = musicdataL[j] + musicdata[2*j];
					musicdataR[j] = musicdataR[j] + musicdata[2*j+1];
				}
			}

	

		}
		else
		{
			fseek(WaveRdFp,44L,0);
			successcount=0;
	
			printf("**********wave_wave_wave_again*******************\n");
			printf("wavereadcnt = %d\n",count++);
			fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);
				
			for(int j=0; j<FRAMEL;j++)
			{
				musicdataL[j] = musicdata[2*j];
				musicdataR[j] = musicdata[2*j+1];

			}
			for(i=1; i<OVERTIME; i++)
			{
				fread(musicdata,sizeof(short),FRAMEL*2,WaveRdFp);
					
				for(int j=0; j<FRAMEL;j++)
				{
					musicdataL[j] = musicdataL[j] + musicdata[2*j];
					musicdataR[j] = musicdataR[j] + musicdata[2*j+1];
				}
			}
			
		}

				

		wmk_extrac();

	
	}
//fclose(fpmusicL);
//fclose(fpmusicR);
		

}


