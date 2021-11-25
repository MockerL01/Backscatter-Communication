% 
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

pt = 10^(-1);
snr = 15;
alpha = 0.3 + 1i*0.4;
% alpha = 1;
pw_noise = pt/10^(snr/10);
% pw_noise = 0;
d = [8, 7, 3];
taps = [8, 7, 3];
n_L = max(taps(1),taps(2))+taps(3)-1;  %最长时延

rand_ints = load("data_input_256.txt");
data_ofdm = ofdm_module(rand_ints, mod_method, n_fft, n_cp, 1);
channelStrength =1;
channelStrength_Size = 10;
num_key = 1000;
MI = zeros(channelStrength_Size,1);
MI2 = zeros(channelStrength_Size,1);
avg = 10;
for i = 1:channelStrength_Size
    for k = 1:avg
            for j = 1:num_key
                h1 = ray_model(d(1),taps(1));
                h2 = ray_model(d(2),taps(2));
                h_12 = ray_model(d(3),taps(3)).*channelStrength.*10;

                H12  = h_12.*channelStrength.*10;

        %         alpha = alpha + 0.01+0.01i;

                % all transmissions in ambient backscatter communication
                y1_d_design = ofdm_trans(data_ofdm,h1,0);
                back1_design = ofdm_back(y1_d_design,alpha,n_ofdm,n_frame);
                mean(abs(y1_d_design));
                mean(abs(back1_design));
                y2_d_design = ofdm_trans(data_ofdm,h2,0);
                back2_design = ofdm_back(y2_d_design,alpha,n_ofdm,n_frame);
                mean(abs(y2_d_design));
                mean(abs(back2_design));
                y1_b_design = ofdm_trans(back2_design,h_12,pw_noise.*d(3));
                y2_b_design = ofdm_trans(back1_design,h_12,pw_noise.*d(3));
                
                mean(abs(y1_b_design));
                mean(abs(y2_b_design));
                
                

                %%使用收发设计

                [y1,y1_cp] = receiver_design(y1_d_design, y1_b_design, n_ofdm, n_cp, n_frame, n_L);
                [y2,y2_cp] = receiver_design(y2_d_design, y2_b_design, n_ofdm, n_cp, n_frame, n_L);
                
                mean(abs(y1));
                mean(abs(y2));

                v_y1_cp = mean(abs(y1_cp));
                v_y2_cp = mean(abs(y2_cp));

                v1(j,i) = v_y1_cp;
                v2(j,i) = v_y2_cp;

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % all transmissions in ambient backscatter communication
                y1_d_design_2 = ofdm_trans(data_ofdm,h1,pw_noise.*d(1));
                back1_design_2 = ofdm_back(y1_d_design_2,alpha,n_ofdm,n_frame);

                y2_d_design_2 = ofdm_trans(data_ofdm,h2,pw_noise.*d(2));
                back2_design_2 = ofdm_back(y2_d_design_2,alpha,n_ofdm,n_frame);

                y1_b_design_2 = ofdm_trans(back2_design_2,h_12,pw_noise.*d(3));
                y2_b_design_2 = ofdm_trans(back1_design_2,h_12,pw_noise.*d(3));
                %%使用收发设计

                [y1_2,y1_cp_2] = receiver_design(y1_d_design_2, y1_b_design_2, n_ofdm, n_cp, n_frame, n_L);
                [y2_2,y2_cp_2] = receiver_design(y2_d_design_2, y2_b_design_2, n_ofdm, n_cp, n_frame, n_L);


                v_y1_cp = mean(abs(y1_cp_2));
                v_y2_cp = mean(abs(y2_cp_2));

                v1_2(j,i) = v_y1_cp;
                v2_2(j,i) = v_y2_cp;
            end
        mean_v1 = repmat(mean(v1),num_key,1);
        v1 = double(v1>=mean_v1);
        mean_v2 = repmat(mean(v2),num_key,1);
        v2 = double(v2>=mean_v2);

        mean_v1_2 = repmat(mean(v1_2),num_key,1);
        v1_2 = double(v1_2>=mean_v1_2);
        mean_v2_2 = repmat(mean(v2_2),num_key,1);
        v2_2 = double(v2_2>=mean_v2_2);     
        
        MI(i) = MI(i) + mi(v1(:,i),v2(:,i));
        MI2(i) = MI2(i) + mi(v1_2(:,i),v2_2(:,i));
    end
    channelStrength = channelStrength + 1;
    
end

MI = MI./avg;
MI2 = MI2./avg;

for i = 1:channelStrength_Size
    diff(i) = sum(abs(v1(:,i)-v2(:,i)));
end


figure(1);
plot(1:channelStrength_Size,MI,"g-v");
hold on;
plot(1:channelStrength_Size,MI2,"r-v");
hold off;
axis([1 channelStrength_Size 0 1])
legend('No noise','Have noise','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');

figure(2);
plot(1:channelStrength_Size,MI-MI2,"g-v");

figure(3);
plot(1:channelStrength_Size,diff,"g-v");
