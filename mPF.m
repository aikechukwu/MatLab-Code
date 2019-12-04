for kk = 1:length(PF)
QQ(kk,:) = PF(kk).Position;
end

Q = sortrows(QQ);
jj = [];
for ii = 2:size(Q,1)
if Q(ii,:)==Q(ii-1,:)
jj = [jj ii];
end
end
QQ = removerows(Q,'ind',jj);
nPF = size(QQ,1);
