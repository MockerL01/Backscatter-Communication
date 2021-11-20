function  [v_y1_cp, v_y2_cp] = modelAna_Design(data_ofdm, n_ofdm, n_cp ,n_frame,i,H)

d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延

h1 = ray_model(d(1),taps(1));
h2 = ray_model(d(2),taps(2));
h_12 = ray_model(d(3),taps(3));

pt = 10^(-2);
snr = 15;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);
% pw_noise  = 0;
% all transmissions in ambient backscatter communication
% 
    H = randi([i,i+5],1,d(3));
    y1_d = ofdm_trans(data_ofdm,h1,pw_noise);
    back1 = ofdm_back(y1_d,alpha,n_ofdm,n_frame);

    y2_d = ofdm_trans(data_ofdm,h2,pw_noise);
    back2 = ofdm_back(y2_d,alpha,n_ofdm,n_frame);

    y1_b = ofdm_trans(back2,h_12+H,pw_noise);
    y2_b = ofdm_trans(back1,h_12+H,pw_noise);
    
     %%使用收发设计
    [y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
    [y2,y2_cp] = receiver_design(y2_d, y2_b, n_ofdm, n_cp, n_frame, n_L);

    v_y1_cp = mean(abs(y1_cp));
    v_y2_cp = mean(abs(y2_cp));
    

%     %%信道分析
%    
%     [y1,y1_d] = combineSignal(temp1_d,temp1_b,n_ofdm);
%     [y2,y2_d] = combineSignal(temp2_d,temp2_b,n_ofdm);
% 
% 
%     seq1 = y1_d.*(y1-y1_d);
%     seq2 = y2_d.*(y2-y2_d);
% 
%     v_seq1 = mean(abs(seq1));
%     v_seq2 = mean(abs(seq2));
