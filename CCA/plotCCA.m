
clear;
clc;
channelStrength_Size =11;
for i = 0:channelStrength_Size-1
    step(i+1) =  i/(channelStrength_Size-1);
end
MI_Design_One = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_One.txt');
MI_Channel_One = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_One.txt');
MI_Design_masterOneChannel_data = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_masterOneChannel.txt');
MI_Channel_masterOneChannel_data = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterOneChannel.txt');
figure(1);

plot(step,MI_Design_One,'b-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_One,'r-d','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterOneChannel_data,'b--v','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterOneChannel_data,'r--v','LineWidth',1.5);
hold off;
grid on;
axis([0 1 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('�շ���Ƶ���Կ����Ϣ','�ŵ���������Կ����Ϣ','�շ���Ƶ���Ϣй¶����','�ŵ���������Ϣй¶����','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');


MI_Design_Two = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_Two.txt');
MI_Channel_Two  = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_Two.txt');
MI_Design_masterTwoChannel_data= load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_masterTwoChannel.txt');
MI_Channel_masterTwoChannel_data= load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterTwoChannel.txt');

figure(2);

plot(step,MI_Design_Two,'b-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Two,'r-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterTwoChannel_data,'r--v','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterTwoChannel_data,'b--v','LineWidth',1.5);
hold off;
grid on;
axis([0 1 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('�շ����������Կ�Ļ���Ϣ','ֱ�������������Կ����Ϣ','�շ����������Կ����Ϣй¶����','ֱ�������������Կ����Ϣй¶����','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');


MI_Design_Three = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_Three.txt');
MI_Channel_Three  = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_Three.txt');
MI_Design_masterThreeChannel_data= load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Design_masterThreeChannel.txt');
MI_Channel_masterThreeChannel_data= load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Channel_masterThreeChannel.txt');

figure(3);
plot(step,MI_Design_Three,'c-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_Three,'r-d','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterThreeChannel_data,'c--v','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterThreeChannel_data,'r--v','LineWidth',1.5);
hold off;
grid on;
axis([0 1 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('�շ����������Կ�Ļ���Ϣ','ֱ�������������Կ����Ϣ','�շ����������Կ����Ϣй¶����','ֱ�������������Կ����Ϣй¶����','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');

MI_Original_Model =  load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\MI_Original_Model.txt');
LeakInf_Original_Model = load('E:\�о���\��������Ŀ\physical-key-generation-master\mySim\result\CCA\LeakInf_Original_Model.txt');

figure(4);

plot(step,MI_Design_One,'r-d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_One,'g-o','LineWidth',1.5);
hold on;
plot(step,MI_Design_masterOneChannel_data,'r--d','LineWidth',1.5);
hold on;
plot(step,MI_Channel_masterOneChannel_data,'g--v','LineWidth',1.5);
hold on;
plot(step,MI_Original_Model,'b-o','LineWidth',1.5);
hold on;
plot(step,LeakInf_Original_Model,'b-d','LineWidth',1.5);
hold off;
grid on;
axis([0 1 0 1])
%legend('cor = 0, V|Ve^1','cor = 0, V|Ve^2','cor = 0, V_h|Ve','cor = 0.6, V|Ve^1','cor = 0.6, V|Ve^2','cor = 0.6, V_h|Ve');
legend('�շ���Ƶ���Կ����Ϣ','�ŵ�������Կ�Ļ���Ϣ','�շ���Ƶ�й¶��Ϣ','�ŵ�������й¶��Ϣ','�����ŵ�����Կ����Ϣ','�����ŵ���й¶��Ϣ','Fontname','<����>');
xlabel('�����ŵ�ǿ��','Fontname','<����>');
ylabel('����Ϣ','Fontname','<����>');



