#include "user.h"

double SigBufL[FRAMEL+Npad_Prefix+Npad_Prefix];

double SigBufR[FRAMEL+Npad_Prefix+Npad_Prefix];

extern    bool      AnalogOrRead;

void wmk_gen(_table *Param)
{
    if(!AnalogOrRead)
    {
        data_convert();
    }

	frame_perfix();					//ÕûÊý±¶·ÖÖ¡
		
	noise_masking(Param);

}
