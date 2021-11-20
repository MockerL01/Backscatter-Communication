addpath('E:\�о���\��������Ŀ\physical-key-generation-master\MIToolbox-master\matlab');

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
num_sim = 1000;
channelStrength_Size =30;
ChannelStrength = 1;
channelStrengthStride = 1;

MI_Channel_masterTwoChannel = zeros(channelStrength_Size,1);
MI_Design_masterTwoChannel = zeros(channelStrength_Size,1);
MI_Channel_Two = zeros(channelStrength_Size,1);
MI_Design_Two = zeros(channelStrength_Size,1);
%%%%%%%%%%%%%%%������Կ��ص���Ϣ(ͬʱ���������ŵ�)%%%%%%%%%%%%%%%%
v1_Two_1 = zeros(num_sim,channelStrength_Size);v1_Two_2 = zeros(num_sim,channelStrength_Size);v1_Two_3 = zeros(num_sim,channelStrength_Size);
v2_Two_1 = zeros(num_sim,channelStrength_Size);v2_Two_2 = zeros(num_sim,channelStrength_Size);v2_Two_3 = zeros(num_sim,channelStrength_Size);
v_seq1_Two_1 = zeros(num_sim,channelStrength_Size);v_seq1_Two_2 = zeros(num_sim,channelStrength_Size);v_seq1_Two_3 = zeros(num_sim,channelStrength_Size);
v_seq2_Two_1 = zeros(num_sim,channelStrength_Size);v_seq2_Two_2 = zeros(num_sim,channelStrength_Size);v_seq2_Two_3 = zeros(num_sim,channelStrength_Size);
H1_Two_1 = zeros(num_sim,channelStrength_Size);H1_Two_2 = zeros(num_sim,channelStrength_Size);H2_Two_3 = zeros(num_sim,channelStrength_Size);
H2_Two_1 = zeros(num_sim,channelStrength_Size);H12_Two_2 = zeros(num_sim,channelStrength_Size);H_12_Two_3 = zeros(num_sim,channelStrength_Size);
for j = 1:channelStrength_Size
    for i = 1:num_sim
        [v1_Two_1(i,j), v2_Two_1(i,j), v_seq1_Two_1(i,j), v_seq2_Two_1(i,j),H1_Two_1(i,j),H2_Two_1(i,j),~] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,1,1,0);
        [v1_Two_2(i,j), v2_Two_2(i,j), v_seq1_Two_2(i,j), v_seq2_Two_2(i,j),H1_Two_2(i,j),~,H12_Two_2(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,1,0,1);
        [v1_Two_3(i,j), v2_Two_3(i,j), v_seq1_Two_3(i,j), v_seq2_Two_3(i,j),~,H2_Two_3(i,j),H_12_Two_3(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,0,1,1);
    end
     ChannelStrength = ChannelStrength + channelStrengthStride ;
end

%%%%%%%%%%%%%�ŵ�ֱ�Ӽ�����Կ�ķ���(�������������ŵ�)%%%%%%%%%%%%%%%%
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

clear v_seq1_Two_1;clear v_seq1_Two_2;clear v_seq1_Two_3;
clear v_seq2_Two_1;clear v_seq2_Two_2;clear v_seq2_Two_3;

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


clear Diff_Channel_H1H2;clear Diff_Channel_H2H_12;clear Diff_Channel_H1H_12;

%%%%%%%%%%%%%ʹ���շ���Ƽ�����Կ�ķ���(�������������ŵ�)%%%%%%%%%%%%%%%%
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

clear v1_Two_1;clear v1_Two_2;clear v1_Two_3;
clear v2_Two_1;clear v2_Two_2;clear v2_Two_3;

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

clear Diff_Design_H1H2;clear Diff_Design_H2H_12;clear Diff_Design_H1H_12;

step = 1:channelStrength_Size;

figure(1);
plot(step,MI_Design_H1H2,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H1H2,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_H1H2_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H1H2_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([1 channelStrength_Size 0 10])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');

figure(2);
plot(step,MI_Design_H1H_12,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H1H_12,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_H1H_12_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H1H_12_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([1 channelStrength_Size 0 10])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');


figure(3);

plot(step,MI_Design_H2H_12,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H2H_12,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_H2H_12_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_H2H_12_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([1 channelStrength_Size 0 10])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');


% 
% save ('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_Two.txt', 'MI_Channel_Two','-ascii');
% save ('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_Two.txt', 'MI_Design_Two', '-ascii');
% save ('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterTwoChannel.txt', 'MI_Channel_masterTwoChannel','-ascii');
% save ('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_masterTwoChannel.txt', 'MI_Design_masterTwoChannel', '-ascii');