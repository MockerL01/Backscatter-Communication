clc
clear
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
num_size = 50000;

maxSignalStrength = 11;

signalStrength = 0;

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

for j = 1:maxSignalStrength
    data_ofdm = ofdm_module_forgeRF(rand_ints, mod_method, n_fft, n_cp, 1,signalStrength);
    for i = 1:num_size
        [v1(i,j),v2(i,j),seq1(i,j),seq2(i,j),h1(:,j),h2(:,j)] = generate_key_bit_forgeRF(data_ofdm, n_ofdm,n_cp ,n_frame);
        leakInfoH1(i,j) = mean(abs(conv(data_ofdm,h1(:,j))));
        leakInfoH2(i,j) = mean(abs(conv(data_ofdm,h2(:,j))));
    end
    signalStrength = signalStrength+1;
end


mean_v1 = repmat(mean(v1),length(v1),1);
v1 = double(v1>=mean_v1);
mean_v2 = repmat(mean(v2),length(v2),1);
v2 = double(v2>=mean_v2);

mean_seq1 = repmat(mean(seq1),length(seq1),1);
seq1 = double(seq1>=mean_seq1);
mean_seq2 = repmat(mean(seq2),length(seq2),1);
seq2 = double(seq2>=mean_seq2);


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
step = 0:1:maxSignalStrength-1;

plot(step,MI_Design_Key,'b-o','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Key,'r-o','LineWidth',1.5);hold on;
plot(step,leakInfo_Design,'b--v','LineWidth',1.5);
hold on;
plot(step,leakInfo_Channel,'r-d','LineWidth',1.5);
hold off;
grid on;
axis([0 maxSignalStrength-1 0 1])

legend('收发设计的密钥互信息','信道分析的密钥互信息','收发设计的信息泄露比率','信道分析的信息泄露比率','Fontname','<宋体>');
xlabel('强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');