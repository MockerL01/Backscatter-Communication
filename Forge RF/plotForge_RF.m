clear;
clc;
step = 1:1:10;

MI_Design_Key = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\Forge RF\MI_Design_Key.txt');
MI_Channel_Key = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\Forge RF\MI_Channel_Key.txt');
leakInfo_Design = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Design.txt');
leakInfo_Channel = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\Forge RF\leakInfo_Channel.txt');
figure(1);

plot(step,MI_Design_Key,'c-s','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Key,'r-o','LineWidth',1.5);
hold on;
plot(step,leakInfo_Design,'g--d','LineWidth',1.5);
hold on;
plot(step,leakInfo_Channel,'--v','LineWidth',1.5);
hold off;
grid on;
axis([1 10 0 8])

legend('�շ����������Կ�Ļ���Ϣ','ֱ��������ɵ���Կ����Ϣ','�շ���Ƶ���Ϣй¶����','ֱ���������Ϣй¶����','Fontname','<����>');
xlabel('ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');