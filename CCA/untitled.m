% % clc
% % clear
% d = [8, 7, 3];
% taps = [8, 7, 3];
% avg_h1 = 0;
% avg_h2 = 0;
% avg_h12 = 0;
% for i = 1:50000
%     h1 = ray_model(d(1),taps(1));
%     h2 = ray_model(d(2),taps(2));
%     h_12 = ray_model(d(3),taps(3));
%     avg_h1 = avg_h1+mean(abs(h1));
%     avg_h2 = avg_h2+mean(abs(h2));
%     avg_h12 = avg_h12+mean(abs(h_12));
% %     avg_h1 = avg_h1+mean(h1);
% %     avg_h2 = avg_h2+mean(h1);
% %     avg_h12 = avg_h12+mean(abs(h_12));
% end
% 

% avg_h1 = avg_h1./50000;
% avg_h2 = avg_h2./50000;
% avg_h12 = avg_h12./50000;
clc
clear
avg_h1 = 0.1766;
avg_h2 = 0.2213;
avg_h12 = 0.7821;
alpha = 0.3 + 1i*0.4;
alpha  = abs(alpha);
R = alpha*avg_h12*(avg_h1+avg_h2)/2;
R = 1/R;

R2 = avg_h1*avg_h2/(avg_h1+avg_h2+1);
R2 = 1/R2;

R3 = min(avg_h1,avg_h2)/3;
R3 = 1/R3;