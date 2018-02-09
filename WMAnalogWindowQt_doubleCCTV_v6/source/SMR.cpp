#include "user.h"

extern _DataStruct buffer[N];

void SMR(double *bufferptr,double *SMRdb,double *S,_table *Param)
{
	double Lsbn[32]={0.0};
	double LTminn[32]={0.0};
	double Scf[32] ={0.0};

	_DataStruct Data_in;
	_DataStruct *Xmax;
	_DataList SPL;

	Xmax = &buffer[2];

	for(int i=0; i<448; i++)
	{
		Data_in.subdata[i]= bufferptr[i];
	}

	Data_in.length = 448;	
		
	Cal_scf(&Data_in,Scf,S,Param);
				
	Cal_psd(&Data_in,Xmax,&SPL);

	Cal_Lsb(Xmax,Scf,Lsbn);

	Phycho_layerone(&SPL,LTminn,Param);

	Cal_Smrsb(Lsbn,LTminn,SMRdb);


}
