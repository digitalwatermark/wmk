#include "user.h"

extern FILE   *WaveRdFp;             // ������Ƶ�ļ�ָ��
extern FILE   *music_with_wm;  // ���ڱ���������ɵ�Я��ˮӡ����Ƶ�ļ�ָ��



extern double PNinput[FRAMEL];

extern Complex *fft_pn;

void sys_int()
{

		

 for(int  i=0;i<16384;i++)
	{
		
	   if(i<FRAMEL)
	   {
				
		  fft_pn[i].real  = PNinput[FRAMEL-i-1];
				
		  fft_pn[i].image = 0;
	
			
	   }
	  else
	  {
		   fft_pn[i].real = 0;
		   fft_pn[i].image = 0;
		
	  }
	}

    ifft_fft(fft_pn,16384);
	
	Wave_Rd();	
	
	wavhead_get();			//ץȡ��Ƶͷ




}