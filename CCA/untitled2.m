addpath('E:\�о���\��������Ŀ\physical-key-generation-master\MIToolbox-master\matlab');
x = [1,2,3,4,5,6,7,8,9,10]';
w = x./10;

mean(x)
mean(w)
mean(x+w)


mi(x,x+w);
