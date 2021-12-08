% clear
% clc
% addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');
% 
% % modulation methods: BPSK, QPSK,16QAM, 32QAM,64QAM
% mod_method = 'QPSK';
% % calculate modulation order from modulation method
% mod_methods = {'BPSK', 'QPSK','8PSK','16QAM', '32QAM','64QAM'};
% mod_order = find(ismember(mod_methods, mod_method));
% 
% %
% % nfft = 256, K =1
% n_fft = 256;
% n_cp = n_fft/4;    % size of cyclic prefix extension
% n_ofdm = n_fft + n_cp;
% n_frame = 1;   
% K = 1;
% 
% % generate the data 
% % rand_ints_gen = randi(2,n_fft*mod_order*K,1)-1;
% % save data_input_256.txt -ascii rand_ints_gen
% rand_ints = load("data_input_256.txt");
% 
% data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, 1);
% data_cp_pwr = mean(abs(data_ofdm).^2);%平均功率
% 
% num_sim = 50000;
% channelStrength_Size_h1 = 21;
% channelStrength_Size_h2 = 21;
% channelStrength_Size_h12 = 21;
% ChannelStrength_h1  = 0;
% ChannelStrength_h2  = 0;
% ChannelStrength_h12  = 0;
% channelStrengthStride_h1 = 8/20;
% channelStrengthStride_h2 = 7/20;
% channelStrengthStride_h12 = 3/20;
% 
% 
% 
% %%%%%%%%%%%%%%%%%%互信息相关参数%%%%%%%%%%%%%%%
% % 
% % MI_Channel_masterOneChannel = zeros(channelStrength_Size,1);
% % MI_Design_masterOneChannel = zeros(channelStrength_Size,1);
% % MI_Channel_One = zeros(channelStrength_Size,1);
% % MI_Design_One = zeros(channelStrength_Size,1);
% 
% 
% %%%%%%%%%%%%%%%生成密钥相关的信息(同时掌握一条信道)%%%%%%%%%%%%%%%%
% v1_One_H1 = zeros(num_sim,channelStrength_Size_h1);v1_One_H2 =zeros(num_sim,channelStrength_Size_h2 );v1_One_H12 = zeros(num_sim,channelStrength_Size_h12);
% v2_One_H1 = zeros(num_sim,channelStrength_Size_h1);v2_One_H2 = zeros(num_sim,channelStrength_Size_h2 );v2_One_H12 = zeros(num_sim,channelStrength_Size_h12);
% v_seq1_One_H1 = zeros(num_sim,channelStrength_Size_h1);v_seq1_One_H2 = zeros(num_sim,channelStrength_Size_h2 );v_seq1_One_H12 = zeros(num_sim,channelStrength_Size_h12);
% v_seq2_One_H1 = zeros(num_sim,channelStrength_Size_h1);v_seq2_One_H2 = zeros(num_sim,channelStrength_Size_h2 );v_seq2_One_H12 = zeros(num_sim,channelStrength_Size_h12);
% H1_One = zeros(num_sim,channelStrength_Size_h1);H2_One = zeros(num_sim,channelStrength_Size_h2 );H_12_One = zeros(num_sim,channelStrength_Size_h12);
% for j = 1:channelStrength_Size_h1
%     for i = 1:num_sim
%       [v1_One_H1(i,j), v2_One_H1(i,j), v_seq1_One_H1(i,j), v_seq2_One_H1(i,j),H1_One(i,j),~,~] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength_h1,1,0,0);
%       [v1_One_H2(i,j), v2_One_H2(i,j), v_seq1_One_H2(i,j), v_seq2_One_H2(i,j),~,H2_One(i,j),~] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength_h2,0,1,0);
%       [v1_One_H12(i,j), v2_One_H12(i,j), v_seq1_One_H12(i,j), v_seq2_One_H12(i,j),~,~,H_12_One(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength_h12,0,0,1);
%     end
%      ChannelStrength_h1 = ChannelStrength_h1 + channelStrengthStride_h1 ;
%      ChannelStrength_h2 = ChannelStrength_h2 + channelStrengthStride_h2 ;
%      ChannelStrength_h12 = ChannelStrength_h12 + channelStrengthStride_h12  ;
% end
% % ChannelStrength = 0;
% % for j = 1:channelStrength_Size_h2
% % 
% %     for i = 1:num_sim
% %       [v1_One_H2(i,j), v2_One_H2(i,j), v_seq1_One_H2(i,j), v_seq2_One_H2(i,j),~,H2_One(i,j),~] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,0,1,0);
% %     end
% %      ChannelStrength = ChannelStrength + channelStrengthStride_h2 ;
% % end
% % ChannelStrength = 0;
% % for j = 1:channelStrength_Size_h12
% %     for i = 1:num_sim
% %      [v1_One_H12(i,j), v2_One_H12(i,j), v_seq1_One_H12(i,j), v_seq2_One_H12(i,j),~,~,H_12_One(i,j)] = generate_key_bit_CCA(data_ofdm,n_ofdm, n_cp , n_frame,ChannelStrength,0,0,1);
% %     end
% %      ChannelStrength = ChannelStrength + channelStrengthStride_h12  ;
% % end
% 
%  
%       
% 
% mean_v1_One_H1 = repmat(mean(v1_One_H1),num_sim,1);
% v1_One_H1 = double(v1_One_H1>=mean_v1_One_H1);
% mean_v2_One_H1 = repmat(mean(v2_One_H1),num_sim,1);
% v2_One_H1 = double(v2_One_H1>=mean_v2_One_H1);
% 
% mean_v_seq1_One_H1 = repmat(mean(v_seq1_One_H1),num_sim,1);
% v_seq1_One_H1 = double(v_seq1_One_H1>=mean_v_seq1_One_H1);
% mean_v_seq2_One_H1 = repmat(mean(v_seq2_One_H1),num_sim,1);
% v_seq2_One_H1 = double(v_seq2_One_H1>=mean_v_seq2_One_H1);
% 
% mean_v1_One_H2 = repmat(mean(v1_One_H2),num_sim,1);
% v1_One_H2 = double(v1_One_H2>=mean_v1_One_H2);
% mean_v2_One_H2 = repmat(mean(v2_One_H2),num_sim,1);
% v2_One_H2 = double(v2_One_H2>=mean_v2_One_H2);
% 
% mean_v_seq1_One_H2 = repmat(mean(v_seq1_One_H2),num_sim,1);
% v_seq1_One_H2 = double(v_seq1_One_H2>=mean_v_seq1_One_H2);
% mean_v_seq2_One_H2 = repmat(mean(v_seq2_One_H2),num_sim,1);
% v_seq2_One_H2 = double(v_seq2_One_H2>=mean_v_seq2_One_H2);
% 
% mean_v1_One_H12 = repmat(mean(v1_One_H12),num_sim,1);
% v1_One_H12 = double(v1_One_H12>=mean_v1_One_H12);
% mean_v2_One_H12 = repmat(mean(v2_One_H12),num_sim,1);
% v2_One_H12 = double(v2_One_H12>=mean_v2_One_H12);
% 
% mean_v_seq1_One_H12 = repmat(mean(v_seq1_One_H12),num_sim,1);
% v_seq1_One_H12 = double(v_seq1_One_H12>=mean_v_seq1_One_H12);
% mean_v_seq2_One_H12 = repmat(mean(v_seq2_One_H12),num_sim,1);
% v_seq2_One_H12 = double(v_seq2_One_H12>=mean_v_seq2_One_H12);
% 
% 
% mean_H1_One = repmat(mean(H1_One),num_sim,1);
% H1_One = double(H1_One>=mean_H1_One);
% mean_H2_One = repmat(mean(H2_One),num_sim,1);
% H2_One = double(H2_One>=mean_H2_One);
% mean_H_12_One = repmat(mean(H_12_One),num_sim,1);
% H_12_One = double(H_12_One>=mean_H_12_One);
% 
% %%%%%%%%%%%%信道直接计算密钥的方法(只掌握一条信道)%%%%%%%%%%%%%%%%
% MI_Channel_H1 = zeros(channelStrength_Size_h1,1);
% MI_Channel_H1_Attacker = zeros(channelStrength_Size_h1,1);
% MI_Channel_H2 = zeros(channelStrength_Size_h2,1);
% MI_Channel_H2_Attacker = zeros(channelStrength_Size_h2,1);
% MI_Channel_H_12 = zeros(channelStrength_Size_h12,1);
% MI_Channel_H_12_Attacker = zeros(channelStrength_Size_h12,1);
% for j = 1:channelStrength_Size_h1
%     MI_Channel_H1(j) = mi(v_seq1_One_H1(:,j),v_seq2_One_H1(:,j));
%     MI_Channel_KEY1_H1 = mi(v_seq1_One_H1(:,j),H1_One(:,j));
%     MI_Channel_KEY2_H1 = mi(v_seq2_One_H1(:,j),H1_One(:,j));
%     MI_Channel_H1_Attacker(j) = max(MI_Channel_KEY1_H1, MI_Channel_KEY2_H1);
%     Diff_Channel_H1(j) = MI_Channel_H1(j) - MI_Channel_H1_Attacker(j);
% 
%     MI_Channel_H2(j)= mi(v_seq1_One_H2(:,j),v_seq2_One_H2(:,j));
%     MI_Channel_KEY1_H2 = mi(v_seq1_One_H2(:,j),H2_One(:,j));
%     MI_Channel_KEY2_H2 = mi(v_seq2_One_H2(:,j),H2_One(:,j));
%     MI_Channel_H2_Attacker(j) = max(MI_Channel_KEY1_H2, MI_Channel_KEY2_H2);
%     Diff_Channel_H2(j) = MI_Channel_H2(j) - MI_Channel_H2_Attacker(j);
% 
%     MI_Channel_H_12(j) = mi(v_seq1_One_H12(:,j),v_seq2_One_H12(:,j));
%     MI_Channel_KEY1_H_12 = mi(v_seq1_One_H12(:,j),H_12_One(:,j));
%     MI_Channel_KEY2_H_12 = mi(v_seq2_One_H12(:,j),H_12_One(:,j));
%     MI_Channel_H_12_Attacker(j) = max(MI_Channel_KEY1_H_12, MI_Channel_KEY2_H_12);
%     Diff_Channel_H12(j) = MI_Channel_H_12(j) - MI_Channel_H_12_Attacker(j);
%     
%     
% %     MI_Channel_One(j) = max(max(MI_Channel_H1(j),MI_Channel_H2(j)),MI_Channel_H_12(j));
% %     MI_Channel_masterOneChannel(j) = max(max(MI_Channel_H1_Attacker(j),MI_Channel_H2_Attacker(j)),MI_Channel_H_12_Attacker(j));
% end
% % 
% % H1 = mean(mean(H1_One))
% % H2 = mean(mean(H1_One))
% % H12 = mean(mean(H_12_One))
% 
% %%%%%%%%%%%%%使用收发设计计算密钥的方法(只掌握一条信道)%%%%%%%%%%%%%%%%
% MI_Design_H1 = zeros(channelStrength_Size_h1,1);
% MI_Design_H1_Attacker = zeros(channelStrength_Size_h1,1);
% MI_Design_H2 = zeros(channelStrength_Size_h2,1);
% MI_Design_H2_Attacker = zeros(channelStrength_Size_h2,1);
% MI_Design_H_12 = zeros(channelStrength_Size_h12,1);
% MI_Design_H_12_Attacker = zeros(channelStrength_Size_h12,1);
% for j = 1:channelStrength_Size_h1
%     MI_Design_H1(j) = mi(v1_One_H1(:,j),v2_One_H1(:,j));
%     MI_Design_KEY1_H1 = mi(v1_One_H1(:,j),H1_One(:,j));
%     MI_Design_KEY2_H1 = mi(v2_One_H1(:,j),H1_One(:,j));
%     MI_Design_H1_Attacker(j) = max(MI_Design_KEY1_H1, MI_Design_KEY2_H1);
%     Diff_Design_H1(j) = MI_Design_H1(j) - MI_Design_H1_Attacker(j);
%     
%     MI_Design_H2(j) = mi(v1_One_H2(:,j),v2_One_H2(:,j));
%     MI_Design_KEY1_H2 = mi(v1_One_H2(:,j),H2_One(:,j));
%     MI_Design_KEY2_H2 = mi(v2_One_H2(:,j),H2_One(:,j));
%     MI_Design_H2_Attacker(j) = max(MI_Design_KEY1_H2, MI_Design_KEY2_H2);
%      Diff_Design_H2(j) = MI_Design_H2(j) - MI_Design_H2_Attacker(j);
% 
% 
%     MI_Design_H_12(j) = mi(v1_One_H12(:,j),v2_One_H12(:,j));
%     MI_Design_KEY1_H_12 = mi(v1_One_H12(:,j),H_12_One(:,j));
%     MI_Design_KEY2_H_12 = mi(v2_One_H12(:,j),H_12_One(:,j));
%     MI_Design_H_12_Attacker(j) = max(MI_Design_KEY1_H_12, MI_Design_KEY2_H_12);
%     Diff_Design_H12(j) = MI_Design_H_12(j) - MI_Design_H_12_Attacker(j);
% 
% %     MI_Design_One(j) = max(max(MI_Design_H1(j),MI_Design_H2(j)),MI_Design_H_12(j));
% %     MI_Design_masterOneChannel(j) = min(min(MI_Design_H1_Attacker(j),MI_Design_H2_Attacker(j)),MI_Design_H_12_Attacker(j));
% end
% 
% if min(min(sum(Diff_Channel_H1),sum(Diff_Channel_H2)),sum(Diff_Channel_H12))== sum(Diff_Channel_H1)
%     tag1 = 1;
%    for j = 1:channelStrength_Size_h1
%         MI_Channel_One(j) = MI_Channel_H1(j);
%         MI_Channel_masterOneChannel(j) = MI_Channel_H1_Attacker(j);
%    end
% elseif min(min(sum(Diff_Channel_H1),sum(Diff_Channel_H2)),sum(Diff_Channel_H12))== sum(Diff_Channel_H2)
%     tag1 = 2;
%    for j = 1:channelStrength_Size_h2
%         MI_Channel_One(j) = MI_Channel_H2(j);
%         MI_Channel_masterOneChannel(j) = MI_Channel_H2_Attacker(j);
%    end
% elseif min(min(sum(Diff_Channel_H1),sum(Diff_Channel_H2)),sum(Diff_Channel_H12))== sum(Diff_Channel_H12)
%     tag1 = 3;
%    for j = 1:channelStrength_Size_h12
%         MI_Channel_One(j) = MI_Channel_H_12(j);
%         MI_Channel_masterOneChannel(j) = MI_Channel_H_12_Attacker(j);
%    end
% end
% 
% if min(min(sum(Diff_Design_H1),sum(Diff_Design_H2)),sum(Diff_Design_H12))== sum(Diff_Design_H1)
%    tag2 = 1;
%    for j = 1:channelStrength_Size_h1
%         MI_Design_One(j) = MI_Design_H1(j);
%         MI_Design_masterOneChannel(j) = MI_Design_H1_Attacker(j);
%    end
% elseif min(min(sum(Diff_Design_H1),sum(Diff_Design_H2)),sum(Diff_Design_H12))== sum(Diff_Design_H2)
%     tag2 = 2;
%    for j = 1:channelStrength_Size_h2
%         MI_Design_One(j) = MI_Design_H2(j);
%         MI_Design_masterOneChannel(j) = MI_Design_H2_Attacker(j);
%    end
% elseif min(min(sum(Diff_Design_H1),sum(Diff_Design_H2)),sum(Diff_Design_H12))== sum(Diff_Design_H12)
%     tag2 = 3;
%    for j = 1:channelStrength_Size_h12
%         MI_Design_One(j) = MI_Design_H_12(j);
%         MI_Design_masterOneChannel(j) = MI_Design_H_12_Attacker(j);
%    end
% end

