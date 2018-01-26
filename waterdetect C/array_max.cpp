#include "user.h"


_corrstr array_max(double *array,int L)
{
_corrstr maxvalue;
double valueint = array[0];
int maxpos=0;
	
  for(int i=1;i<L;i++)
  {
	if (array[i] > valueint)
	{
		valueint = array[i] ;

		maxpos = i;
	}
		
	else
	{
		valueint = valueint;

		maxpos =maxpos;
	}

  
  }

maxvalue.maxvalue = valueint;

maxvalue.positon = maxpos;

	return maxvalue;
}