function [y,y_d] = combineSignal(y_d, y_b, n_ofdm)
%%补充数据
sym_rem = mod(n_ofdm-mod(length(y_d),n_ofdm),n_ofdm); %补至320位
padding = repmat(0+0i,sym_rem,1);
y_d_padded = [y_d;padding];%用0进行填补

sym_rem = mod(n_ofdm-mod(length(y_b),n_ofdm),n_ofdm);
padding = repmat(0+0i,sym_rem,1); %repmat 重复数组副本
y_b_padded = [y_b;padding];

y = y_d_padded+y_b_padded;
y_d = y_d_padded;