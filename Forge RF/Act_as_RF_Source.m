addpath('E:\研究生\背反射项目\physical-key-generation-master\MIToolbox-master\matlab');

% modulation methods: BPSK, QPSK,16QAM, 32QAM,64QAM
mod_method = 'QPSK';
% calculate modulation order from modulation method
mod_methods = {'BPSK', 'QPSK','8PSK','16QAM', '32QAM','64QAM'};
mod_order = find(ismember(mod_methods, mod_method));
rand_ints = load("data_input.txt");

n_fft = 256;
n_cp = n_fft/4;    % size of cyclic prefix extension
n_ofdm = n_fft + n_cp;
n_frame = 1;   
K = 1;
c_flag = 1;
num_size = 1000;

maxSignalStrength = 10;

v1 = zeros(num_size,maxSignalStrength);
v2 = zeros(num_size,maxSignalStrength);
seq1 = zeros(num_size,maxSignalStrength);
seq2 = zeros(num_size,maxSignalStrength);
h1 = zeros(8,maxSignalStrength);
h2 = zeros(7,maxSignalStrength);
leakInfoH1  = zeros(num_size,maxSignalStrength);
leakInfoH2  = zeros(num_size,maxSignalStrength);
MI_Channel_Key = zeros(maxSignalStrength,1);
MI_Design_Key = zeros(maxSignalStrength,1);
leakInfo_Channel = zeros(maxSignalStrength,1);
leakInfo_Design = zeros(maxSignalStrength,1);

for signalStrength = 1:maxSignalStrength
    data_ofdm = ofdm_module_forgeRF(rand_ints, mod_method, n_fft, n_cp, 1,signalStrength);
    for i = 1:num_size
        [v1(i,signalStrength),v2(i,signalStrength),seq1(i,signalStrength),seq2(i,signalStrength),h1(:,signalStrength),h2(:,signalStrength)] = generate_key_bit_forgeRF(data_ofdm, n_ofdm,n_cp ,n_frame);
        leakInfoH1(i,signalStrength) = mean(abs(conv(data_ofdm,h1(:,signalStrength))));
        leakInfoH2(i,signalStrength) = mean(abs(conv(data_ofdm,h2(:,signalStrength))));
    end
end

for j = 1:maxSignalStrength
    MI_Channel_Key(j) = mi(seq1(:,j),seq2(:,j));
    MI_Design_Key(j) = mi(v1(:,j),v2(:,j));
    %%%%%%信道分析法%%%%%%%
    leakInfo_Channel_H1_Key1 = mi(seq1(:,j),leakInfoH1(:,j));
    leakInfo_Channel_H1_Key2 = mi(seq2(:,j),leakInfoH1(:,j));
    leakInfo_Channel_H1 = max(leakInfo_Channel_H1_Key1,leakInfo_Channel_H1_Key2);
    
    leakInfo_Channel_H2_Key1 = mi(seq1(:,j),leakInfoH2(:,j));
    leakInfo_Channel_H2_Key2 = mi(seq2(:,j),leakInfoH2(:,j));
    leakInfo_Channel_H2= max(leakInfo_Channel_H2_Key1,leakInfo_Channel_H2_Key2);
    
    leakInfo_Channel(j) = max(leakInfo_Channel_H1,leakInfo_Channel_H2);
    %%%%%%收发设计%%%%%%%%
    leakInfo_Design_H1_Key1 = mi(v1(:,j),leakInfoH1(:,j));
    leakInfo_Design_H1_Key2 = mi(v2(:,j),leakInfoH1(:,j));
    leakInfo_Design_H1 = max(leakInfo_Design_H1_Key1,leakInfo_Design_H1_Key2);
    
    leakInfo_Design_H2_Key1 = mi(v1(:,j),leakInfoH2(:,j));
    leakInfo_Design_H2_Key2 = mi(v2(:,j),leakInfoH2(:,j));
    leakInfo_Design_H2 = max(leakInfo_Design_H2_Key1,leakInfo_Design_H2_Key2);
    
    leakInfo_Design(j) = max(leakInfo_Design_H1,leakInfo_Design_H2);
end

save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\MI_Channel_Key.txt', 'MI_Channel_Key','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\MI_Design_Key.txt', 'MI_Design_Key','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Channel.txt', 'leakInfo_Channel','-ascii');
save ('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Design.txt', 'leakInfo_Design','-ascii');
