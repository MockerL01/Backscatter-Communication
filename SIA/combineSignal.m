function y = combineSignal(s1, s2)
%%��������
if length(s1)>length(s2)
    padding = repmat(0+0i,length(s1)-length(s2),1);
    s2 = [s2;padding];%��0�����
else
    padding = repmat(0+0i,length(s2)-length(s1),1);
    s1 = [s1;padding];%��0�����
end
y = s1+s2;
