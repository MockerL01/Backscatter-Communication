
clear;
clc;
step = 1:1:10;

MI_Design_One = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_One.txt');
MI_Channel_One = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_One.txt');
MI_Design_masterOneChannel_data = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterOneChannel.txt');
MI_Channel_masterOneChannel_data = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterOneChannel.txt');
figure(1);

plot(step,MI_Design_One,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_One,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterOneChannel_data,'g--d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterOneChannel_data,'--v','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 5])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('收发设计生成密钥的互信息','直接相减产生的密钥互信息','收发设计生成密钥的信息泄露比率','直接相减产生的密钥的信息泄露比率','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


MI_Design_Two = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_Two.txt');
MI_Channel_Two  = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_Two.txt');
MI_Design_masterTwoChannel_data= load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterTwoChannel.txt');
MI_Channel_masterTwoChannel_data= load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterTwoChannel.txt');

figure(2);

plot(step,MI_Design_Two,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Two,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterTwoChannel_data,'--v','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterTwoChannel_data,'g--d','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 7])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('收发设计生成密钥的互信息','直接相减产生的密钥互信息','收发设计生成密钥的信息泄露比率','直接相减产生的密钥的信息泄露比率','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');


MI_Design_Three = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_Three.txt');
MI_Channel_Three  = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_Three.txt');
MI_Design_masterThreeChannel_data= load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Design_masterThreeChannel.txt');
MI_Channel_masterThreeChannel_data= load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterThreeChannel.txt');

figure(3);
plot(step,MI_Design_Three,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Three,'r-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterThreeChannel_data,'g--d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterThreeChannel_data,'--v','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 12])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('收发设计生成密钥的互信息','直接相减产生的密钥互信息','收发设计生成密钥的信息泄露比率','直接相减产生的密钥的信息泄露比率','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');

MI_Original_Model =  load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\MI_Original_Model.txt');
LeakInf_Original_Model = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\CCA\LeakInf_Original_Model.txt');

figure(4);
plot(step,MI_Design_One(1:10),'--v','LineWidth',1.5);
hold on;
plot(step,MI_Original_Model,'r-o','LineWidth',1.5);
hold on;
plot(step,LeakInf_Original_Model,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterOneChannel_data(1:10),'g--d','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 7])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('三角信道的密钥互信息','内向信道密钥的互信息','内向信道的泄露信息','三角信道的泄露信息','Fontname','<宋体>');
xlabel('控制信道强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');



