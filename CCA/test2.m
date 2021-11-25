% % h1 = [0.1,0.2,0.3];
% clear
% clc
addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');
% s = [1 2 3 4 5 6 7 8 9 10]';
% H1 = [1,2,3]';
% H2 = [1,2,3]';
% H12 = [2,4,6]';
% n_L = 5;
% n_cp = 8;
% 
% noise = 0.1;
% channel_data1 = conv(H1,s) + noise;
% % invert_conv(s,channel_data1)
% channel_data2 = conv(H2,s) + noise;
% % modulate = [ones(1,10),ones(1,10)-2];
% % data = s.*modulate;
% channel_data12 = conv(channel_data1.*0.5,H1);
% channel_data21 = conv(channel_data2.*0.5,H12)+noise;
% res = conv(H1,H12);
% h1h12 = invert_conv(s,channel_data12);
% 
% difS = sum(channel_data12 - s);

key1 = randi(2,100,1)-1;
key2 = key1;
h(key1)
h(key2)
h([key1,key2])
mi(key1,key2)