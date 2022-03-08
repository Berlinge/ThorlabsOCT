for i=2:size(Set,1)
%     test(:,i-1) = Set{i,3}(:,100);
    test(:,i-1) = mean(Set{i,3}(:,101:200),2);
end
max(octa(test),[],1)
plot(20*log10(abs(test)))
axis tight
ylim([-20 100])