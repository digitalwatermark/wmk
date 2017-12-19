
#include "user.h"

extern FILE *WaveRdFp;

extern FILE   *music_with_wm;


void waveend()
{
	char finaltemp;
	while(!feof(WaveRdFp))
	{
		finaltemp=fgetc(WaveRdFp);
		fwrite(&(finaltemp),1,1,music_with_wm);
	//	fflush(music_with_wm);
	
	}


}
