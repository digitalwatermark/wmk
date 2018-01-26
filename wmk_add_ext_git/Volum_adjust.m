


function [waveout]=Volum_adjust(acqdata)



  
  

%     if(-98<vol && vol<0)
%         vol = 1/(vol*(-1));
%     else if(0<=vol && vol<=1)
%         vol = 1;
%     else if(vol<=-98)
%         vol = 0;
%     else if(vol>=2)
%         vol = 40; 
% %         //这个值可以根据你的实际情况去调整
% 
%     tmp =acqdata.*vol; 
% %     // 上面所有关于vol的判断，其实都是为了此处*in_buf乘以一个倍数，你可以根据自己的需要去修改
% 
% %     // 下面的code主要是为了溢出判断
%     if(acqdata > 32767)
%         waveout = 32767;
%     else if(acqdata < -32768)
%         waveout = -32768;
%   waveout = acqdata;

  
