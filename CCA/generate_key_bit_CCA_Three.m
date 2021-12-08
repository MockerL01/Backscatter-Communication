function  [v_y1_cp, v_y2_cp, v_key1, v_key2,leakInf1,leakInf2] = generate_key_bit_CCA_Three(data_ofdm, n_ofdm, n_cp ,n_frame,H1_flag,H2_flag,H12_flag)

pt = 10^(-2);
snr =30;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);              
% pw_noise = 0;s
cor = 0.99;
d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延

h1 = ray_model(d(1),taps(1));
h1_t = ray_model_cor(h1,cor,d(1));
h2 = ray_model(d(2),taps(2));
h2_t = ray_model_cor(h2,cor,d(2));

h_12 = ray_model(d(3),taps(3));
h_21 = ray_model_cor(h_12,cor,d(3));


% h_21 = h_12;
%     H1 = randi(channelStrength,1,d(1)).*H1_flag;
%     H2 = randi(channelStrength,1,d(2)).*H2_flag;
%     H_12  = randi(channelStrength,1,d(3)).*H12_flag;
% % H_21 = H_12;

    H1 = ray_model(d(1),taps(1)).*H1_flag;
    H2 = ray_model(d(2),taps(2)).*H2_flag;
    H_12  = ray_model(d(3),taps(3)).*H12_flag;
    
    H1_t = ray_model_cor(H1,cor,d(1));
    H2_t = ray_model_cor(H2,cor,d(2));
    H_21  = ray_model_cor(H_12,cor,d(3));
% all transmissions in ambient backscatter communication
y1_d = ofdm_trans(data_ofdm, h1+H1, pw_noise);
y2_d = ofdm_trans(data_ofdm, h2+H2, pw_noise);
back2 = ofdm_back(y2_d, alpha, n_ofdm, n_frame);
y1_b = ofdm_trans(back2, h_12+H_12, pw_noise);

y1_d_t = ofdm_trans(data_ofdm, h1_t+H1_t, pw_noise);
y2_d_t = ofdm_trans(data_ofdm, h2_t+H2_t, pw_noise);
back1 = ofdm_back(y1_d_t, alpha, n_ofdm, n_frame);
y2_b = ofdm_trans(back1, h_21+H_21, pw_noise);
%%使用收发设计

[y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
[y2,y2_cp] = receiver_design(y2_d_t, y2_b, n_ofdm, n_cp, n_frame, n_L);

v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

%%信道分析
% all transmissions in ambient backscatter communication
y1_d_channel = ofdm_trans(data_ofdm,h1+H1,pw_noise);
y2_d_channel= ofdm_trans(data_ofdm,h2+H2,pw_noise);
y1_b_channel = ofdm_trans(y2_d_channel,h_12+H_12,pw_noise);

y1_d_t_channel = ofdm_trans(data_ofdm,h1_t+H1,pw_noise);
y2_d_t_channel= ofdm_trans(data_ofdm,h2_t+H2,pw_noise);
y2_b_t_channel = ofdm_trans(y1_d_t_channel,h_12+H_12,pw_noise);
% 
key1 = conv(invert_conv(data_ofdm,y1_d_channel),invert_conv(data_ofdm,y1_b_channel));
key2 = conv(invert_conv(data_ofdm,y2_d_t_channel),invert_conv(data_ofdm,y2_b_t_channel));


v_key1 = mean(abs(key1));
v_key2 = mean(abs(key2));

leakInf1 = conv(conv(H1,H2),H_12);
leakInf2 = conv(conv(H1_t,H2_t),H_21);

leakInf1 = mean(abs(leakInf1));
leakInf2 = mean(abs(leakInf2));
% temp1 = conv(data_ofdm,H1);
% temp2 = conv(data_ofdm,conv(H2,H_12));
% leakInf1 = mean(abs(conv(data_ofdm,H1).*conv(data_ofdm,conv(H2,H_12))));
% leakInf2 = mean(abs(conv(data_ofdm,H1_t).*conv(data_ofdm,conv(H2_t,H_21))));




