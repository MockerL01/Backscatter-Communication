clc;
clear;
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
c_flag = 1;

% generate the data 
% rand_ints_gen = randi(2,n_fft*mod_order*K,1)-1;
% save data_input.txt -ascii rand_ints_gen
rand_ints = load("data_input_256.txt");
data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, c_flag);
num_sim = 50000;
channelStrength_Size = 21;
ChannelStrength_h1  = 1;
ChannelStrength_h2  = 1;
ChannelStrength_h12  = 1;
channelStrengthStride_h1 = 8/20;
channelStrengthStride_h2 = 7/20;
channelStrengthStride_h12 = 3/20;

%%%%%%%%%%%%%%%%%%%%%%参数预设值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MI_Channel = zeros(channelStrength_Size,1);
MI_Channel_KEY1_H_all = zeros(channelStrength_Size,1);
MI_Channel_KEY2_H_all = zeros(channelStrength_Size,1);
leakInformation_Channel = zeros(channelStrength_Size,1);

MI_Design = zeros(channelStrength_Size,1);
MI_Design_KEY1_H_all = zeros(channelStrength_Size,1);
MI_Design_KEY2_H_all = zeros(channelStrength_Size,1);
leakInformation_Design = zeros(channelStrength_Size,1);

%%%%%%%%%%%%%%%生成密钥相关的信息(同时掌握三条信道)%%%%%%%%%%%%%%%%
v1_Three = zeros(num_sim,channelStrength_Size);
v2_Three = zeros(num_sim,channelStrength_Size);
v_seq1_Three = zeros(num_sim,channelStrength_Size);
v_seq2_Three = zeros(num_sim,channelStrength_Size);
H1 = zeros(num_sim,channelStrength_Size);
H2 = zeros(num_sim,channelStrength_Size);
H_12 = zeros(num_sim,channelStrength_Size);
leakInf1 = zeros(num_sim,channelStrength_Size);
leakInf2 = zeros(num_sim,channelStrength_Size);
for j = 1:channelStrength_Size
    for i = 1:num_sim
        [v1_Three(i,j), v2_Three(i,j), v_seq1_Three(i,j), v_seq2_Three(i,j),leakInf1(i,j),leakInf2(i,j)] = generate_key_bit_CCA_Three(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength_h1,ChannelStrength_h2,ChannelStrength_h12);
    end
     ChannelStrength_h1 = ChannelStrength_h1 + channelStrengthStride_h1 ;
     ChannelStrength_h2 = ChannelStrength_h2 + channelStrengthStride_h2 ;
     ChannelStrength_h12 = ChannelStrength_h12 + channelStrengthStride_h12 ;
end

mean_v1_Three = repmat(mean(v1_Three),num_sim,1);
v1_Three = double(v1_Three>=mean_v1_Three);
mean_v2_Three = repmat(mean(v2_Three),num_sim,1);
v2_Three = double(v2_Three>=mean_v2_Three);

mean_v_seq1_Three = repmat(mean(v_seq1_Three),num_sim,1);
v_seq1_Three = double(v_seq1_Three>=mean_v_seq1_Three);
mean_v_seq2_Three = repmat(mean(v_seq2_Three),num_sim,1);
v_seq2_Three = double(v_seq2_Three>=mean_v_seq2_Three);

mean_leakInf1 = repmat(mean(leakInf1),num_sim,1);
leakInf1 = double(leakInf1>mean_leakInf1);
mean_leakInf2 = repmat(mean(leakInf2),num_sim,1);
leakInf2 = double(leakInf2>mean_leakInf2);
% % % 
% H=H1.*H2.*H_12.*mean(abs(data_ofdm))^2;
% % mean_H_all = repmat(mean(H),num_sim,1);
% % H = double(H>=mean_H_all);


%%%%%%%%%%%%%%%生成泄露信息的互信息(同时掌握三条信道)%%%%%%%%%%%%%%%%
for j = 1:channelStrength_Size
    MI_Channel(j) = mi(v_seq1_Three(:,j),v_seq2_Three(:,j));
    
    MI_Channel_KEY1_H_all(j) = mi(v_seq1_Three(:,j),leakInf1(:,j));
    MI_Channel_KEY2_H_all(j) = mi(v_seq2_Three(:,j),leakInf2(:,j));
    leakInformation_Channel(j) = max(MI_Channel_KEY1_H_all(j),MI_Channel_KEY2_H_all(j));
    
    if leakInformation_Channel(j)>MI_Channel(j)
        leakInformation_Channel(j)=MI_Channel(j);
    end
    
%     clear MI_Channel_KEY1_H_all;clear MI_Channel_KEY2_H_all;
    MI_Design(j) = mi(v1_Three(:,j),v2_Three(:,j));
    MI_Design_KEY1_H_all(j) = mi(v1_Three(:,j),leakInf1(:,j));
    MI_Design_KEY2_H_all(j) = mi(v2_Three(:,j),leakInf2(:,j));
    leakInformation_Design(j) = max(MI_Design_KEY1_H_all(j),MI_Design_KEY2_H_all(j));
    
    if leakInformation_Design(j)>MI_Design(j)
        leakInformation_Design(j)=MI_Design(j);
    end
%      clear MI_Design_KEY1_H_all;clear MI_Design_KEY2_H_all;
end

step = 0:channelStrengthStride_h1:8;

figure(1);
plot(step,MI_Design,'g-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel,'r-d','LineWidth',1.5);
hold on;
plot(step,leakInformation_Design,'g--v','LineWidth',1.5);
hold on;
plot(step,leakInformation_Channel,'r--v','LineWidth',1.5);
hold off;
grid on;



axis([0 8 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('收发设计生成密钥的互信息','信道分析产生的密钥互信息','收发设计生成密钥的信息泄露比率','信道分析产生的密钥的信息泄露比率','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


% 
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_Three.txt', 'MI_Channel','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_Three.txt', 'MI_Design', '-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterThreeChannel.txt', 'leakInformation_Channel','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterThreeChannel.txt', 'leakInformation_Design', '-ascii');
