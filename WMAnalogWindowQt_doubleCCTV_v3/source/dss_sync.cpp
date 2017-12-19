#include "user.h"


extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

extern double Rx_BufferL[FRAMEL*3];

extern _State State_Switch;

int State_Supported[3] = {0,1,2};

extern double PNinput[FRAMEL];

void dss_sync()
{
	if(State_Switch.Sync_State==0)
	{
		State_Switch.bufxlen = 0;
		State_Switch.Sync_State = 1;
		State_Switch.Count_Acq = 0;
		State_Switch.Count_Fail = 0;
		State_Switch.Max_Acqtime = 0;
		State_Switch.Max_Failtime = 0;
		State_Switch.Threshold = 0.047;
		State_Switch.Next_Start_Buffer_Index = 0;
	
	}
	else
	{
		 State_Switch.Current_Start_index = State_Switch.Next_Start_Buffer_Index;
		
		
		if(State_Switch.Sync_State==1)
		{
			State_Switch.Next_Start_Buffer_Index = 0;
			State_Switch.bufxlen = FRAMEL;
		}
		else
		{
			
			State_Switch.Next_Start_Buffer_Index = State_Switch.Current_Start_index;
			State_Switch.bufxlen = FRAMEL+State_Switch.Max_Sync_Jitter;
		}

		Complex *Rxpn = (Complex *)malloc((State_Switch.bufxlen + FRAMEL -1)*sizeof(Complex ));

		linxcorr_fft(Rxpn);

	
	}
	

}
