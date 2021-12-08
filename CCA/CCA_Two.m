clc
clear

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
ChannelStrength_h1  = 0;
ChannelStrength_h2  = 0;
ChannelStrength_h12  = 0;
channelStrengthStride_h1 = 8/20;
channelStrengthStride_h2 = 7/20;
channelStrengthStride_h12 = 3/20;


MI_Channel_masterTwoChannel = zeros(channelStrength_Size,1);
MI_Design_masterTwoChannel = zeros(channelStrength_Size,1);
MI_Channel_Two = zeros(channelStrength_Size,1);
MI_Design_Two = zeros(channelStrength_Size,1);
%%%%%%%%%%%%%%%生成密钥相关的信息(同时掌握两条信道)%%%%%%%%%%%%%%%%
v1_Two_1 = zeros(num_sim,channelStrength_Size);v1_Two_2 = zeros(num_sim,channelStrength_Size);v1_Two_3 = zeros(num_sim,channelStrength_Size);
v2_Two_1 = zeros(num_sim,channelStrength_Size);v2_Two_2 = zeros(num_sim,channelStrength_Size);v2_Two_3 = zeros(num_sim,channelStrength_Size);
v_seq1_Two_1 = zeros(num_sim,channelStrength_Size);v_seq1_Two_2 = zeros(num_sim,channelStrength_Size);v_seq1_Two_3 = zeros(num_sim,channelStrength_Size);
v_seq2_Two_1 = zeros(num_sim,channelStrength_Size);v_seq2_Two_2 = zeros(num_sim,channelStrength_Size);v_seq2_Two_3 = zeros(num_sim,channelStrength_Size);
H1_Two_1 = zeros(num_sim,channelStrength_Size);H1_Two_2 = zeros(num_sim,channelStrength_Size);H2_Two_3 = zeros(num_sim,channelStrength_Size);
H2_Two_1 = zeros(num_sim,channelStrength_Size);H12_Two_2 = zeros(num_sim,channelStrength_Size);H_12_Two_3 = zeros(num_sim,channelStrength_Size);
for j = 1:channelStrength_Size
    for i = 1:num_sim
        [v1_Two_1(i,j), v2_Two_1(i,j), v_seq1_Two_1(i,j), v_seq2_Two_1(i,j),H1_Two_1(i,j),H2_Two_1(i,j),~] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,1,ChannelStrength_h1,ChannelStrength_h2,0);
        [v1_Two_2(i,j), v2_Two_2(i,j), v_seq1_Two_2(i,j), v_seq2_Two_2(i,j),H1_Two_2(i,j),~,H12_Two_2(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,1,ChannelStrength_h1,0,ChannelStrength_h12);
        [v1_Two_3(i,j), v2_Two_3(i,j), v_seq1_Two_3(i,j), v_seq2_Two_3(i,j),~,H2_Two_3(i,j),H_12_Two_3(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,1,0,ChannelStrength_h2,ChannelStrength_h12);
    end
     ChannelStrength_h1 = ChannelStrength_h1 + channelStrengthStride_h1 ;
     ChannelStrength_h2 = ChannelStrength_h2 + channelStrengthStride_h2 ;
     ChannelStrength_h12 = ChannelStrength_h12 + channelStrengthStride_h12 ;
end
% 
mean_H1_Two_1 = repmat(mean(H1_Two_1),num_sim,1);
H1_Two_1 = double(H1_Two_1>=mean_H1_Two_1);
mean_H2_Two_1 = repmat(mean(H2_Two_1),num_sim,1);
H2_Two_1 = double(H2_Two_1>=mean_H2_Two_1);

mean_H1_Two_2 = repmat(mean(H1_Two_2),num_sim,1);
H1_Two_2 = double(H1_Two_2>=mean_H1_Two_2);
mean_H12_Two_2 = repmat(mean(H12_Two_2),num_sim,1);
H12_Two_2 = double(H12_Two_2>=mean_H12_Two_2);

mean_H2_Two_3 = repmat(mean(H2_Two_3),num_sim,1);
H2_Two_3 = double(H2_Two_3>=mean_H2_Two_3);
mean_H_12_Two_3 = repmat(mean(H_12_Two_3),num_sim,1);
H_12_Two_3 = double(H_12_Two_3>=mean_H_12_Two_3);


mean_v1_Two_1 = repmat(mean(v1_Two_1),num_sim,1);
v1_Two_1 = double(v1_Two_1>=mean_v1_Two_1);
mean_v2_Two_1 = repmat(mean(v2_Two_1),num_sim,1);
v2_Two_1 = double(v2_Two_1>=mean_v2_Two_1);

mean_v_seq1_Two_1 = repmat(mean(v_seq1_Two_1),num_sim,1);
v_seq1_Two_1 = double(v_seq1_Two_1>=mean_v_seq1_Two_1);
mean_v_seq2_Two_1 = repmat(mean(v_seq2_Two_1),num_sim,1);
v_seq2_Two_1 = double(v_seq2_Two_1>=mean_v_seq2_Two_1);

mean_v1_Two_2 = repmat(mean(v1_Two_2),num_sim,1);
v1_Two_2 = double(v1_Two_2>=mean_v1_Two_2);
mean_v2_Two_2 = repmat(mean(v2_Two_2),num_sim,1);
v2_Two_2 = double(v2_Two_2>=mean_v2_Two_2);

mean_v_seq1_Two_2 = repmat(mean(v_seq1_Two_2),num_sim,1);
v_seq1_Two_2 = double(v_seq1_Two_2>=mean_v_seq1_Two_2);
mean_v_seq2_Two_2 = repmat(mean(v_seq2_Two_2),num_sim,1);
v_seq2_Two_2 = double(v_seq2_Two_2>=mean_v_seq2_Two_2);


mean_v1_Two_3 = repmat(mean(v1_Two_3),num_sim,1);
v1_Two_3 = double(v1_Two_3>=mean_v1_Two_3);
mean_v2_Two_3 = repmat(mean(v2_Two_3),num_sim,1);
v2_Two_3 = double(v2_Two_3>=mean_v2_Two_3);

mean_v_seq1_Two_3 = repmat(mean(v_seq1_Two_3),num_sim,1);
v_seq1_Two_3 = double(v_seq1_Two_3>=mean_v_seq1_Two_3);
mean_v_seq2_Two_3 = repmat(mean(v_seq2_Two_3),num_sim,1);
v_seq2_Two_3 = double(v_seq2_Two_3>=mean_v_seq2_Two_3);

%%%%%%%%%%%%%信道直接计算密钥的方法(掌握任意两条信道)%%%%%%%%%%%%%%%%
MI_Channel_H1H2 = zeros(channelStrength_Size,1);MI_Channel_H1H_12 = zeros(channelStrength_Size,1);MI_Channel_H2H_12 = zeros(channelStrength_Size,1);
MI_Channel_H1H2_Attacker = zeros(channelStrength_Size,1);MI_Channel_H1H_12_Attacker = zeros(channelStrength_Size,1);MI_Channel_H2H_12_Attacker = zeros(channelStrength_Size,1);
Diff_Channel_H1H2 = zeros(channelStrength_Size,1);Diff_Channel_H1H_12 = zeros(channelStrength_Size,1);Diff_Channel_H2H_12 = zeros(channelStrength_Size,1);
for j = 1:channelStrength_Size
   
    MI_Channel_H1H2(j) = mi(v_seq1_Two_1(:,j),v_seq2_Two_1(:,j));
    MI_Channel_KEY1_H1H2 = mi(v_seq1_Two_1(:,j),H1_Two_1(:,j).*H2_Two_1(:,j));
    MI_Channel_KEY2_H1H2 = mi(v_seq2_Two_1(:,j),H1_Two_1(:,j).*H2_Two_1(:,j));
    MI_Channel_H1H2_Attacker(j) = max(MI_Channel_KEY1_H1H2, MI_Channel_KEY2_H1H2);
    Diff_Channel_H1H2(j) =  MI_Channel_H1H2(j) - MI_Channel_H1H2_Attacker(j);
    
    MI_Channel_H1H_12(j) = mi(v_seq1_Two_2(:,j),v_seq2_Two_2(:,j));
    MI_Channel_KEY1_H1H_12 = mi(v_seq1_Two_2(:,j),H1_Two_2(:,j).*H12_Two_2(:,j));
    MI_Channel_KEY2_H1H_12 = mi(v_seq2_Two_2(:,j),H1_Two_2(:,j).*H12_Two_2(:,j));
    MI_Channel_H1H_12_Attacker(j) = max(MI_Channel_KEY1_H1H_12, MI_Channel_KEY2_H1H_12);
    Diff_Channel_H1H_12(j) =  MI_Channel_H1H_12(j) - MI_Channel_H1H_12_Attacker(j);
    
    MI_Channel_H2H_12(j) = mi(v_seq1_Two_3(:,j),v_seq2_Two_3(:,j));
    MI_Channel_KEY1_H2H_12 = mi(v_seq1_Two_3(:,j),H2_Two_3(:,j).*H_12_Two_3(:,j));
    MI_Channel_KEY2_H2H_12 = mi(v_seq2_Two_3(:,j),H2_Two_3(:,j).*H_12_Two_3(:,j));
    MI_Channel_H2H_12_Attacker(j) = max(MI_Channel_KEY1_H2H_12, MI_Channel_KEY2_H2H_12);
    Diff_Channel_H2H_12(j) =  MI_Channel_H2H_12(j) - MI_Channel_H2H_12_Attacker(j);
    
%     MI_Channel_Two(j) = min(min(MI_Channel_H1H2,MI_Channel_H1H_12),MI_Channel_H2H_12);
%     MI_Channel_masterTwoChannel(j) = max(max(MI_Channel_H1H2_Attacker,MI_Channel_H1H_12_Attacker),MI_Channel_H2H_12_Attacker);
end
% 
% clear v_seq1_Two_1;clear v_seq1_Two_2;clear v_seq1_Two_3;
% clear v_seq2_Two_1;clear v_seq2_Two_2;clear v_seq2_Two_3;

if min(min(sum(Diff_Channel_H1H2),sum(Diff_Channel_H1H_12)),sum(Diff_Channel_H2H_12)) == sum(Diff_Channel_H1H2)
    for j = 1:channelStrength_Size
        MI_Channel_Two(j) = MI_Channel_H1H2(j);
        MI_Channel_masterTwoChannel(j) = MI_Channel_H1H2_Attacker(j);
    end
    
elseif min(min(sum(Diff_Channel_H1H2),sum(Diff_Channel_H1H_12)),sum(Diff_Channel_H2H_12)) == sum(Diff_Channel_H1H_12)
    for j = 1:channelStrength_Size
        MI_Channel_Two(j) = MI_Channel_H1H_12(j);
        MI_Channel_masterTwoChannel(j) = MI_Channel_H1H_12_Attacker(j);
    end
    
elseif min(min(sum(Diff_Channel_H1H2),sum(Diff_Channel_H1H_12)),sum(Diff_Channel_H2H_12)) == sum(Diff_Channel_H2H_12)
    for j = 1:channelStrength_Size
        MI_Channel_Two(j) = MI_Channel_H2H_12(j);
        MI_Channel_masterTwoChannel(j) = MI_Channel_H2H_12_Attacker(j);
    end
end


% clear Diff_Channel_H1H2;clear Diff_Channel_H2H_12;clear Diff_Channel_H1H_12;

%%%%%%%%%%%%%使用收发设计计算密钥的方法(掌握任意两条信道)%%%%%%%%%%%%%%%%
MI_Design_H1H2 = zeros(channelStrength_Size,1);MI_Design_H1H_12 = zeros(channelStrength_Size,1);MI_Design_H2H_12 = zeros(channelStrength_Size,1);
MI_Design_H1H2_Attacker = zeros(channelStrength_Size,1);MI_Design_H1H_12_Attacker = zeros(channelStrength_Size,1);MI_Design_H2H_12_Attacker = zeros(channelStrength_Size,1);
Diff_Design_H1H2 = zeros(channelStrength_Size,1);Diff_Design_H1H_12 = zeros(channelStrength_Size,1);Diff_Design_H2H_12 = zeros(channelStrength_Size,1);
for j = 1:channelStrength_Size
   
    MI_Design_H1H2(j) = mi(v1_Two_1(:,j),v2_Two_1(:,j));
    MI_Design_KEY1_H1H2 = mi(v1_Two_1(:,j),H1_Two_1(:,j).*H2_Two_1(:,j));
    MI_Design_KEY2_H1H2 = mi(v2_Two_1(:,j),H1_Two_1(:,j).*H2_Two_1(:,j));
    MI_Design_H1H2_Attacker(j) = max(MI_Design_KEY1_H1H2, MI_Design_KEY2_H1H2);
    Diff_Design_H1H2(j) =  MI_Design_H1H2(j) - MI_Design_H1H2_Attacker(j);
     
    MI_Design_H1H_12(j) = mi(v1_Two_2(:,j),v2_Two_2(:,j));
    MI_Design_KEY1_H1H_12 = mi(v1_Two_2(:,j),H1_Two_2(:,j).*H12_Two_2(:,j));
    MI_Design_KEY2_H1H_12 = mi(v2_Two_2(:,j),H1_Two_2(:,j).*H12_Two_2(:,j));
    MI_Design_H1H_12_Attacker(j) = max(MI_Design_KEY1_H1H_12, MI_Design_KEY2_H1H_12);
    Diff_Design_H1H_12(j) =  MI_Design_H1H_12(j) - MI_Design_H1H_12_Attacker(j);
     
    MI_Design_H2H_12(j) = mi(v1_Two_3(:,j),v2_Two_3(:,j));
    MI_Design_KEY1_H2H_12 = mi(v1_Two_3(:,j),H2_Two_3(:,j).*H_12_Two_3(:,j));
    MI_Design_KEY2_H2H_12 = mi(v2_Two_3(:,j),H2_Two_3(:,j).*H_12_Two_3(:,j));
    MI_Design_H2H_12_Attacker(j) = max(MI_Design_KEY1_H2H_12, MI_Design_KEY2_H2H_12);
    Diff_Design_H2H_12(j) =  MI_Design_H2H_12(j) - MI_Design_H2H_12_Attacker(j);
     
%     MI_Design_Two(j) = min(min(MI_Design_H1H2,MI_Design_H1H_12),MI_Design_H2H_12);
%     MI_Design_masterTwoChannel(j) = max(max(MI_Design_H1H2_Attacker,MI_Design_H1H_12_Attacker),MI_Design_H2H_12_Attacker);
end

% clear v1_Two_1;clear v1_Two_2;clear v1_Two_3;
% clear v2_Two_1;clear v2_Two_2;clear v2_Two_3;

if min(min(sum(Diff_Design_H1H2),sum(Diff_Design_H1H_12)),sum(Diff_Design_H2H_12)) == sum(Diff_Design_H1H2)
    for j = 1:channelStrength_Size
        MI_Design_Two(j) = MI_Design_H1H2(j);
        MI_Design_masterTwoChannel(j) = MI_Design_H1H2_Attacker(j);
    end
    
elseif min(min(sum(Diff_Design_H1H2),sum(Diff_Design_H1H_12)),sum(Diff_Design_H2H_12)) == sum(Diff_Design_H1H_12)
    for j = 1:channelStrength_Size
        MI_Design_Two(j) = MI_Design_H1H_12(j);
        MI_Design_masterTwoChannel(j) = MI_Design_H1H_12_Attacker(j);
    end
    
elseif min(min(sum(Diff_Design_H1H2),sum(Diff_Design_H1H_12)),sum(Diff_Design_H2H_12)) == sum(Diff_Design_H2H_12)
    for j = 1:channelStrength_Size
        MI_Design_Two(j) = MI_Design_H2H_12(j);
        MI_Design_masterTwoChannel(j) = MI_Design_H2H_12_Attacker(j);
    end
end

% clear Diff_Design_H1H2;clear Diff_Design_H2H_12;clear Diff_Design_H1H_12;



step1 = 0:channelStrengthStride_h1:8;
step2 = 0:channelStrengthStride_h2:7;


figure(1);
plot(step1,MI_Design_H1H2,'c-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1H2,'r-o','LineWidth',1.5);
hold on;
plot(step1,MI_Design_H1H2_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1H2_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 8 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');

figure(2);
plot(step1,MI_Design_H1H_12,'c-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1H_12,'r-o','LineWidth',1.5);
hold on;
plot(step1,MI_Design_H1H_12_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1H_12_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 8 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


figure(3);

plot(step2,MI_Design_H2H_12,'c-d','LineWidth',1.5);
hold on;
plot(step2,MI_Channel_H2H_12,'r-o','LineWidth',1.5);
hold on;
plot(step2,MI_Design_H2H_12_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step2,MI_Channel_H2H_12_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 7 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


% 
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_Two.txt', 'MI_Channel_Two','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_Two.txt', 'MI_Design_Two', '-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterTwoChannel.txt', 'MI_Channel_masterTwoChannel','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterTwoChannel.txt', 'MI_Design_masterTwoChannel', '-ascii');
