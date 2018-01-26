#include "user.h"

extern FILE   *WaveRdFp;

extern _State State_Switch;



extern short musicdataL[FRAMEL];
extern short musicdataR[FRAMEL];

extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

double Rx_BufferL[FRAMEL*3];

double Rx_BufferR[FRAMEL*3];

extern double PNinput[FRAMEL];

//	clock_t start, end;

//FILE * fpdecteframe = fopen("./test/frameinfor.txt","wt");

void wmk_extrac()
{
	
	

		
	data_convert();

	
	if (State_Switch.Sync_State==1)
	{		
	//	start = clock();  //此处为检测开始的时间点
		
		process_acquireddata();
	}
	else
		
		if(State_Switch.Sync_State==2)
		{		
			
		//	end = clock();
	
	     //   printf("The time was: %f\n", (double)(end-start)/1000 ); //此处为检测结束的时间点win下为31ms
			
			printf("http//:www.taobao.com\n");

			State_Switch.Sync_State=1;
			
		}

}