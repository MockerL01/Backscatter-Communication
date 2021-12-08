function  [v_y1_cp, v_y2_cp,leakInf_hm1,leakInf_hm2] = generate_key_bit_SIA_Original_Model(data_ofdm_RF,data_ofdm_Mallory,n_ofdm, n_cp ,n_frame)

pt = 10^(-2);
snr = 15;
% alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);
% pw_noise = 0;
cor = 0.999;

d = [8, 7, 3 ,2];
taps = [8, 7, 3 ,2];
n_L = max(taps(1),taps(2))+taps(3)-1;  %×î³¤Ê±ÑÓ

h = ray_model(d(3),taps(3));
h_t = ray_model_cor(h,cor,d(3));

hm1 = ray_model(d(4),taps(4));
hm2 = hm1;



% all transmissions in ambient backscatter communication
y1_d = ofdm_trans(data_ofdm_RF, h, pw_noise.*d(3));
y1_d_t = ofdm_trans(data_ofdm_RF, h_t, pw_noise.*d(3));
[inject_hm1,~] = ofdm_trans(data_ofdm_Mallory,hm1,0);
[inject_hm2,~] = ofdm_trans(data_ofdm_Mallory,hm2,0);

y1_d = combineSignal(y1_d,inject_hm1);
y1_d_t = combineSignal(y1_d_t,inject_hm2);

[y1_cp] = receiver_design2(y1_d, n_ofdm, n_cp, n_frame, n_L);
[y2_cp] = receiver_design2(y1_d_t, n_ofdm, n_cp, n_frame, n_L);

v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

leakInf_hm1 = mean(abs(conv(hm1,data_ofdm_Mallory)));
leakInf_hm2 = mean(abs(conv(hm2,data_ofdm_Mallory)));