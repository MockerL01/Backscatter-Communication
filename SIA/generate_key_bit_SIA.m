function  [v_y1_cp, v_y2_cp, v_key1, v_key2,leakInf_hm1,leakInf_hm2] = generate_key_bit_SIA(data_ofdm_RF,data_ofdm_Mallory,n_ofdm, n_cp ,n_frame)

pt = 10^(-2);
snr = 10;
alpha = 0.3 + 1i*0.4;
% pw_noise = pt/10^(snr/10);

pw_noise = 0.25;



d = [8, 7, 3, 2];
taps = [8, 7, 3, 2];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延
cor = 0.99;

h1 = ray_model(d(1),taps(1));
% h1_t = ray_model_cor(h1,cor,d(1));
h2 = ray_model(d(2),taps(2));
% h2_t = ray_model_cor(h2,cor,d(2));

h_12 = ray_model(d(3),taps(3));
% h_21 = ray_model_cor(h_12,cor,d(2));

hm1 = ray_model(d(4),taps(4));
hm2 = hm1;


% data_ofdm = data_ofdm_RF + data_ofdm_Mallory;

% all transmissions in ambient backscatter communication
[y1_d_h1_design,noise_h1] = ofdm_trans(data_ofdm_RF,h1,pw_noise);
[y1_d_hm1_design,noise_hm1] = ofdm_trans(data_ofdm_Mallory,hm1,pw_noise);

y1_d_design = combineSignal( y1_d_h1_design , y1_d_hm1_design);
back1_design = ofdm_back(y1_d_design,alpha,n_ofdm,n_frame);

[y2_d_h2_design,noise_h2] = ofdm_trans(data_ofdm_RF,h2,pw_noise);
[y2_d_hm2_design,noise_hm2] = ofdm_trans(data_ofdm_Mallory,hm2,pw_noise);
y2_d_design = combineSignal(y2_d_h2_design , y2_d_hm2_design);
back2_design = ofdm_back(y2_d_design,alpha,n_ofdm,n_frame);

[y1_b_design,noise_h21] = ofdm_trans(back2_design,h_12,pw_noise);
[y2_b_design,noise_h12] = ofdm_trans(back1_design,h_12,pw_noise);

%%使用收发设计

[~,y1_cp] = receiver_design(y1_d_design, y1_b_design, n_ofdm, n_cp, n_frame, n_L);
[~,y2_cp] = receiver_design(y2_d_design, y2_b_design, n_ofdm, n_cp, n_frame, n_L);


v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

%%信道分析
% all transmissions in ambient backscatter communication
y1_d_h1_channel = ofdm_trans2(data_ofdm_RF,h1,noise_h1);
y1_d_hm1_channel = ofdm_trans2(data_ofdm_Mallory,hm1,noise_hm1);
y1_d_channel = combineSignal(y1_d_h1_channel , y1_d_hm1_channel);
% back1_channel = ofdm_back(y1_d_channel,alpha,n_ofdm,n_frame);

y2_d_h2_channel = ofdm_trans2(data_ofdm_RF,h2,noise_h2);
y2_d_hm2_channel = ofdm_trans2(data_ofdm_Mallory,hm2,noise_hm2);
y2_d_channel = combineSignal(y2_d_h2_channel , y2_d_hm2_channel);
% back2_channel = ofdm_back(y2_d_channel,alpha,n_ofdm,n_frame);

y1_b_channel = ofdm_trans(y2_d_channel,h_12,noise_h21);
y2_b_channel = ofdm_trans2(y1_d_channel,h_12,noise_h12);

% key1 = conv(invert_conv(data_ofdm_RF,y1_d_channel),invert_conv(data_ofdm_RF,y1_b_channel));
% key2 = conv(invert_conv(data_ofdm_RF,y2_d_channel),invert_conv(data_ofdm_RF,y2_b_channel));

res_h1 = invert_conv(data_ofdm_RF,y1_d_h1_channel);
% isequal(h1,res_h1)
res_hm1 = invert_conv(data_ofdm_Mallory,y1_d_hm1_channel);

res_h2 = invert_conv(data_ofdm_RF,y2_d_h2_channel);
res_hm2 = invert_conv(data_ofdm_Mallory,y2_d_hm2_channel);

res_h21 = invert_conv(combineSignal(y1_d_h1_channel,y1_d_hm1_channel),y2_b_channel);
res_h12 = invert_conv(combineSignal(y2_d_h2_channel,y2_d_hm2_channel),y1_b_channel);

% res_h21 = h_12;
% res_h12 = h_12;

key1 = conv(res_h21,conv(combineSignal(res_h1,res_hm1),combineSignal(res_h2,res_hm2)));
key2 = conv(res_h12,conv(combineSignal(res_h1,res_hm1),combineSignal(res_h2,res_hm2)));

v_key1 = mean(abs(key1));
v_key2 = mean(abs(key2));

leakInf_hm1 = mean(abs(conv(data_ofdm_Mallory,hm1)));
leakInf_hm2 = mean(abs(conv(data_ofdm_Mallory,hm2)));




