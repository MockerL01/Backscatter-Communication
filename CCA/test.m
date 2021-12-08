
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


pt = 10^(-3);
snr = [10,20,30,40,50];
alpha = 0.3 + 1i*0.4;

% pw_noise = 0;
cor = 0.99;
d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延


% snr = [10,20,30,40,50,60,70,80,90,100];
rand_ints = load("data_input_256.txt");
data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, 1);

channelStrength_Size = 50;
num_key = 10000;
MI = zeros(channelStrength_Size,length(snr));
MI2 = zeros(channelStrength_Size,length(snr));
avg = 1;
for index = 1:length(snr)
 channelStrength =1;
 pw_noise = pt/10^(snr(index)/10);
for i = 1:channelStrength_Size
    for k = 1:avg
            for j = 1:num_key             
            h1 = ray_model(d(1),taps(1));
            h1_t = ray_model_cor(h1,cor,d(1));
            h2 = ray_model(d(2),taps(2));
            h2_t = ray_model_cor(h2,cor,d(2));

            h_12 = ray_model(d(3),taps(3));
            h_21 = ray_model_cor(h_12,cor,d(3));
         
            H_12  = h_12.*channelStrength;
            H_21_t = h_21.*channelStrength;


            y1_d = ofdm_trans(data_ofdm, h1, pw_noise);
            y2_d = ofdm_trans(data_ofdm, h2, pw_noise);
            back2 = ofdm_back(y2_d, alpha, n_ofdm, n_frame);
            y1_b = ofdm_trans(back2, h_12+H_12, pw_noise);

            y1_d_t = ofdm_trans(data_ofdm, h1_t, pw_noise);
            y2_d_t = ofdm_trans(data_ofdm, h2_t, pw_noise);
            back1 = ofdm_back(y1_d_t, alpha, n_ofdm, n_frame);
            y2_b = ofdm_trans(back1, h_21+H_21_t, pw_noise);
            %%使用收发设计

            [y1,y1_cp] = receiver_design(y1_d, y1_b, n_ofdm, n_cp, n_frame, n_L);
            [y2,y2_cp] = receiver_design(y2_d_t, y2_b, n_ofdm, n_cp, n_frame, n_L);

            v1(j,i) = mean(abs(y1_cp));
            v2(j,i) = mean(abs(y2_cp));
% 
%             %%信道分析
%             % all transmissions in ambient backscatter communication
%             y1_d_channel = ofdm_trans(data_ofdm,h1,pw_noise);
%             y2_d_channel= ofdm_trans(data_ofdm,h2,pw_noise);
%             y1_b_channel = ofdm_trans(y2_d_channel,h_12+H_12,pw_noise);
% 
%             y1_d_t_channel = ofdm_trans(data_ofdm,h1_t,pw_noise);
%             y2_d_t_channel= ofdm_trans(data_ofdm,h2_t,pw_noise);
%             y2_b_t_channel = ofdm_trans(y1_d_t_channel,h_12+H_12,pw_noise);
% 
%             key1 = conv(invert_conv(data_ofdm,y1_d_channel),invert_conv(data_ofdm,y1_b_channel));
%             key2 = conv(invert_conv(data_ofdm,y2_d_t_channel),invert_conv(data_ofdm,y2_b_t_channel));
% 
%             v1_2(j,i) = mean(abs(key1));
%             v2_2(j,i) = mean(abs(key2));
            end
        mean_v1 = repmat(mean(v1),num_key,1);
        v1 = double(v1>=mean_v1);
        mean_v2 = repmat(mean(v2),num_key,1);
        v2 = double(v2>=mean_v2);

%         mean_v1_2 = repmat(mean(v1_2),num_key,1);
%         v1_2 = double(v1_2>=mean_v1_2);
%         mean_v2_2 = repmat(mean(v2_2),num_key,1);
%         v2_2 = double(v2_2>=mean_v2_2);     
        
        MI(i,index) = MI(i,index) + mi(v1(:,i),v2(:,i));
%         MI2(i,index) = MI2(i) + mi(v1_2(:,i),v2_2(:,i));
    end
    channelStrength = channelStrength + 1;
end
end
MI = MI./avg;
% MI2 = MI2./avg;


% 
% for i = 1:channelStrength_Size
%     diff(i) = sum(abs(v1(:,i)-v2(:,i)));
% end


figure(1);
    plot(1:channelStrength_Size,MI(:,1),"r-v");
    hold on;
    plot(1:channelStrength_Size,MI(:,2),"g-v");
    hold on;
    plot(1:channelStrength_Size,MI(:,3),"b-v");
    hold on;
    plot(1:channelStrength_Size,MI(:,4),"m-v");
    hold on;
    plot(1:channelStrength_Size,MI(:,5),"k-v");
    hold on;
%     plot(1:channelStrength_Size,MI(:,6),"r-o");
%     hold on;
%     plot(1:channelStrength_Size,MI(:,7),"g-o");
%     hold on;
%     plot(1:channelStrength_Size,MI(:,8),"b-o");
%     hold on;
%     plot(1:channelStrength_Size,MI(:,9),"w-o");
%     hold on;
%     plot(1:channelStrength_Size,MI(:,10),"k-o");
hold off;
axis([1 channelStrength_Size 0.5 1])
legend('snr = 10','snr = 20','snr = 30','snr = 40','snr = 50','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');
% 
% figure(2);
% plot(1:channelStrength_Size,MI-MI2,"g-v");

% figure(3);
% plot(1:channelStrength_Size,diff,"g-v");
