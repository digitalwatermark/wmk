#include "user.h"




double Sig_Engergy(double *data,int L)
{
double enger=0;
 for(int i=0;i<L;i++)
 {
	enger += data[i]*data[i];
 
 }


return enger;
}