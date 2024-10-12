function replace_node_in_node_list(obj, node)
x=node.x;
y=node.y;
direction=node.direction;
for ii=1:length(obj.node_list)
    target_node=obj.node_list(ii); % linear search
    if target_node.x==x && target_node.y==y && target_node.direction==direction
        obj.node_list(ii)=node; % update cost
        return;
    end
end
disp('cannot find node in replace_node_in_node_list')
end