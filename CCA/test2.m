clear
clc
h1 = [1,2,3,4,5;5,6,7,8,9]';
h12 = [2,3,4]';
h2 = [4,5,7,8]';

s = [1,0,1,1,0,1,0,0,1]';

mean_h1 = repmat(mean(h1),length(h1),1);

v_h1 = double(h1>=mean_h1);

% r1 = conv(h1,conv(h2,h12));
% % r2 = conv(h2,conv(h1,h12));
% 
% y2_d = conv(s,h2);
% y1_d = conv(s,h1);
% 
% y2_b = conv(y1_d,h12);
% y1_b = conv(y2_d,h12);
% 
% % conv(h2,h12)
% key1 = conv(invert_conv(s,y1_d),invert_conv(s,y1_b));
% key2 = conv(invert_conv(s,y2_d),invert_conv(s,y2_b));