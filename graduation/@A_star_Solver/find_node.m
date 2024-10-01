function node=find_node(obj, x, y, direction)
node=[];
for ii=1:length(obj.node_list)
    target_node=obj.node_list(ii);
    if target_node.x==x && target_node.y==y && target_node.direction==direction
        node=target_node;
        return;
    end
end
end