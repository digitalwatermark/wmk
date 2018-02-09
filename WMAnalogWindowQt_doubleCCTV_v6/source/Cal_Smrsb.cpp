#include "user.h"


void Cal_Smrsb(double *Lsbn,double *LTminn,double *SMRsb)
{
//	FILE *fp= fopen("./test\\SMR.txt","wt");
	
	for(int i=0; i<32; i++)
	{ 
		SMRsb[i] =Lsbn[i] -  LTminn[i];  

	//	fprintf(fp,"%f\n",SMRsb[i]);
	}
//	fclose(fp);


}