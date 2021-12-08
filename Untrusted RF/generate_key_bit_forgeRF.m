function  [v_y1_cp, v_y2_cp, v_key1, v_key2,h1,h2] = generate_key_bit_forgeRF(data_ofdm, n_ofdm, n_cp ,n_frame)

pt = 1;
% snr = 0;
SignalToNoiseRate = 17;
alpha = 0.3 + 1i*0.4;
% pw_noise = pt/10^(snr/10);
pw_noise = pt/SignalToNoiseRate;
cor = 0.99;
% pw_noise =0;
% cor = 1;
d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;

h1 = ray_model(d(1),taps(1));
h1_t = ray_model_cor(h1,cor,d(1));
h2 = ray_model(d(2),taps(2));
h2_t = ray_model_cor(h2,cor,d(2));

h_21 = ray_model(d(3),taps(3));
h_12 = ray_model_cor(h_21,cor,d(3));
% h_21 = h_12;


% all transmissions in ambient backscatter communication
y1_d = ofdm_trans(data_ofdm, h1, pw_noise);
y2_d = ofdm_trans(data_ofdm, h2, pw_noise);
back2 = ofdm_back(y2_d, alpha, n_ofdm, n_frame);
y1_b = ofdm_trans(back2, h_21, pw_noise);

y1_d_t = ofdm_trans(data_ofdm, h1_t, pw_noise);
y2_d_t = ofdm_trans(data_ofdm, h2_t, pw_noise);
back1 = ofdm_back(y1_d_t, alpha, n_ofdm, n_frame);
y2_b = ofdm_trans(back1, h_12, pw_noise);
%%使用收发设计

[y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
[y2,y2_cp] = receiver_design(y2_d_t, y2_b, n_ofdm, n_cp, n_frame, n_L);

v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

%%信道分析
% all transmissions in ambient backscatter communication
y1_d_channel = ofdm_trans(data_ofdm,h1,pw_noise);
y2_d_channel= ofdm_trans(data_ofdm,h2,pw_noise);
y1_b_channel = ofdm_trans(y2_d_channel,h_21,pw_noise);

y1_d_t_channel = ofdm_trans(data_ofdm,h1_t,pw_noise);
y2_d_t_channel= ofdm_trans(data_ofdm,h2_t,pw_noise);
y2_b_t_channel = ofdm_trans(y1_d_t_channel,h_12,pw_noise);

key1 = conv(invert_conv(data_ofdm,y1_d_channel),invert_conv(data_ofdm,y1_b_channel));
key2 = conv(invert_conv(data_ofdm,y2_d_t_channel),invert_conv(data_ofdm,y2_b_t_channel));

v_key1 = mean(abs(key1));
v_key2 = mean(abs(key2));

% 
% % all transmissions in ambient backscatter communication
% y1_d = ofdm_trans(data_ofdm, h1, pw_noise);
% back1 = ofdm_back(y1_d, alpha, n_ofdm, n_frame);
% 
% y2_d = ofdm_trans(data_ofdm, h2, pw_noise);
% back2 = ofdm_back(y2_d, alpha, n_ofdm, n_frame);
% 
% y1_b = ofdm_trans(back2, h_12, pw_noise);
% y2_b = ofdm_trans(back1, h_12, pw_noise);
% 
% [y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
% [y2,y2_cp] = receiver_design(y2_d, y2_b, n_ofdm, n_cp, n_frame, n_L);
% 
% v_y1_cp = mean(abs(y1_cp));
% v_y2_cp = mean(abs(y2_cp));
% 
% %%信道分析
% % all transmissions in ambient backscatter communication
% y1_d_channel = ofdm_trans(data_ofdm,h1,pw_noise);
% y2_d_channel= ofdm_trans(data_ofdm,h2,pw_noise);
% y1_b_channel = ofdm_trans(y2_d_channel,h_12,pw_noise);
% 
% y2_b_channel = ofdm_trans(y1_d_channel,h_12,pw_noise);
% 
% % y1_d_t_channel = ofdm_trans(data_ofdm,h1_t,pw_noise);
% % y2_d_t_channel= ofdm_trans(data_ofdm,h2_t,pw_noise);
% % y2_b_t_channel = ofdm_trans(y1_d_t_channel,h_12,pw_noise);
% 
% key1 = conv(invert_conv(data_ofdm,y1_d_channel),invert_conv(data_ofdm,y1_b_channel));
% key2 = conv(invert_conv(data_ofdm,y2_d_channel),invert_conv(data_ofdm,y2_b_channel));
% 
% v_key1 = mean(abs(key1));
% v_key2 = mean(abs(key2));
% 
% 
% 
% 
