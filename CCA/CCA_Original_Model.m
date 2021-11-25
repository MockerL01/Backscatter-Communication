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
c_flag = 1;

% generate the data 
% rand_ints_gen = randi(2,n_fft*mod_order*K,1)-1;
% save data_input.txt -ascii rand_ints_gen
rand_ints = load("data_input_256.txt");
data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, c_flag);
num_sim = 10000;
channelStrength_Size = 11;
channelStrength = 0;
channelStrengthStride = 0.1;

v1 = zeros(channelStrength_Size,1);
v2 = zeros(channelStrength_Size,1);
H = zeros(channelStrength_Size,1);
MI_Original_Model = zeros(channelStrength_Size,1);
LeakInf_Original_Model = zeros(channelStrength_Size,1);
for j = 1:channelStrength_Size
    for i = 1:num_sim
        [v1(i,j),v2(i,j),H(i,j)] = generate_key_bit_CCA_Original_Model(data_ofdm, n_ofdm, n_cp ,n_frame,j);
    end
    channelStrength = channelStrength + channelStrengthStride ;
end



mean_v1 = repmat(mean(v1),length(num_sim),1);
v1 = double(v1>=mean_v1);
mean_v2 = repmat(mean(v2),length(num_sim),1);
v2 = double(v2>=mean_v2);
mean_H = repmat(mean(H),length(num_sim),1);
H = double(H>=mean_H);

for j = 1:channelStrength_Size
    MI_Original_Model(j) = mi(v1(:,j),v2(:,j));
    temp1 = mi(v1(:,j),H(:,j));
    temp2 = mi(v2(:,j),H(:,j));
   	LeakInf_Original_Model(j) = max(temp1,temp2);
end


save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Original_Model.txt', 'MI_Original_Model','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\LeakInf_Original_Model.txt', 'LeakInf_Original_Model', '-ascii');




