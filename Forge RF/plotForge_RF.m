clear;
clc;
step = 1:1:10;

MI_Design_Key = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\MI_Design_Key.txt');
MI_Channel_Key = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\MI_Channel_Key.txt');
leakInfo_Design = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Design.txt');
leakInfo_Channel = load('E:\研究生\背反射项目\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Channel.txt');
figure(1);

plot(step,MI_Design_Key,'g-s','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Key,'r-o','LineWidth',1.5);
hold on;
plot(step,leakInfo_Design,'g--d','LineWidth',1.5);
hold on;
plot(step,leakInfo_Channel,'r-v','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 1])

legend('收发设计的密钥互信息','信道分析的密钥互信息','收发设计的信息泄露比率','信道分析的信息泄露比率','Fontname','<宋体>');
xlabel('强度','Fontname','<宋体>');
ylabel('互信息','Fontname','<宋体>');