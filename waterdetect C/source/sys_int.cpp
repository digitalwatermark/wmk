#include "user.h"

extern FILE   *WaveRdFp;             // 输入音频文件指针
extern FILE   *music_with_wm;  // 用于保存最后生成的携带水印的音频文件指针



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
	
	wavhead_get();			//抓取音频头




}