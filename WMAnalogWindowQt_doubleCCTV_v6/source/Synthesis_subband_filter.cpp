#include "user.h"
	

double Sssf[32][12];
double Nssf[64][32];
double U[512] ;
double W[512] ;
double So[32] ;
double V[1024];

void Synthesis_subband_filter(double *sni,double *sno)
{
	int Ns = 12;
	int i=0;
	int j=0;


    for(i=0; i<32; i++)
	{
		for(j=0; j<12; j++)
		{
			Sssf[i][j] = sni[i*12+j];
		}
	}

	for(i=0; i<64; i++)
	{
		for(j=0; j<32; j++)
		{
			Nssf[i][j] = cos((16+i)*(2*j+1)*pi/64);
		}
	}

	for(int n=0; n<Ns; n++)
	{
		for(i=1023; i>63; i--)
		{
			V[i] = V[i-64];
		}
		for(i=0; i<64; i++)
		{
			V[i]=0;
		    for(j=0; j<32; j++)
			{
				V[i] = V[i] + Nssf[i][j] * Sssf[j][n];
			}
		}

		for(i=0; i<8; i++)
		{
			for(j=0; j<32; j++)
			{
				U[i*64+j]=V[i*128+j];
				U[i*64+32+j]=V[i*128+96+j];
			}
		}

		for(i=0; i<512; i++)
		{
			W[i] = U[i]*D[i];
		}

		for(j=0; j<32; j++)
		{
			So[j]=0;
			for(i=0; i<16; i++)
			{
				So[j] = So[j]+W[j+32*i];
			}
		}
		
	//	for(i=n*32; i<(n+1)*32-1; i++)
		for(i=0; i<32; i++)
		{
			sno[i+n*32] = So[i];
		}

	}


}
