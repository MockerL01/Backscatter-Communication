function  [v_y1_cp, v_y2_cp,H] = generate_key_bit_CCA_Original_Model(data_ofdm, n_ofdm, n_cp ,n_frame,channelStrength)

pt = 10^(-2);
snr = 15;
% alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);
% pw_noise = 0;
cor = 0.999;

d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;

h = ray_model(d(3),taps(3));

h_t = ray_model_cor(h,cor,d(3));

H = randi(channelStrength,d(3),1);


% all transmissions in ambient backscatter communication
y1_d = ofdm_trans(data_ofdm, h+H, pw_noise);
y1_d_t = ofdm_trans(data_ofdm, h_t+H, pw_noise);

[y1_cp] = receiver_design2(y1_d, n_ofdm, n_cp, n_frame, n_L);
[y2_cp] = receiver_design2(y1_d_t, n_ofdm, n_cp, n_frame, n_L);

v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));


H = mean(abs(H));