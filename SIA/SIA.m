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

% generate the data 
% rand_ints_RF = randi(2,n_fft*mod_order*K,1)-1;
% rand_ints_Mallory = randi(2,n_fft*mod_order*K,1)-1;
% save data_input_256_RF.txt -ascii rand_ints_RF
% save data_input_256_Mallory.txt -ascii rand_ints_Mallory
rand_ints_RF = load("data_input_256_RF.txt");
rand_ints_Mallory = load("data_input_256_Mallory.txt");

data_ofdm_RF = ofdm_module(rand_ints_RF, mod_method, n_fft, n_cp, 1);

num_key = 50000;
signalStrength_Size = 11;
signalStrength = 0;
signalStrengthStride = 1;
avg = 10;

v1_design = zeros(num_key,signalStrength_Size);
v2_design = zeros(num_key,signalStrength_Size);
v1_channel = zeros(num_key,signalStrength_Size);
v2_channel = zeros(num_key,signalStrength_Size);
v1_trad = zeros(num_key,signalStrength_Size);
v2_trad = zeros(num_key,signalStrength_Size);
leakInf_hm1 = zeros(num_key,signalStrength_Size);
leakInf_hm2 = zeros(num_key,signalStrength_Size);
leakInf_hm1_trad = zeros(num_key,signalStrength_Size);
leakInf_hm2_trad = zeros(num_key,signalStrength_Size);

MI_design = zeros(signalStrength_Size,1);
MI_channel = zeros(signalStrength_Size,1);
MI_trad = zeros(signalStrength_Size,1);
MI_leakInf_design = zeros(signalStrength_Size,1);
MI_leakInf_channel = zeros(signalStrength_Size,1);
MI_leakInf_trad = zeros(signalStrength_Size,1);
for i = 1:signalStrength_Size
    data_ofdm_Mallory = ofdm_module_Mallory(rand_ints_Mallory, mod_method, n_fft, n_cp, 1,i);
    for k = 1:avg

        for j = 1:num_key
           [v1_design(j,i),v2_design(j,i),v1_channel(j,i),v2_channel(j,i),leakInf_hm1(j,i),leakInf_hm2(j,i)] = generate_key_bit_SIA(data_ofdm_RF,data_ofdm_Mallory,n_ofdm, n_cp ,n_frame);
           [v1_trad(j,i),v2_trad(j,i),leakInf_hm1_trad(j,i),leakInf_hm2_trad(j,i)] = generate_key_bit_SIA_Original_Model(data_ofdm_RF,data_ofdm_Mallory,n_ofdm, n_cp ,n_frame);
        end
        mean_v1_design = repmat(mean(v1_design(:,i)),num_key,1);
        v1_design(:,i) = double(v1_design(:,i)>=mean_v1_design);
        mean_v2_design = repmat(mean(v2_design(:,i)),num_key,1);
        v2_design(:,i) = double(v2_design(:,i)>=mean_v2_design);
        
        mean_v1_channel = repmat(mean(v1_channel(:,i)),num_key,1);
        v1_channel(:,i) = double(v1_channel(:,i)>=mean_v1_channel);
        mean_v2_channel = repmat(mean(v2_channel(:,i)),num_key,1);
        v2_channel(:,i) = double(v2_channel(:,i)>=mean_v1_channel);
        
        mean_v1_trad = repmat(mean(v1_trad(:,i)),num_key,1);
        v1_trad(:,i) = double(v1_trad(:,i)>=mean_v1_trad);
        mean_v2_trad = repmat(mean(v2_trad(:,i)),num_key,1);
        v2_trad(:,i) = double(v2_trad(:,i)>=mean_v2_trad);
        
        mean_leakInf_hm1 = repmat(mean(leakInf_hm1(:,i)),num_key,1);
        leakInf_hm1(:,i) = double(leakInf_hm1(:,i)>=mean_leakInf_hm1);
        mean_leakInf_hm2 = repmat(mean(leakInf_hm2(:,i)),num_key,1);
        leakInf_hm2(:,i) = double(leakInf_hm2(:,i)>=mean_leakInf_hm2);
      
        mean_leakInf_hm1_trad = repmat(mean(leakInf_hm1_trad(:,i)),num_key,1);
        leakInf_hm1_trad(:,i) = double(leakInf_hm1_trad(:,i)>=mean_leakInf_hm1_trad);
        mean_leakInf_hm2_trad = repmat(mean(leakInf_hm2_trad(:,i)),num_key,1);
        leakInf_hm2_trad(:,i) = double(leakInf_hm2_trad(:,i)>=mean_leakInf_hm2_trad);
        
        MI_leakInf_design(i) =MI_leakInf_design(i)+ max( max(max(max(mi(leakInf_hm1(:,i),v1_design(:,i))),mi(leakInf_hm1(:,i),v2_design(:,i))),mi(leakInf_hm2(:,i),v1_design(:,i))),mi(leakInf_hm2(:,i),v2_design(:,i)));
        MI_leakInf_channel(i) =MI_leakInf_channel(i) + max( max(max(max(mi(leakInf_hm1(:,i),v1_channel(:,i))),mi(leakInf_hm1(:,i),v2_channel(:,i))),mi(leakInf_hm2(:,i),v1_channel(:,i))),mi(leakInf_hm2(:,i),v2_channel(:,i)));
        MI_leakInf_trad(i) =MI_leakInf_trad(i)+ max( max(max(max(mi(leakInf_hm1_trad(:,i),v1_trad(:,i))),mi(leakInf_hm1_trad(:,i),v2_trad(:,i))),mi(leakInf_hm2_trad(:,i),v1_trad(:,i))),mi(leakInf_hm2_trad(:,i),v2_trad(:,i)));
        MI_design(i) = MI_design(i) + mi(v1_design(:,i),v2_design(:,i));
        MI_channel(i) = MI_channel(i) + mi(v1_channel(:,i),v2_channel(:,i));
        MI_trad(i) =  MI_trad(i) + mi(v1_trad(:,i),v2_trad(:,i));
    end