% step = 1:channelStrength_Size;

% for i = 0:channelStrength_Size-1
%     step(i+1) =  i/(channelStrength_Size-1);
% end
% 
% step = step(1:channelStrength_Size);

step1 = 0:channelStrengthStride_h1:8;
step2 = 0:channelStrengthStride_h2:7;
step12 = 0:channelStrengthStride_h12:3;
figure(1)
plot(step1,MI_Design_H1,'c-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1,'r-o','LineWidth',1.5);
hold on;
plot(step1,MI_Design_H1_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step1,MI_Channel_H1_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 8 0 1])
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');

figure(2);
plot(step2,MI_Design_H2,'c-d','LineWidth',1.5);
hold on;
plot(step2,MI_Channel_H2,'r-o','LineWidth',1.5);
hold on;
plot(step2,MI_Design_H2_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step2,MI_Channel_H2_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 7 0 1])
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


figure(3);

plot(step12,MI_Design_H_12,'c-d','LineWidth',1.5);
hold on;
plot(step12,MI_Channel_H_12,'r-o','LineWidth',1.5);
hold on;
plot(step12,MI_Design_H_12_Attacker,'k-d','LineWidth',1.5);
hold on;
plot(step12,MI_Channel_H_12_Attacker,'r-o','LineWidth',1.5);
hold off;
grid on;
axis([0 3 0 1])
legend('Design Key','Channel Key','Design Leak','Channel Leak','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');

% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_One.txt', 'MI_Channel_One','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_One.txt', 'MI_Design_One', '-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterOneChannel.txt', 'MI_Channel_masterOneChannel','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterOneChannel.txt', 'MI_Design_masterOneChannel', '-ascii');
% % 

