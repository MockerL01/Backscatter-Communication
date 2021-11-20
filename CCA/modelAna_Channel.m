addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');

% modulation methods: BPSK, QPSK,16QAM, 32QAM,64QAM
mod_method = 'QPSK';
% calculate modulation order from modulation method
mod_methods = {'BPSK', 'QPSK','8PSK','16QAM', '32QAM','64QAM'};
mod_order = find(ismember(mod_methods, mod_method));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%
% nfft = 256, K =1
n_fft = 128;
n_cp = n_fft/4;    % size of cyclic prefix extension
n_ofdm = n_fft + n_cp;
n_frame = 1;   
K = 1;

pt = 10^(-2);
snr = 15;
alpha = 0.3 + 1i*0.4;
pw_noise = pt/10^(snr/10);

d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延

h1 = ray_model(d(1),taps(1));
h2 = ray_model(d(2),taps(2));
h_12 = ray_model(d(3),taps(3));

% generate the data 
% rand_ints_gen = randi(2,n_fft*mod_order*K,1)-1;
% save data_input_128.txt -ascii rand_ints_gen
rand_ints = load("data_input_128.txt");

data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, 1);
data_cp_pwr = mean(abs(data_ofdm).^2);%平均功率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_key = 10000;
channelStrength_Size = 30;
ChannelStrength = 1;
channelStrengthStride = 1;

v1 = zeros(num_key,channelStrength_Size);
v2 = zeros(num_key,channelStrength_Size);
v_seq1 = zeros(num_key,channelStrength_Size);
v_seq2 = zeros(num_key,channelStrength_Size);
for i = 1:channelStrength_Size
    for j = 1:num_key
%         [v1(j,i),v2(j,i),v_seq1(j,i),v_seq2(j,i),~,~,H] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,i,0,0,1);
         H_12  = randi(i,1,d(3));
    

        % all transmissions in ambient backscatter communication
        y1_d = ofdm_trans(data_ofdm,h1,pw_noise);
        back1 = ofdm_back(y1_d,alpha,n_ofdm,n_frame);

        y2_d = ofdm_trans(data_ofdm,h2,pw_noise);
        back2 = ofdm_back(y2_d,alpha,n_ofdm,n_frame);

        y1_b = ofdm_trans(back2,h_12+H_12,pw_noise);
        y2_b = ofdm_trans(back1,h_12+H_12,pw_noise);

        %%使用收发设计

        [y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
        [y2,y2_cp] = receiver_design(y2_d, y2_b, n_ofdm, n_cp, n_frame, n_L);

        v1(j,i) = mean(abs(y1_cp));
        v2(j,i) = mean(abs(y2_cp));

%         %%信道分析
%         [y1,y1_d] = combineSignal(y1_d,y1_b,n_ofdm);
%         [y2,y2_d] = combineSignal(y2_d,y2_b,n_ofdm);
% 
%         seq1 = y1_d.*(y1-y1_d);
%         seq2 = y2_d.*(y2-y2_d);
% 
%         v_seq1(j,i) = mean(abs(seq1));
%         v_seq2(j,i) = mean(abs(seq2));
          H(j,i) = mean(abs(H_12));

    end

    MI_Design(i) = mi(v1(:,i),v2(:,i));
    MI = mi(H(:,i),v1(:,i));
    H_mean(i) = mean(abs(H(:,i)));
end

x = 1:channelStrength_Size;
figure(1);
plot(x,MI_Design,'r-o');
% hold on;
% plot(x,MI_Channel,'g-o');
% hold off;
    
    
    
    
    
    
    