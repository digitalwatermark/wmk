#include "user.h"


extern double Rx_BufferL[FRAMEL*3];

extern Complex *fft_pn;



void linxcorr_fft(double *Rxpn)
{

		clock_t start, end;
	int NFFT = 2*FRAMEL;
	int Nout = 2*FRAMEL-1;
	double Xenger;
	int i;
	


	Complex *fft_data = (Complex*)malloc(NFFT*sizeof(Complex));

	Complex *XY = (Complex*)malloc(NFFT*sizeof(Complex));
	
//FILE *fp_pn = fopen("./test/fft_pn.txt","wb");
//FILE *fp_data = fopen("./test/fft_data.txt","wb");
     //Rx_BufferL = fft_data->real;
	

    for( i=0;i<16384;i++)
	{
		
	   if(i<FRAMEL)
	   {
	
					
		  fft_data[i].real =  Rx_BufferL[i];  
			
		  fft_data[i].image =  0;
			
	   }
	  else
	  {

		   fft_data[i].real =  0;
		   fft_data[i].image =  0;
		
	  }
	}
	

//fwrite(fft_pn,sizeof(double),2*NFFT,fp_pn);
//fwrite(fft_data,sizeof(double),2*NFFT,fp_data);

//fclose(fp_pn);
//fclose(fp_data);
	
	

	ifft_fft(fft_data,NFFT);

	for( i=0;i<NFFT;i++)
	{
		XY[i] = ComMul(fft_data[i],fft_pn[i]);
	
	}

	conj(XY,NFFT,1);

	ifft_fft(XY,NFFT);  //ifft之前要共轭，除NFFT才可恢复

	Xenger = Sig_Engergy(Rx_BufferL,FRAMEL);

	for(i=0;i<Nout;i++)
	{

		Rxpn[i] = sqrt(pow(XY[i].real/NFFT,2)+pow(XY[i].image/NFFT,2));

		Rxpn[i]  = Rxpn[i]/pow((FRAMEL*Xenger+ESP),0.5);
	
	}


free(fft_data);
free(XY);
}