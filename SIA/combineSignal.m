function y = combineSignal(s1, s2)
%%补充数据
if length(s1)>length(s2)
    padding = repmat(0+0i,length(s1)-length(s2),1);
    s2 = [s2;padding];%用0进行填补
else
    padding = repmat(0+0i,length(s2)-length(s1),1);
    s1 = [s1;padding];%用0进行填补
end
y = s1+s2;
