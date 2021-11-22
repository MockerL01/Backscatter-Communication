
clear
clc

addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');


% modulation methods: BPSK, QPSK,16QAM, 32QAM,64QAM
mod_method = 'QPSK';
% calculate modulation order from modulation method
mod_methods = {'BPSK', 'QPSK','8PSK','16QAM', '32QAM','64QAM'};
mod_order = find(ismember(mod_methods, mod_method));

%
% nfft = 256, K =1
n_fft = 256;
n_cp = n_fft/4;    % size of cyclic prefix extension
n_ofdm = n_fft + n_cp;
n_frame = 1;   
K = 1;

pt = 10^(-2);
snr = 50;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);

rand_ints = load("data_input_256.txt");
data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, 1);

h = ray_model(3,3);
h = h.*100;
signal = ofdm_trans(data_ofdm,h,0);

h0 = invert_conv(data_ofdm,signal);
% h0 = h0.*10;

MI = mi(h,h0);