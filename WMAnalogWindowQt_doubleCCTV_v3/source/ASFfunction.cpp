#include "user.h"

//==================����int�ͱ����ȴ�С=================
double MAX(double a,double b)
{
	if(a >= b)
		return a;
	else
		return b;
}

double db_add(double a, double b)
{
	a = pow(10.0,a/10.0);
	b = pow(10.0,b/10.0);

return 10*log10(a+b);
}

double Abs(double a)
{
	double b;
	if(a>0)
		b =a;
	else
		b = -1*a;
return b;
}