end

MI_design = MI_design./avg;
MI_channel = MI_channel./avg;
MI_trad = MI_trad./avg;
MI_leakInf_design = MI_leakInf_design./avg;
MI_leakInf_channel = MI_leakInf_channel./avg;
MI_leakInf_trad = MI_leakInf_trad./avg;

plot(0:signalStrength_Size-1,MI_design,'g-d','LineWidth',1.5);
hold on;
plot(0:signalStrength_Size-1,MI_channel,'r-d','LineWidth',1.5);
hold on;
plot(0:signalStrength_Size-1,MI_leakInf_design,'g-o','LineWidth',1.5);
hold on;
plot(0:signalStrength_Size-1,MI_leakInf_channel,'r-o','LineWidth',1.5);
hold on;
plot(0:signalStrength_Size-1,MI_trad,'b-d','LineWidth',1.5);
hold on;
plot(0:signalStrength_Size-1,MI_leakInf_trad,'b-o','LineWidth',1.5);
hold off;
grid on;
axis([0 signalStrength_Size-1 0 1])
legend('Design Key','Channel Key','Design Leak','Channel Leak','Trad Key','Trad Leak','Fontname','<宋体>');
xlabel('注入信号强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');
% MI_design = MI_design(1:11);
% MI_channel = MI_channel(1:11);
% MI_leakInf_design=MI_leakInf_design(1:11);
% MI_leakInf_channel=MI_leakInf_channel(1:11);
% MI_trad=MI_trad(1:11);
% MI_leakInf_trad=MI_leakInf_trad(1:11);
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_design.txt', 'MI_design','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_channel.txt', 'MI_channel','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_leakInf_design.txt', 'MI_leakInf_design','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_leakInf_channel.txt', 'MI_leakInf_channel','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_trad.txt', 'MI_trad','-ascii');
% save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\SIA\MI_leakInf_trad.txt', 'MI_leakInf_trad','-ascii');