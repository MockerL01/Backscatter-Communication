function [y,y_d] = combineSignal(y_d, y_b, n_ofdm)
%%��������
sym_rem = mod(n_ofdm-mod(length(y_d),n_ofdm),n_ofdm); %����320λ
padding = repmat(0+0i,sym_rem,1);
y_d_padded = [y_d;padding];%��0�����

sym_rem = mod(n_ofdm-mod(length(y_b),n_ofdm),n_ofdm);
padding = repmat(0+0i,sym_rem,1); %repmat �ظ����鸱��
y_b_padded = [y_b;padding];

y = y_d_padded+y_b_padded;
y_d = y_d_padded;