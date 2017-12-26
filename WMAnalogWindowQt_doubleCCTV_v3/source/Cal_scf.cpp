#include "user.h"




void Cal_scf(_DataStruct *data,double *Scf,double *S,_table *Param)
{
	//===========32×Ó´øÂË²¨Æ÷===============
	
	Analysis_subband_filter(S,data,Param);

	Scale_factors(Scf,S);
	

}
