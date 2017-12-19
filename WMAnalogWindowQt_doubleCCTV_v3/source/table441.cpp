#include "user.h"

void table_init441(int mod_sel,_table *th_table)
{	
	if (mod_sel == 1)//44100
	{         
		//============================================index===================================================================
		th_table->index[0]=1;	th_table->index[1]=2;	th_table->index[2]=3;	th_table->index[3]=4;	th_table->index[4]=5;	th_table->index[5]=6;	
		th_table->index[6]=7;	th_table->index[7]=8;	th_table->index[8]=9;	th_table->index[9]=10;	th_table->index[10]=11;	th_table->index[11]=12;	
		th_table->index[12]=13;	th_table->index[13]=14;	th_table->index[14]=15;	th_table->index[15]=16;	th_table->index[16]=17;	th_table->index[17]=18;	
		th_table->index[18]=19;	th_table->index[19]=20;	th_table->index[20]=21;	th_table->index[21]=22;	th_table->index[22]=23;	th_table->index[23]=24;	
		th_table->index[24]=25;	th_table->index[25]=26;	th_table->index[26]=27;	th_table->index[27]=28;	th_table->index[28]=29;	th_table->index[29]=30;	
		th_table->index[30]=31;	th_table->index[31]=32;	th_table->index[32]=33;	th_table->index[33]=34;	th_table->index[34]=35;	th_table->index[35]=36;	
		th_table->index[36]=37;	th_table->index[37]=38;	th_table->index[38]=39;	th_table->index[39]=40;	th_table->index[40]=41;	th_table->index[41]=42;	
		th_table->index[42]=43;	th_table->index[43]=44;	th_table->index[44]=45;	th_table->index[45]=46;	th_table->index[46]=47;	th_table->index[47]=48;	
		th_table->index[48]=50;	th_table->index[49]=52;	th_table->index[50]=54;	th_table->index[51]=56;	th_table->index[52]=58;	th_table->index[53]=60;	
		th_table->index[54]=62;	th_table->index[55]=64;	th_table->index[56]=66;	th_table->index[57]=68;	th_table->index[58]=70;	th_table->index[59]=72;	
		th_table->index[60]=74;	th_table->index[61]=76;	th_table->index[62]=78;	th_table->index[63]=80;	th_table->index[64]=82;	th_table->index[65]=84;	
		th_table->index[66]=86;	th_table->index[67]=88;	th_table->index[68]=90;	th_table->index[69]=92;	th_table->index[70]=94;	th_table->index[71]=96;	
		th_table->index[72]=100;	th_table->index[73]=104;	th_table->index[74]=108;	th_table->index[75]=112;	th_table->index[76]=116;	th_table->index[77]=120;	
		th_table->index[78]=124;	th_table->index[79]=128;	th_table->index[80]=132;	th_table->index[81]=136;	th_table->index[82]=140;	th_table->index[83]=144;	
		th_table->index[84]=148;	th_table->index[85]=152;	th_table->index[86]=156;	th_table->index[87]=160;	th_table->index[88]=164;	th_table->index[89]=168;	
		th_table->index[90]=172;	th_table->index[91]=176;	th_table->index[92]=180;	th_table->index[93]=184;	th_table->index[94]=188;	th_table->index[95]=192;	
		th_table->index[96]=196;	th_table->index[97]=200;	th_table->index[98]=204;	th_table->index[99]=208;	th_table->index[100]=212;	th_table->index[101]=216;	
		th_table->index[102]=220;	th_table->index[103]=224;	th_table->index[104]=228;	th_table->index[105]=232;
		//============================================bark===================================================================
		th_table->bark[0]=0.8500;	th_table->bark[1]=1.6940;	th_table->bark[2]=2.5250;	th_table->bark[3]=3.3370;	th_table->bark[4]=4.1240;	th_table->bark[5]=4.8820;	
		th_table->bark[6]=5.6080;	th_table->bark[7]=6.3010;	th_table->bark[8]=6.9590;	th_table->bark[9]=7.5810;	th_table->bark[10]=8.1690;	th_table->bark[11]=8.7230;	
		th_table->bark[12]=9.2440;	th_table->bark[13]=9.7340;	th_table->bark[14]=10.1950;	th_table->bark[15]=10.6290;	th_table->bark[16]=11.0370;	th_table->bark[17]=11.4210;	
		th_table->bark[18]=11.7830;	th_table->bark[19]=12.1250;	th_table->bark[20]=12.4480;	th_table->bark[21]=12.7530;	th_table->bark[22]=13.0420;	th_table->bark[23]=13.3170;	
		th_table->bark[24]=13.5770;	th_table->bark[25]=13.8250;	th_table->bark[26]=14.0620;	th_table->bark[27]=14.2880;	th_table->bark[28]=14.5040;	th_table->bark[29]=14.7110;	
		th_table->bark[30]=14.9090;	th_table->bark[31]=15.1000;	th_table->bark[32]=15.2830;	th_table->bark[33]=15.4600;	th_table->bark[34]=15.6310;	th_table->bark[35]=15.7950;	
		th_table->bark[36]=15.9550;	th_table->bark[37]=16.1100;	th_table->bark[38]=16.2600;	th_table->bark[39]=16.4050;	th_table->bark[40]=16.5470;	th_table->bark[41]=16.6850;	
		th_table->bark[42]=16.8200;	th_table->bark[43]=16.9510;	th_table->bark[44]=17.0790;	th_table->bark[45]=17.2040;	th_table->bark[46]=17.3270;	th_table->bark[47]=17.4470;	
		th_table->bark[48]=17.6800;	th_table->bark[49]=17.9040;	th_table->bark[50]=18.1210;	th_table->bark[51]=18.3310;	th_table->bark[52]=18.5340;	th_table->bark[53]=18.7300;	
		th_table->bark[54]=18.9220;	th_table->bark[55]=19.1080;	th_table->bark[56]=19.2880;	th_table->bark[57]=19.4640;	th_table->bark[58]=19.6350;	th_table->bark[59]=19.8010;	
		th_table->bark[60]=19.9630;	th_table->bark[61]=20.1200;	th_table->bark[62]=20.2730;	th_table->bark[63]=20.4210;	th_table->bark[64]=20.5650;	th_table->bark[65]=20.7050;	
		th_table->bark[66]=20.8400;	th_table->bark[67]=20.9710;	th_table->bark[68]=21.0990;	th_table->bark[69]=21.2220;	th_table->bark[70]=21.3410;	th_table->bark[71]=21.4570;	
		th_table->bark[72]=21.6760;	th_table->bark[73]=21.8820;	th_table->bark[74]=22.0740;	th_table->bark[75]=22.2530;	th_table->bark[76]=22.4200;	th_table->bark[77]=22.5750;	
		th_table->bark[78]=22.7210;	th_table->bark[79]=22.8570;	th_table->bark[80]=22.9840;	th_table->bark[81]=23.1020;	th_table->bark[82]=23.2130;	th_table->bark[83]=23.3170;	
		th_table->bark[84]=23.4140;	th_table->bark[85]=23.5060;	th_table->bark[86]=23.5920;	th_table->bark[87]=23.6730;	th_table->bark[88]=23.7490;	th_table->bark[89]=23.8210;	
		th_table->bark[90]=23.8880;	th_table->bark[91]=23.9520;	th_table->bark[92]=24.0130;	th_table->bark[93]=24.0700;	th_table->bark[94]=24.1240;	th_table->bark[95]=24.1760;	
		th_table->bark[96]=24.2250;	th_table->bark[97]=24.2710;	th_table->bark[98]=24.3160;	th_table->bark[99]=24.3580;	th_table->bark[100]=24.3980;	th_table->bark[101]=24.4360;	
		th_table->bark[102]=24.4730;	th_table->bark[103]=24.5080;	th_table->bark[104]=24.5410;	th_table->bark[105]=24.5730;
		//============================================TLq===================================================================
		th_table->TLq[0]=13.870;	th_table->TLq[1]=2.850;	th_table->TLq[2]=-1.280;	th_table->TLq[3]=-3.500;	th_table->TLq[4]=-4.900;	th_table->TLq[5]=-5.890;	
		th_table->TLq[6]=-6.630;	th_table->TLq[7]=-7.210;	th_table->TLq[8]=-7.680;	th_table->TLq[9]=-8.080;	th_table->TLq[10]=-8.430;	th_table->TLq[11]=-8.750;	
		th_table->TLq[12]=-9.050;	th_table->TLq[13]=-9.330;	th_table->TLq[14]=-9.610;	th_table->TLq[15]=-9.890;	th_table->TLq[16]=-10.170;	th_table->TLq[17]=-10.470;	
		th_table->TLq[18]=-10.770;	th_table->TLq[19]=-11.100;	th_table->TLq[20]=-11.440;	th_table->TLq[21]=-11.790;	th_table->TLq[22]=-12.170;	th_table->TLq[23]=-12.560;	
		th_table->TLq[24]=-12.960;	th_table->TLq[25]=-13.380;	th_table->TLq[26]=-13.790;	th_table->TLq[27]=-14.210;	th_table->TLq[28]=-14.630;	th_table->TLq[29]=-15.030;	
		th_table->TLq[30]=-15.410;	th_table->TLq[31]=-15.770;	th_table->TLq[32]=-16.090;	th_table->TLq[33]=-16.370;	th_table->TLq[34]=-16.600;	th_table->TLq[35]=-16.780;	
		th_table->TLq[36]=-16.910;	th_table->TLq[37]=-16.970;	th_table->TLq[38]=-16.980;	th_table->TLq[39]=-16.920;	th_table->TLq[40]=-16.810;	th_table->TLq[41]=-16.650;	
		th_table->TLq[42]=-16.430;	th_table->TLq[43]=-16.170;	th_table->TLq[44]=-15.870;	th_table->TLq[45]=-15.540;	th_table->TLq[46]=-15.190;	th_table->TLq[47]=-14.820;	
		th_table->TLq[48]=-14.060;	th_table->TLq[49]=-13.320;	th_table->TLq[50]=-12.640;	th_table->TLq[51]=-12.040;	th_table->TLq[52]=-11.530;	th_table->TLq[53]=-11.110;	
		th_table->TLq[54]=-10.770;	th_table->TLq[55]=-10.490;	th_table->TLq[56]=-10.260;	th_table->TLq[57]=-10.070;	th_table->TLq[58]=-9.890;	th_table->TLq[59]=-9.720;	
		th_table->TLq[60]=-9.540;	th_table->TLq[61]=-9.370;	th_table->TLq[62]=-9.180;	th_table->TLq[63]=-8.970;	th_table->TLq[64]=-8.750;	th_table->TLq[65]=-8.510;	
		th_table->TLq[66]=-8.260;	th_table->TLq[67]=-7.980;	th_table->TLq[68]=-7.680;	th_table->TLq[69]=-7.360;	th_table->TLq[70]=-7.020;	th_table->TLq[71]=-6.650;	
		th_table->TLq[72]=-5.850;	th_table->TLq[73]=-4.930;	th_table->TLq[74]=-3.900;	th_table->TLq[75]=-2.750;	th_table->TLq[76]=-1.460;	th_table->TLq[77]=-0.030;	
		th_table->TLq[78]=1.560;	th_table->TLq[79]=3.310;	th_table->TLq[80]=5.230;	th_table->TLq[81]=7.340;	th_table->TLq[82]=9.640;	th_table->TLq[83]=12.150;	
		th_table->TLq[84]=14.880;	th_table->TLq[85]=17.840;	th_table->TLq[86]=21.050;	th_table->TLq[87]=24.520;	th_table->TLq[88]=28.250;	th_table->TLq[89]=32.270;	
		th_table->TLq[90]=36.590;	th_table->TLq[91]=41.220;	th_table->TLq[92]=46.180;	th_table->TLq[93]=51.490;	th_table->TLq[94]=56.000;	th_table->TLq[95]=56.000;	
		th_table->TLq[96]=56.000;	th_table->TLq[97]=56.000;	th_table->TLq[98]=56.000;	th_table->TLq[99]=56.000;	th_table->TLq[100]=56.000;	th_table->TLq[101]=56.000;	
		th_table->TLq[102]=56.000;	th_table->TLq[103]=56.000;	th_table->TLq[104]=56.000;	th_table->TLq[105]=56.000;
		//============================================CB===================================================================
		th_table->CB[0]=1;		th_table->CB[1]=2;		th_table->CB[2]=3;		th_table->CB[3]=5;		th_table->CB[4]=6;		th_table->CB[5]=8;	
		th_table->CB[6]=9;		th_table->CB[7]=11;		th_table->CB[8]=13;		th_table->CB[9]=15;		th_table->CB[10]=17;	th_table->CB[11]=20;	
		th_table->CB[12]=23;	th_table->CB[13]=27;	th_table->CB[14]=32;	th_table->CB[15]=37;	th_table->CB[16]=45;	th_table->CB[17]=50;	
		th_table->CB[18]=55;	th_table->CB[19]=61;	th_table->CB[20]=68;	th_table->CB[21]=75;	th_table->CB[22]=81;	th_table->CB[23]=93;	
		th_table->CB[24]=106;
		//============================================Map===================================================================
		th_table->Map[0]=1;		th_table->Map[1]=2;		th_table->Map[2]=3;		th_table->Map[3]=4;		th_table->Map[4]=5;		th_table->Map[5]=6;	
		th_table->Map[6]=7;		th_table->Map[7]=8;		th_table->Map[8]=9;		th_table->Map[9]=10;	th_table->Map[10]=11;	th_table->Map[11]=12;	
		th_table->Map[12]=13;	th_table->Map[13]=14;	th_table->Map[14]=15;	th_table->Map[15]=16;	th_table->Map[16]=17;	th_table->Map[17]=18;	
		th_table->Map[18]=19;	th_table->Map[19]=20;	th_table->Map[20]=21;	th_table->Map[21]=22;	th_table->Map[22]=23;	th_table->Map[23]=24;	
		th_table->Map[24]=25;	th_table->Map[25]=26;	th_table->Map[26]=27;	th_table->Map[27]=28;	th_table->Map[28]=29;	th_table->Map[29]=30;	
		th_table->Map[30]=31;	th_table->Map[31]=32;	th_table->Map[32]=33;	th_table->Map[33]=34;	th_table->Map[34]=35;	th_table->Map[35]=36;	
		th_table->Map[36]=37;	th_table->Map[37]=38;	th_table->Map[38]=39;	th_table->Map[39]=40;	th_table->Map[40]=41;	th_table->Map[41]=42;	
		th_table->Map[42]=43;	th_table->Map[43]=44;	th_table->Map[44]=45;	th_table->Map[45]=46;	th_table->Map[46]=47;	th_table->Map[47]=48;	
		th_table->Map[48]=48;	th_table->Map[49]=49;	th_table->Map[50]=49;	th_table->Map[51]=50;	th_table->Map[52]=50;	th_table->Map[53]=51;	
		th_table->Map[54]=51;	th_table->Map[55]=52;	th_table->Map[56]=52;	th_table->Map[57]=53;	th_table->Map[58]=53;	th_table->Map[59]=54;	
		th_table->Map[60]=54;	th_table->Map[61]=55;	th_table->Map[62]=55;	th_table->Map[63]=56;	th_table->Map[64]=56;	th_table->Map[65]=57;	
		th_table->Map[66]=57;	th_table->Map[67]=58;	th_table->Map[68]=58;	th_table->Map[69]=59;	th_table->Map[70]=59;	th_table->Map[71]=60;	
		th_table->Map[72]=60;	th_table->Map[73]=61;	th_table->Map[74]=61;	th_table->Map[75]=62;	th_table->Map[76]=62;	th_table->Map[77]=63;	
		th_table->Map[78]=63;	th_table->Map[79]=64;	th_table->Map[80]=64;	th_table->Map[81]=65;	th_table->Map[82]=65;	th_table->Map[83]=66;	
		th_table->Map[84]=66;	th_table->Map[85]=67;	th_table->Map[86]=67;	th_table->Map[87]=68;	th_table->Map[88]=68;	th_table->Map[89]=69;	
		th_table->Map[90]=69;	th_table->Map[91]=70;	th_table->Map[92]=70;	th_table->Map[93]=71;	th_table->Map[94]=71;	th_table->Map[95]=72;	
		th_table->Map[96]=72;	th_table->Map[97]=72;	th_table->Map[98]=72;	th_table->Map[99]=73;	th_table->Map[100]=73;	th_table->Map[101]=73;	
		th_table->Map[102]=73;	th_table->Map[103]=74;	th_table->Map[104]=74;	th_table->Map[105]=74;	th_table->Map[106]=74;	th_table->Map[107]=75;	
		th_table->Map[108]=75;	th_table->Map[109]=75;	th_table->Map[110]=75;	th_table->Map[111]=76;	th_table->Map[112]=76;	th_table->Map[113]=76;	
		th_table->Map[114]=76;	th_table->Map[115]=77;	th_table->Map[116]=77;	th_table->Map[117]=77;	th_table->Map[118]=77;	th_table->Map[119]=78;	
		th_table->Map[120]=78;	th_table->Map[121]=78;	th_table->Map[122]=78;	th_table->Map[123]=79;	th_table->Map[124]=79;	th_table->Map[125]=79;	
		th_table->Map[126]=79;	th_table->Map[127]=80;	th_table->Map[128]=80;	th_table->Map[129]=80;	th_table->Map[130]=80;	th_table->Map[131]=81;	
		th_table->Map[132]=81;	th_table->Map[133]=81;	th_table->Map[134]=81;	th_table->Map[135]=82;	th_table->Map[136]=82;	th_table->Map[137]=82;	
		th_table->Map[138]=82;	th_table->Map[139]=83;	th_table->Map[140]=83;	th_table->Map[141]=83;	th_table->Map[142]=83;	th_table->Map[143]=84;	
		th_table->Map[144]=84;	th_table->Map[145]=84;	th_table->Map[146]=84;	th_table->Map[147]=85;	th_table->Map[148]=85;	th_table->Map[149]=85;	
		th_table->Map[150]=85;	th_table->Map[151]=86;	th_table->Map[152]=86;	th_table->Map[153]=86;	th_table->Map[154]=86;	th_table->Map[155]=87;	
		th_table->Map[156]=87;	th_table->Map[157]=87;	th_table->Map[158]=87;	th_table->Map[159]=88;	th_table->Map[160]=88;	th_table->Map[161]=88;	
		th_table->Map[162]=88;	th_table->Map[163]=89;	th_table->Map[164]=89;	th_table->Map[165]=89;	th_table->Map[166]=89;	th_table->Map[167]=90;	
		th_table->Map[168]=90;	th_table->Map[169]=90;	th_table->Map[170]=90;	th_table->Map[171]=91;	th_table->Map[172]=91;	th_table->Map[173]=91;	
		th_table->Map[174]=91;	th_table->Map[175]=92;	th_table->Map[176]=92;	th_table->Map[177]=92;	th_table->Map[178]=92;	th_table->Map[179]=93;	
		th_table->Map[180]=93;	th_table->Map[181]=93;	th_table->Map[182]=93;	th_table->Map[183]=94;	th_table->Map[184]=94;	th_table->Map[185]=94;	
		th_table->Map[186]=94;	th_table->Map[187]=95;	th_table->Map[188]=95;	th_table->Map[189]=95;	th_table->Map[190]=95;	th_table->Map[191]=96;	
		th_table->Map[192]=96;	th_table->Map[193]=96;	th_table->Map[194]=96;	th_table->Map[195]=97;	th_table->Map[196]=97;	th_table->Map[197]=97;	
		th_table->Map[198]=97;	th_table->Map[199]=98;	th_table->Map[200]=98;	th_table->Map[201]=98;	th_table->Map[202]=98;	th_table->Map[203]=99;	
		th_table->Map[204]=99;	th_table->Map[205]=99;	th_table->Map[206]=99;	th_table->Map[207]=100;	th_table->Map[208]=100;	th_table->Map[209]=100;	
		th_table->Map[210]=100;	th_table->Map[211]=101;	th_table->Map[212]=101;	th_table->Map[213]=101;	th_table->Map[214]=101;	th_table->Map[215]=102;	
		th_table->Map[216]=102;	th_table->Map[217]=102;	th_table->Map[218]=102;	th_table->Map[219]=103;	th_table->Map[220]=103;	th_table->Map[221]=103;	
		th_table->Map[222]=103;	th_table->Map[223]=104;	th_table->Map[224]=104;	th_table->Map[225]=104;	th_table->Map[226]=104;	th_table->Map[227]=105;	
		th_table->Map[228]=105;	th_table->Map[229]=105;	th_table->Map[230]=105;	th_table->Map[231]=106;	th_table->Map[232]=106;	th_table->Map[233]=106;	
		th_table->Map[234]=106;	th_table->Map[235]=106;	th_table->Map[236]=106;	th_table->Map[237]=106;	th_table->Map[238]=106;	th_table->Map[239]=106;	
		th_table->Map[240]=106;	th_table->Map[241]=106;	th_table->Map[242]=106;	th_table->Map[243]=106;	th_table->Map[244]=106;	th_table->Map[245]=106;	
		th_table->Map[246]=106;	th_table->Map[247]=106;	th_table->Map[248]=106;	th_table->Map[249]=106;	th_table->Map[250]=106;	th_table->Map[251]=106;	
		th_table->Map[252]=106;	th_table->Map[253]=106;	th_table->Map[254]=106;	th_table->Map[255]=106;	
	}
	else
	{
	}
}
