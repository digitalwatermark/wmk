#include "user.h"


extern double Rx_BufferL[FRAMEL*3];
extern _State State_Switch;

extern double PNinput[FRAMEL];



void linxcorr_fft(Complex *Rxpn)
{
	
	int Nout = State_Switch.bufxlen + FRAMEL -1;

	int NFFT =(int)pow(2, (int)(log10(Nout)/log10(2)+1));

	double *pointx;

    int i=0;

	if(State_Switch.Sync_State==1)
	{
		pointx = Rx_BufferL;
	}
	else if(State_Switch.Sync_State==2)
	{
	
		pointx = Rx_BufferL+ State_Switch.Current_Start_index+FRAMEL-1+State_Switch.Max_Sync_Jitter;
	}
	
	Complex *fft_pn = (Complex*)malloc(NFFT*sizeof(Complex));

	Complex *fft_data = (Complex*)malloc(NFFT*sizeof(Complex));

	Complex *XY = (Complex*)malloc(NFFT*sizeof(Complex));



	double RxEngergy= Sig_Engergy(pointx,State_Switch.bufxlen);
		
    for(i=0;i<NFFT;i++)
	{
		if (i<FRAMEL)
		{
			fft_pn[i].real  = PNinput[FRAMEL-i-1];
			fft_pn[i].image = 0;
		
			fft_data[i].real =  pointx[i];  //此处需要解其意
			fft_data[i].image =  0;
			
		}
		else
		{
			fft_pn[i].real = 0;
			fft_pn[i].image = 0;

			fft_data[i].real =  0;
			fft_data[i].image =  0;
		
		}
	}
	
	ifft_fft(fft_pn,NFFT);

	ifft_fft(fft_data,NFFT);

	for( i=0;i<NFFT;i++)
	{
		XY[i] = ComMul(fft_data[i],fft_pn[i]);
	
	}

	conj(XY,NFFT,1);

	ifft_fft(XY,NFFT);

	for(i=0;i<Nout;i++)
	{
		Rxpn[i].real = XY[i].real/(RxEngergy+ESP);
		Rxpn[i].image = XY[i].image/(RxEngergy+ESP);
	
	}


	free(fft_pn);
	free(fft_data);
	free(XY);


}
