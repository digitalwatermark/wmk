

% f=0:20000;
f = [0 100 200 300 400 510 630 770 920 1080 1270 1480 1720 2000 2320 2700 3150 3700 4400 5300 6400 7700 9500 12000 15500 22050];
bark1=13*atan(.00076*f)+3.5*atan((f/7500).^2);          % coincident with  ISO/IEC 11172-3
figure; plot(f,bark1,'r'); grid;
figure; plot(f/44100*512,bark1,'r'); grid;
df = (f(2:end)+f(1:end-1))/2;
df = f;
bark3 = (df<500).*(df/100) + (df>=500).*(9+4*log2((df+eps)/1000))

hold on; plot(bark3, 'b');

bitrate = 192000;
fs = 44100;
bark2 = f * bitrate / fs;
figure; plot(bark2)


    