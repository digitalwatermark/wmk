#include "user.h"



void table_init48(int mod_sel,_table *th_table)
{
	
	if (mod_sel)
	{
		th_table->index[0]=1;	th_table->index[1]=2;	th_table->index[2]=3;	th_table->index[3]=4;	
		th_table->index[4]=5;	th_table->index[5]=6;	th_table->index[6]=7;	th_table->index[7]=8;	
		th_table->index[8]=9;	th_table->index[9]=10;	th_table->index[10]=11;	th_table->index[11]=12;	
		th_table->index[12]=13;	th_table->index[13]=14;	th_table->index[14]=15;	th_table->index[15]=16;	
		th_table->index[16]=17;	th_table->index[17]=18;	th_table->index[18]=19;	th_table->index[19]=20;	
		th_table->index[20]=21;	th_table->index[21]=22;	th_table->index[22]=23;	th_table->index[23]=24;	
		th_table->index[24]=25;	th_table->index[25]=26;	th_table->index[26]=27;	th_table->index[27]=28;	
		th_table->index[28]=29;	th_table->index[29]=30;	th_table->index[30]=31;	th_table->index[31]=32;	
		th_table->index[32]=33;	th_table->index[33]=34;	th_table->index[34]=35;	th_table->index[35]=36;	
		th_table->index[36]=37;	th_table->index[37]=38;	th_table->index[38]=39;	th_table->index[39]=40;	
		th_table->index[40]=41;	th_table->index[41]=42;	th_table->index[42]=43;	th_table->index[43]=44;	
		th_table->index[44]=45;	th_table->index[45]=46;	th_table->index[46]=47;	th_table->index[47]=48;	
		th_table->index[48]=50;	th_table->index[49]=52;	th_table->index[50]=54;	th_table->index[51]=56;	
		th_table->index[52]=58;	th_table->index[53]=60;	th_table->index[54]=62;	th_table->index[55]=64;	
		th_table->index[56]=66;	th_table->index[57]=68;	th_table->index[58]=70;	th_table->index[59]=72;	
		th_table->index[60]=74;	th_table->index[61]=76;	th_table->index[62]=78;	th_table->index[63]=80;	
		th_table->index[64]=82;	th_table->index[65]=84;	th_table->index[66]=86;	th_table->index[67]=88;	
		th_table->index[68]=90;	th_table->index[69]=92;	th_table->index[70]=94;	th_table->index[71]=96;	
		th_table->index[72]=100;	th_table->index[73]=104;	th_table->index[74]=108;	th_table->index[75]=112;	
		th_table->index[76]=116;	th_table->index[77]=120;	th_table->index[78]=124;	th_table->index[79]=128;	
		th_table->index[80]=132;	th_table->index[81]=136;	th_table->index[82]=140;	th_table->index[83]=144;	
		th_table->index[84]=148;	th_table->index[85]=152;	th_table->index[86]=156;	th_table->index[87]=160;	
		th_table->index[88]=164;	th_table->index[89]=168;	th_table->index[90]=172;	th_table->index[91]=176;	
		th_table->index[92]=180;	th_table->index[93]=184;	th_table->index[94]=188;	th_table->index[95]=192;	
		th_table->index[96]=196;	th_table->index[97]=200;	th_table->index[98]=204;	th_table->index[99]=208;	
		th_table->index[100]=212;	th_table->index[101]=216;	

		//============================================bark===================================================================
		th_table->bark[0]=0.9250;	th_table->bark[1]=1.8420;	th_table->bark[2]=2.7420;	th_table->bark[3]=3.6180;	th_table->bark[4]=4.4630;	th_table->bark[5]=5.2720;	
		th_table->bark[6]=6.0410;	th_table->bark[7]=6.7700;	th_table->bark[8]=7.4570;	th_table->bark[9]=8.1030;	th_table->bark[10]=8.7080;	th_table->bark[11]=9.2750;	
		th_table->bark[12]=9.8050;	th_table->bark[13]=10.3010;	th_table->bark[14]=10.7650;	th_table->bark[15]=11.1990;	th_table->bark[16]=11.6060;	th_table->bark[17]=11.9880;	
		th_table->bark[18]=12.3470;	th_table->bark[19]=12.6840;	th_table->bark[20]=13.0020;	th_table->bark[21]=13.3020;	th_table->bark[22]=13.5860;	th_table->bark[23]=13.8550;	
		th_table->bark[24]=14.1110;	th_table->bark[25]=14.3540;	th_table->bark[26]=14.5850;	th_table->bark[27]=14.8070;	th_table->bark[28]=15.0180;	th_table->bark[29]=15.2210;	
		th_table->bark[30]=15.4150;	th_table->bark[31]=15.6020;	th_table->bark[32]=15.7830;	th_table->bark[33]=15.9560;	th_table->bark[34]=16.1240;	th_table->bark[35]=16.2870;	
		th_table->bark[36]=16.4450;	th_table->bark[37]=16.5980;	th_table->bark[38]=16.7460;	th_table->bark[39]=16.8910;	th_table->bark[40]=17.0320;	th_table->bark[41]=17.1690;	
		th_table->bark[42]=17.3030;	th_table->bark[43]=17.4340;	th_table->bark[44]=17.5630;	th_table->bark[45]=17.6880;	th_table->bark[46]=17.8110;	th_table->bark[47]=17.9320;	
		th_table->bark[48]=18.1660;	th_table->bark[49]=18.3920;	th_table->bark[50]=18.6110;	th_table->bark[51]=18.8230;	th_table->bark[52]=19.0280;	th_table->bark[53]=19.2260;	
		th_table->bark[54]=19.4190;	th_table->bark[55]=19.6060;	th_table->bark[56]=19.7880;	th_table->bark[57]=19.9640;	th_table->bark[58]=20.1350;	th_table->bark[59]=20.3000;	
		th_table->bark[60]=20.4610;	th_table->bark[61]=20.6160;	th_table->bark[62]=20.7660;	th_table->bark[63]=20.9120;	th_table->bark[64]=21.0520;	th_table->bark[65]=21.1880;	
		th_table->bark[66]=21.3180;	th_table->bark[67]=21.4400;	th_table->bark[68]=21.5670;	th_table->bark[69]=21.6840;	th_table->bark[70]=21.7970;	th_table->bark[71]=21.9060;	
		th_table->bark[72]=22.1130;	th_table->bark[73]=22.3040;	th_table->bark[74]=22.4820;	th_table->bark[75]=22.6460;	th_table->bark[76]=22.7990;	th_table->bark[77]=22.9410;	
		th_table->bark[78]=23.0720;	th_table->bark[79]=23.1950;	th_table->bark[80]=23.3090;	th_table->bark[81]=23.4150;	th_table->bark[82]=23.5150;	th_table->bark[83]=23.6070;	
		th_table->bark[84]=23.6940;	th_table->bark[85]=23.7750;	th_table->bark[86]=23.8520;	th_table->bark[87]=23.9230;	th_table->bark[88]=23.9910;	th_table->bark[89]=24.0540;	
		th_table->bark[90]=24.1140;	th_table->bark[91]=24.1710;	th_table->bark[92]=24.2240;	th_table->bark[93]=24.2750;	th_table->bark[94]=24.3220;	th_table->bark[95]=24.3680;	
		th_table->bark[96]=24.4110;	th_table->bark[97]=24.4520;	th_table->bark[98]=24.4910;	th_table->bark[99]=24.5280;	th_table->bark[100]=24.5640;th_table->bark[101]=24.5970;	
		//==============================================TLq====================================================================

		th_table->TLq[0]=24.170000; 	th_table->TLq[1]=13.870000;		th_table->TLq[2]=10.010000;		th_table->TLq[3]=7.940000;	
		th_table->TLq[4]=6.620000;		th_table->TLq[5]=5.700000;		th_table->TLq[6]=5.000000;		th_table->TLq[7]=4.450000;	
		th_table->TLq[8]=4.000000;		th_table->TLq[9]=3.610000;		th_table->TLq[10]=3.260000;		th_table->TLq[11]=2.930000;	
		th_table->TLq[12]=2.630000;		th_table->TLq[13]=2.320000;		th_table->TLq[14]=2.020000;		th_table->TLq[15]=1.710000;	
		th_table->TLq[16]=1.380000;		th_table->TLq[17]=1.040000;		th_table->TLq[18]=0.670000;		th_table->TLq[19]=0.290000;	
		th_table->TLq[20]=-0.110000;	th_table->TLq[21]=-0.540000;	th_table->TLq[22]=-0.970000;	th_table->TLq[23]=-1.430000;	
		th_table->TLq[24]=-1.880000;	th_table->TLq[25]=-2.340000;	th_table->TLq[26]=-2.790000;	th_table->TLq[27]=-3.220000;	
		th_table->TLq[28]=-3.620000;	th_table->TLq[29]=-3.980000;	th_table->TLq[30]=-4.300000;	th_table->TLq[31]=-4.570000;	
		th_table->TLq[32]=-4.770000;	th_table->TLq[33]=-4.910000;	th_table->TLq[34]=-4.980000;	th_table->TLq[35]=-4.970000;	
		th_table->TLq[36]=-4.900000;	th_table->TLq[37]=-4.760000;	th_table->TLq[38]=-4.550000;	th_table->TLq[39]=-4.290000;	
		th_table->TLq[40]=-3.990000;	th_table->TLq[41]=-3.640000;	th_table->TLq[42]=-3.260000;	th_table->TLq[43]=-2.860000;	
		th_table->TLq[44]=-2.450000;	th_table->TLq[45]=-2.040000;	th_table->TLq[46]=-1.630000;	th_table->TLq[47]=-1.240000;	
		th_table->TLq[48]=-0.510000;	th_table->TLq[49]=0.120000;		th_table->TLq[50]=0.640000;		th_table->TLq[51]=1.060000;	
		th_table->TLq[52]=1.390000;		th_table->TLq[53]=1.660000;		th_table->TLq[54]=1.880000;		th_table->TLq[55]=2.080000;	
		th_table->TLq[56]=2.270000;		th_table->TLq[57]=2.460000;		th_table->TLq[58]=2.650000;		th_table->TLq[59]=2.860000;	
		th_table->TLq[60]=3.090000;		th_table->TLq[61]=3.330000;		th_table->TLq[62]=3.600000;		th_table->TLq[63]=3.890000;	
		th_table->TLq[64]=4.200000;		th_table->TLq[65]=4.540000;		th_table->TLq[66]=4.910000;		th_table->TLq[67]=5.310000;	
		th_table->TLq[68]=5.730000;		th_table->TLq[69]=6.180000;		th_table->TLq[70]=6.670000;		th_table->TLq[71]=7.190000;	
		th_table->TLq[72]=8.330000;		th_table->TLq[73]=9.630000;		th_table->TLq[74]=11.080000;	th_table->TLq[75]=12.710000;	
		th_table->TLq[76]=14.530000;	th_table->TLq[77]=16.540000;	th_table->TLq[78]=18.770000;	th_table->TLq[79]=21.230000;	
		th_table->TLq[80]=23.940000;	th_table->TLq[81]=26.900000;	th_table->TLq[82]=30.140000;	th_table->TLq[83]=33.670000;	
		th_table->TLq[84]=37.510000;	th_table->TLq[85]=41.670000;	th_table->TLq[86]=46.170000;	th_table->TLq[87]=51.040000;	
		th_table->TLq[88]=56.290000;	th_table->TLq[89]=61.940000;	th_table->TLq[90]=68.000000;	th_table->TLq[91]=68.000000;	
		th_table->TLq[92]=68.000000;	th_table->TLq[93]=68.000000;	th_table->TLq[94]=68.000000;	th_table->TLq[95]=68.000000;	
		th_table->TLq[96]=68.000000;	th_table->TLq[97]=68.000000;	th_table->TLq[98]=68.000000;	th_table->TLq[99]=68.000000;	
		th_table->TLq[100]=68.000000;	th_table->TLq[101]=68.000000;	
		//==================================================================CB======================================================
		th_table->CB[0]=1;	    th_table->CB[1]=2;    	th_table->CB[2]=3;    	th_table->CB[3]=4;	    th_table->CB[4]=5;	    th_table->CB[5]=6;	
		th_table->CB[6]=7;    	th_table->CB[7]=9;	    th_table->CB[8]=10;	    th_table->CB[9]=12;	    th_table->CB[10]=14;	th_table->CB[11]=16;	
		th_table->CB[12]=19;	th_table->CB[13]=21;	th_table->CB[14]=25;	th_table->CB[15]=29;	th_table->CB[16]=35;	th_table->CB[17]=41;	
		th_table->CB[18]=49;	th_table->CB[19]=53;	th_table->CB[20]=58;	th_table->CB[21]=65;	th_table->CB[22]=73;	th_table->CB[23]=79;	
		th_table->CB[24]=89;	th_table->CB[25]=102;
		//==========================================================Map===========================================================
		th_table->Map[0]=0;		th_table->Map[1]=1;		th_table->Map[2]=2;		th_table->Map[3]=3;	
		th_table->Map[4]=4;		th_table->Map[5]=5;		th_table->Map[6]=6;		th_table->Map[7]=7;	
		th_table->Map[8]=8;		th_table->Map[9]=9;		th_table->Map[10]=10;	th_table->Map[11]=11;	
		th_table->Map[12]=12;	th_table->Map[13]=13;	th_table->Map[14]=14;	th_table->Map[15]=15;	
		th_table->Map[16]=16;	th_table->Map[17]=17;	th_table->Map[18]=18;	th_table->Map[19]=19;	
		th_table->Map[20]=20;	th_table->Map[21]=21;	th_table->Map[22]=22;	th_table->Map[23]=23;	
		th_table->Map[24]=24;	th_table->Map[25]=25;	th_table->Map[26]=26;	th_table->Map[27]=27;	
		th_table->Map[28]=28;	th_table->Map[29]=29;	th_table->Map[30]=30;	th_table->Map[31]=31;	
		th_table->Map[32]=32;	th_table->Map[33]=33;	th_table->Map[34]=34;	th_table->Map[35]=35;	
		th_table->Map[36]=36;	th_table->Map[37]=37;	th_table->Map[38]=38;	th_table->Map[39]=39;	
		th_table->Map[40]=40;	th_table->Map[41]=41;	th_table->Map[42]=42;	th_table->Map[43]=43;	
		th_table->Map[44]=44;	th_table->Map[45]=45;	th_table->Map[46]=46;	th_table->Map[47]=47;	
		th_table->Map[48]=48;	th_table->Map[49]=48;	th_table->Map[50]=49;	th_table->Map[51]=49;	
		th_table->Map[52]=50;	th_table->Map[53]=50;	th_table->Map[54]=51;	th_table->Map[55]=51;	
		th_table->Map[56]=52;	th_table->Map[57]=52;	th_table->Map[58]=53;	th_table->Map[59]=53;	
		th_table->Map[60]=54;	th_table->Map[61]=54;	th_table->Map[62]=55;	th_table->Map[63]=55;	
		th_table->Map[64]=56;	th_table->Map[65]=56;	th_table->Map[66]=57;	th_table->Map[67]=57;	
		th_table->Map[68]=58;	th_table->Map[69]=58;	th_table->Map[70]=59;	th_table->Map[71]=59;	
		th_table->Map[72]=60;	th_table->Map[73]=60;	th_table->Map[74]=61;	th_table->Map[75]=61;	
		th_table->Map[76]=62;	th_table->Map[77]=62;	th_table->Map[78]=63;	th_table->Map[79]=63;	
		th_table->Map[80]=64;	th_table->Map[81]=64;	th_table->Map[82]=65;	th_table->Map[83]=65;	
		th_table->Map[84]=66;	th_table->Map[85]=66;	th_table->Map[86]=67;	th_table->Map[87]=67;	
		th_table->Map[88]=68;	th_table->Map[89]=68;	th_table->Map[90]=69;	th_table->Map[91]=69;	
		th_table->Map[92]=70;	th_table->Map[93]=70;	th_table->Map[94]=71;	th_table->Map[95]=71;	
		th_table->Map[96]=72;	th_table->Map[97]=72;	th_table->Map[98]=72;	th_table->Map[99]=72;	
		th_table->Map[100]=73;	th_table->Map[101]=73;	th_table->Map[102]=73;	th_table->Map[103]=73;	
		th_table->Map[104]=74;	th_table->Map[105]=74;	th_table->Map[106]=74;	th_table->Map[107]=74;	
		th_table->Map[108]=75;	th_table->Map[109]=75;	th_table->Map[110]=75;	th_table->Map[111]=75;	
		th_table->Map[112]=76;	th_table->Map[113]=76;	th_table->Map[114]=76;	th_table->Map[115]=76;	
		th_table->Map[116]=77;	th_table->Map[117]=77;	th_table->Map[118]=77;	th_table->Map[119]=77;	
		th_table->Map[120]=78;	th_table->Map[121]=78;	th_table->Map[122]=78;	th_table->Map[123]=78;	
		th_table->Map[124]=79;	th_table->Map[125]=79;	th_table->Map[126]=79;	th_table->Map[127]=79;	
		th_table->Map[128]=80;	th_table->Map[129]=80;	th_table->Map[130]=80;	th_table->Map[131]=80;	
		th_table->Map[132]=81;	th_table->Map[133]=81;	th_table->Map[134]=81;	th_table->Map[135]=81;	
		th_table->Map[136]=82;	th_table->Map[137]=82;	th_table->Map[138]=82;	th_table->Map[139]=82;	
		th_table->Map[140]=83;	th_table->Map[141]=83;	th_table->Map[142]=83;	th_table->Map[143]=83;	
		th_table->Map[144]=84;	th_table->Map[145]=84;	th_table->Map[146]=84;	th_table->Map[147]=84;	
		th_table->Map[148]=85;	th_table->Map[149]=85;	th_table->Map[150]=85;	th_table->Map[151]=85;	
		th_table->Map[152]=86;	th_table->Map[153]=86;	th_table->Map[154]=86;	th_table->Map[155]=86;	
		th_table->Map[156]=87;	th_table->Map[157]=87;	th_table->Map[158]=87;	th_table->Map[159]=87;	
		th_table->Map[160]=88;	th_table->Map[161]=88;	th_table->Map[162]=88;	th_table->Map[163]=88;	
		th_table->Map[164]=89;	th_table->Map[165]=89;	th_table->Map[166]=89;	th_table->Map[167]=89;	
		th_table->Map[168]=90;	th_table->Map[169]=90;	th_table->Map[170]=90;	th_table->Map[171]=90;	
		th_table->Map[172]=91;	th_table->Map[173]=91;	th_table->Map[174]=91;	th_table->Map[175]=91;	
		th_table->Map[176]=92;	th_table->Map[177]=92;	th_table->Map[178]=92;	th_table->Map[179]=92;	
		th_table->Map[180]=93;	th_table->Map[181]=93;	th_table->Map[182]=93;	th_table->Map[183]=93;	
		th_table->Map[184]=94;	th_table->Map[185]=94;	th_table->Map[186]=94;	th_table->Map[187]=94;	
		th_table->Map[188]=95;	th_table->Map[189]=95;	th_table->Map[190]=95;	th_table->Map[191]=95;	
		th_table->Map[192]=96;	th_table->Map[193]=96;	th_table->Map[194]=96;	th_table->Map[195]=96;	
		th_table->Map[196]=97;	th_table->Map[197]=97;	th_table->Map[198]=97;	th_table->Map[199]=97;	
		th_table->Map[200]=98;	th_table->Map[201]=98;	th_table->Map[202]=98;	th_table->Map[203]=98;	
		th_table->Map[204]=99;	th_table->Map[205]=99;	th_table->Map[206]=99;	th_table->Map[207]=99;	
		th_table->Map[208]=100;	th_table->Map[209]=100;	th_table->Map[210]=100;	th_table->Map[211]=100;	
		th_table->Map[212]=101;	th_table->Map[213]=101;	th_table->Map[214]=101;	th_table->Map[215]=101;	
		th_table->Map[216]=101;	th_table->Map[217]=0;	th_table->Map[218]=0;	th_table->Map[219]=0;	
		th_table->Map[220]=0;	th_table->Map[221]=0;	th_table->Map[222]=0;	th_table->Map[223]=0;	
		th_table->Map[224]=0;	th_table->Map[225]=0;	th_table->Map[226]=0;	th_table->Map[227]=0;	
		th_table->Map[228]=0;	th_table->Map[229]=0;	th_table->Map[230]=0;	th_table->Map[231]=0;	
		th_table->Map[232]=0;	th_table->Map[233]=0;	th_table->Map[234]=0;	th_table->Map[235]=0;	
		th_table->Map[236]=0;	th_table->Map[237]=0;	th_table->Map[238]=0;	th_table->Map[239]=0;	
		th_table->Map[240]=0;	th_table->Map[241]=0;	th_table->Map[242]=0;	th_table->Map[243]=0;	
		th_table->Map[244]=0;	th_table->Map[245]=0;	th_table->Map[246]=0;	th_table->Map[247]=0;	
		th_table->Map[248]=0;	th_table->Map[249]=0;	th_table->Map[250]=0;	th_table->Map[251]=0;	
		th_table->Map[252]=0;	th_table->Map[253]=0;	th_table->Map[254]=0;	th_table->Map[255]=0;
	
	}
	else
	{
	
	}


}


