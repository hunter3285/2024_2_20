function sort_cost(obj)
cost_list=zeros(1, length(obj.node_list));
for ii=1:length(obj.node_list)
    cost_list(ii)=obj.node_list(ii).cost;
end
[~, ind]=sort(cost_list);
obj.node_list=obj.node_list(ind);
end