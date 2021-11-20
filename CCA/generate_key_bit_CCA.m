function  [v_y1_cp, v_y2_cp, v_seq1, v_seq2,H1,H2,H_12] = generate_key_bit_CCA(data_ofdm, n_ofdm, n_cp ,n_frame,channelStrength,H1_flag,H2_flag,H12_flag)

pt = 10^(-2);
snr = 15;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);

d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %�ʱ��

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
y1_d = ofdm_trans(data_ofdm,h1+H1,pw_noise);
back1 = ofdm_back(y1_d,alpha,n_ofdm,n_frame);

y2_d = ofdm_trans(data_ofdm,h2+H2,pw_noise);
back2 = ofdm_back(y2_d,alpha,n_ofdm,n_frame);

y1_b = ofdm_trans(back2,h_12+H_12,pw_noise);
y2_b = ofdm_trans(back1,h_12+H_12,pw_noise);

%%ʹ���շ����
temp1_d = y1_d;
temp1_b = y1_b;
temp2_d = y2_d;
temp2_b = y2_b;
[y1,y1_cp] = receiver_design(temp1_d, temp1_b, n_ofdm, n_cp, n_frame, n_L);
[y2,y2_cp] = receiver_design(temp2_d, temp2_b, n_ofdm, n_cp, n_frame, n_L);


v_y1_cp = mean(abs(y1_cp));
v_y2_cp = mean(abs(y2_cp));

%%�ŵ�����
[y1,y1_d] = combineSignal(y1_d,y1_b,n_ofdm);
[y2,y2_d] = combineSignal(y2_d,y2_b,n_ofdm);

seq1 = y1_d.*(y1-y1_d);
seq2 = y2_d.*(y2-y2_d);

v_seq1 = mean(abs(seq1));
v_seq2 = mean(abs(seq2));

H1 = mean(abs(H1));
H2 = mean(abs(H2));
H_12 = mean(abs(H_12));



