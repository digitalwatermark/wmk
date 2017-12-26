#include "user.h"

//FILE *fp = fopen(".//testbench.txt","wt");

void Scale_factors(double *Scf,double *S)
{
	double si_min = 0;
	int i = 0;
	int j = 0;
	int x = 0;

	double inimax;

	for(x=0; x<32; x++)
	{
		si_min =fabs(S[x*12]);
		
		for(i=0; i<11; i++)
		{
			if ( si_min <fabs( S[x*12+i+1]) )
				si_min =fabs(S[x*12+i+1]);
		}
		//printf("\n\n%lf\n\n",si_min);
		if(si_min > Table_scf[0])
		{
			Scf[x] = Table_scf[0];
		}
		else
		{
		 inimax = Table_scf[62];
		//	while(j < n && si_min > Table_scf[n-j])
			for (j=62;j>=0;j--)
			{
			//	if( si_min>Table_scf[j])
				if( si_min > inimax )
				//	Scf[x] = Table_scf[j-1];
				inimax = Table_scf[j-1];
				else
				Scf[x]=	inimax;

			//	fprintf(fp,"%4f\n",Scf[x]);
			
			}
			
			//printf("%lf\n",Table_scf[n-j]);
				
		}
	//	fprintf(fp,"%f\n",Scf[x]);
	}

}
