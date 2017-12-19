#include "user.h"




double Sig_Engergy(double *data,int L)
{
double enger;
 for(int i=1;i<L;i++)
 {
	enger += data[i]*data[i];
 
 }


return enger;
}