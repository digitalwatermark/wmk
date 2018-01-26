#include "user.h"


extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

extern double Rx_BufferL[FRAMEL*3];

double Rxpn_AbsShiftAdd[FRAMEL];

double Rxpn[2*FRAMEL-1];

extern _State State_Switch;




extern Complex *fft_pn;

void dss_sync()
{

//	clock_t start, end;


	double Max_Rxpn_AbsShiftAdd;
	int Sync_pos;
	int Count_Acq;
	int last_sync_pos;
	int Sync_State;
	double Threshold = 0.047;

     _corrstr corrvalue;


	last_sync_pos = State_Switch.Sync_pos;

	Count_Acq = State_Switch.Count_Acq;

	
	//只有捕获状态
//	start = clock();

	linxcorr_fft(Rxpn);

//	end = clock();
	
//	printf("The time was: %f\n", (double)(end-start)/1000 ); 

	Rxpn_AbsShiftAdd[FRAMEL-1] = Rxpn[FRAMEL-1];
	
		for(int i=0; i<FRAMEL-1;i++)
		{
			Rxpn_AbsShiftAdd[i] = Rxpn[i]+Rxpn[FRAMEL+i];

		}

		corrvalue = array_max(Rxpn_AbsShiftAdd,FRAMEL-1);
	

		Sync_pos = corrvalue.positon;

		Max_Rxpn_AbsShiftAdd = corrvalue.maxvalue;

			
		if( Max_Rxpn_AbsShiftAdd<Threshold )
		{
				Count_Acq = 0;

				Sync_pos =0;

				Sync_State =1;
			
		}
		else if(State_Switch.Count_Acq==0)
		{
				Count_Acq=1 ;

				Sync_State = 1;
		}
		else 
			
	if( (min( abs(Sync_pos-last_sync_pos-FRAMEL) ,min(  abs(Sync_pos-last_sync_pos+FRAMEL), abs(Sync_pos-last_sync_pos) ))) > Max_Sync_Jitter )//门限超过假同步识别
			{
					
				Count_Acq = 0;

				Sync_pos =0;

			    Sync_State = 1;
					  
			}
			
		else if(State_Switch.Count_Acq == Max_Acqtime-1)
			{
					Count_Acq = Max_Acqtime;

				    Sync_State=2;
							//printf("Max_Rxpn_AbsShiftAdd=%3f\n",Max_Rxpn_AbsShiftAdd);

					

			}
			
		else
		{
				Count_Acq = Count_Acq+1;

				Sync_State = 1;
			
		}

	
	

	State_Switch.Sync_State = Sync_State;
	State_Switch.Sync_pos = Sync_pos;
	State_Switch.Count_Acq = Count_Acq;
	State_Switch.Max_Rxpn_AbsShiftAdd = Max_Rxpn_AbsShiftAdd;
//	printf("Count_Acq = %d\n",Count_Acq);
	


}