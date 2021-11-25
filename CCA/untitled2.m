addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');
x = [1 1 1 1 0 1]';
y = [1 1 1 1 0 0]';
x1 = [1 0 1 0 0 1 1]';
y1 = [1 0 1 0 1 1 0]';
MI_x = h(x);
MI_y = h(y);
MI1 = mi(x,y);

MI_x1 = h(x1);
MI_y1 = h(y1);
MI2 = mi(x1,y1);