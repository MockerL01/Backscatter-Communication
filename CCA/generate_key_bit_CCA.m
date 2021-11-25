function  [v_y1_cp, v_y2_cp, v_key1, v_key2,v_H1,v_H2,v_H_12] = generate_key_bit_CCA(data_ofdm, n_ofdm, n_cp ,n_frame,channelStrength,H1_flag,H2_flag,H12_flag)

pt = 10^(-2);
snr = 15;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);
% pw_noise = 0;

d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延

h1 = ray_model(d(1),taps(1));
h2 = ray_model(d(2),taps(2));
h_12 = ray_model(d(3),taps(3));


% h_21 = h_12;
%     H1 = randi(channelStrength,1,d(1)).*H1_flag;
%     H2 = randi(channelStrength,1,d(2)).*H2_flag;
%     H_12  = randi(channelStrength,1,d(3)).*H12_flag;
% % H_21 = H_12;

    H1 = h1.*channelStrength.*H1_flag;
    H2 = h2.*channelStrength.*H2_flag;
    H_12  = h_12.*channelStrength.*H12_flag;

% all transmissions in ambient backscatter communication
y1_d_design = ofdm_trans(data_ofdm,h1+H1,pw_noise.*d(1));
back1_design = ofdm_back(y1_d_design,alpha,n_ofdm,n_frame);

y2_d_design = ofdm_trans(data_ofdm,h2+H2,pw_noise.*d(2));
back2_design = ofdm_back(y2_d_design,alpha,n_ofdm,n_frame);

y1_b_design = ofdm_trans(back2_design,h_12+H_12,pw_noise.*d(3));
y2_b_design = ofdm_trans(back1_design,h_12+H_12,pw_noise.*d(3));

%%使用收发设计

[y1,y1_cp] = receiver_design(y1_d_design, y1_b_design, n_ofdm, n_cp, n_frame, n_L);
[y2,y2_cp] = receiver_design(y2_d_design, y2_b_design, n_ofdm, n_cp, n_frame, n_L);


v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

%%信道分析
% [y1,y1_d] = combineSignal(y1_d,y1_b,n_ofdm);
% [y2,y2_d] = combineSignal(y2_d,y2_b,n_ofdm);


% channelH1 = invert_conv(data_ofdm,y1_d);
% channelH2H21 = invert_conv(data_ofdm,y1_b);
% 
% channelH2 = invert_conv(data_ofdm,y2_d);
% channelH1H12 = invert_conv(data_ofdm,y2_b);
% 
% 
% 
% 
% seq1 = conv(channelH2,channelH1H12);
% seq2 = conv(channelH1,channelH2H21);

% all transmissions in ambient backscatter communication
y1_d_channel = ofdm_trans(data_ofdm,h1+H1,pw_noise.*d(1));
y2_d_channel= ofdm_trans(data_ofdm,h2+H2,pw_noise.*d(2));

y1_b_channel = ofdm_trans(y2_d_channel,h_12+H_12,pw_noise.*d(3));
y2_b_channel = ofdm_trans(y1_d_channel,h_12+H_12,pw_noise.*d(3));

key1 = conv(invert_conv(data_ofdm,y1_d_channel),invert_conv(data_ofdm,y1_b_channel));
key2 = conv(invert_conv(data_ofdm,y2_d_channel),invert_conv(data_ofdm,y2_b_channel));

v_key1 = mean(abs(key1));
v_key2 = mean(abs(key2));


v_H1 = mean(abs(H1));
v_H2 = mean(abs(H2));
v_H_12 = mean(abs(H_12));



