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
num_sim = 10000;
channelStrength_Size = 10;
ChannelStrength = 1;
channelStrengthStride = 1;


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
for j = 1:channelStrength_Size
    for i = 1:num_sim
        [v1_Three(i,j), v2_Three(i,j), v_seq1_Three(i,j), v_seq2_Three(i,j),H1(i,j),H2(i,j),H_12(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,1,1,1);
    end
     ChannelStrength = ChannelStrength + channelStrengthStride ;
end

mean_v1_Three = repmat(mean(v1_Three),length(v1_Three),1);
v1_Three = double(v1_Three>=mean_v1_Three);
mean_v2_Three = repmat(mean(v2_Three),length(v2_Three),1);
v2_Three = double(v2_Three>=mean_v2_Three);

mean_v_seq1_Three = repmat(mean(v_seq1_Three),length(v_seq1_Three),1);
v_seq1_Three = double(v_seq1_Three>=mean_v_seq1_Three);
mean_v_seq2_Three = repmat(mean(v_seq2_Three),length(v_seq2_Three),1);
v_seq2_Three = double(v_seq2_Three>=mean_v_seq2_Three);
% 
H=H1.*H2.*H_12;
% mean_H_all = repmat(mean(H),length(H),1);
% H_all = double(H>=mean_H_all);


%%%%%%%%%%%%%%%生成泄露信息的互信息(同时掌握三条信道)%%%%%%%%%%%%%%%%
for j = 1:channelStrength_Size
    MI_Channel(j) = mi(v_seq1_Three(:,j),v_seq2_Three(:,j));
    MI_Channel_KEY1_H_all(j) = mi(v_seq1_Three(:,j),H(:,j));
    MI_Channel_KEY2_H_all(j) = mi(v_seq2_Three(:,j),H(:,j));
    leakInformation_Channel(j) = max(MI_Channel_KEY1_H_all(j),MI_Channel_KEY2_H_all(j));
    
%     clear MI_Channel_KEY1_H_all;clear MI_Channel_KEY2_H_all;
    MI_Design(j) = mi(v1_Three(:,j),v2_Three(:,j));
    MI_Design_KEY1_H_all(j) = mi(v1_Three(:,j),H(:,j));
    MI_Design_KEY2_H_all(j) = mi(v2_Three(:,j),H(:,j));
    leakInformation_Design(j) = max(MI_Design_KEY1_H_all(j),MI_Design_KEY2_H_all(j));
%      clear MI_Design_KEY1_H_all;clear MI_Design_KEY2_H_all;
end

step = 1:channelStrength_Size;
figure(1);
plot(step,MI_Design,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel,'r-o','LineWidth',1.5);
hold on;
plot(step,leakInformation_Design,'g--d','LineWidth',1.5);
hold on;
plot(step,leakInformation_Channel,'--v','LineWidth',1.5);
hold off;
grid on;
axis([1 channelStrength_Size 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('收发设计生成密钥的互信息','直接相减产生的密钥互信息','收发设计生成密钥的信息泄露比率','直接相减产生的密钥的信息泄露比率','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_Three.txt', 'MI_Channel','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_Three.txt', 'MI_Design', '-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterThreeChannel.txt', 'leakInformation_Channel','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterThreeChannel.txt', 'leakInformation_Design', '-ascii');
