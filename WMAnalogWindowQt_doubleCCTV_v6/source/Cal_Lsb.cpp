#include "user.h"

void Cal_Lsb(_DataStruct *Xmax,double *scf,double *Lsb)
{

	for (int i=0; i<Xmax->length ;i++)
	{
	
	
		if( Xmax->subdata[i] > (20*log10(scf[i]*32768)-10) )
		{
			Lsb[i] = Xmax->subdata[i];

		}
		else
		{
			Lsb[i] = (20*log10(scf[i]*32768)-10);
		}
	
	}

}