#include "user.h"

void Phycho_layerone(_DataList *SPL, double *LTminn,_table *Param)
{
	_DataStruct LTg;

	Finding_tonal_component(SPL,Param);

	Finding_Ntonal_component(SPL,Param);

	Tonal_Ntonal_decimate(SPL,Param );

	Cal_T_N_mask(SPL, &LTg,Param);

	Minimum_masking_threshold(&LTg,LTminn,Param);

}
