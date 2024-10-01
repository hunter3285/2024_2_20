function node=extract_min_unvisited_node(obj)
node=[];
for ii=1:length(obj.node_list)
    n=obj.node_list(ii);
    if n.visited_state==0
        disp('error in extract_min_unvisited_node')
        return;
    end
    if n.visited_state==1
        node=n;
        return;
    end
end
end