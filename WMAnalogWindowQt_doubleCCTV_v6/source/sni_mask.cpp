#include "user.h"

double smrbin[384];
double px[384];
double SniG;
int    ASFmin;
int    ASFmax;

 void SniMask(double *sni,double *smr,double *sx,double *scf_bin)
 {
	
	for(int i=0;i<32;i++)
	{
		for(int j=0; j<12;j++)
		{
			if(pow(10,smr[i]/10.0)<1)		
				smrbin[i*12+j] =1;
            else
            {
                if ((i>ASFmin)&&(i<ASFmax))
                    smrbin[i*12+j]= SniG*pow(10,smr[i]/10.0);
                else
                    smrbin[i*12+j]= pow(10,smr[i]/10.0);
            }


			scf_bin[i*12+j] = (double)(Abs(sx[i*12+j]))/pow( (sni[i*12+j]*sni[i*12+j]+ESP)*smrbin[i*12+j],0.5);

			sni[i*12+j] = sni[i*12+j]* scf_bin[i*12+j];
		
		}
	
	}
 }
