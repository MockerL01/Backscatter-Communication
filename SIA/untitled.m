clear
clc
s = [10,20,30,40,50,60]';
x = [3,4,5,6,7]';
h1 = [7,8,9]';
h12 = [10,11]';
hm1 = [1,2,3]';

% ans = s+x
y1d = conv(s,h1);
ym1d = conv(x,hm1);
% 
y2_receive = conv(combineSignal(y1d,ym1d),h12);
res_h12 = invert_conv(combineSignal(y1d,ym1d),y2_receive);
% 
% ideal = conv(h1+hm1,h12);
% temp = invert_conv(conv(s,h1),y2_receive)
% % res1 = invert_conv(x,invert_conv(conv(s,h1),y2_receive));
% % res2 = invert_conv(s,invert_conv(conv(x,hm1),y2_receive));
% % res = res1+res2;