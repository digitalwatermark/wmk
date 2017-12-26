#include "user.h"


extern _State State_Switch;

extern  _SigInoiseStruct inoise;

extern double FrameL[FRAMEL];
extern double FrameR[FRAMEL];

double Rx_BufferL[FRAMEL*3];

double Rx_BufferR[FRAMEL*3];

extern double PNinput[FRAMEL];


void wmk_extrac()
{

	process_acquireddata();

}
