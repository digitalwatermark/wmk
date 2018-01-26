#include "user.h"

extern  _State State_Switch;


void State_Switchini()
{
	
	State_Switch.Sync_State =1;
	State_Switch.Sync_pos = 0;
	State_Switch.Count_Acq = 0;


}