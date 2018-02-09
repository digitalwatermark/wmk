#include "user.h"

extern double Rx_BufferL[FRAMEL*3];

extern double Rx_BufferR[FRAMEL*3];

extern double FrameL[FRAMEL];

extern double FrameR[FRAMEL];

extern _State State_Switch;

extern double PNinput[FRAMEL];

void process_acquireddata()
{
	for(int i=0;i<FRAMEL;i++)
	{
		Rx_BufferL[i] = Rx_BufferL[FRAMEL+i];

		Rx_BufferL[i+FRAMEL] = Rx_BufferL[2*FRAMEL+i];

		Rx_BufferL[2*FRAMEL+i] = FrameL[i];

		Rx_BufferR[i] = Rx_BufferR[FRAMEL+i];

		Rx_BufferR[i+FRAMEL] = Rx_BufferR[2*FRAMEL+i];

		Rx_BufferR[2*FRAMEL+i] = FrameR[i];
	
	}

	dss_sync();
	


}
