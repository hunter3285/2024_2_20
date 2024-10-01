function check_neighbor_nodes(obj, x, y, direction)
if ~obj.check_direction([x;y]) || direction>3 || direction<0
    disp('invalid node in check_neighbor_nodes' )
    return;
end
obj.current_x=x;
obj.current_y=y;
obj.current_direction=direction;
[x_right, y_right, x_straight, y_straight, x_left, y_left]=obj.get_neighbor();
current_node=obj.find_node(x, y, direction);
time=current_node.spent_time;

direction_right=mod(direction-1,4);
direction_left=mod(direction+1, 4);
direction_straight=direction;

node_right=obj.find_node(x_right, y_right, direction_right);
node_left=obj.find_node(x_left, y_left, direction_left);
node_straight=obj.find_node(x_straight, y_straight, direction_straight);

if ~isempty(node_right)
    spent_time_right=time+obj.turn_cost_right;
    cost_right=spent_time_right+norm([x_right;y_right]-obj.dest);
    if cost_right<node_right.cost
        if node_right.visited_state==2
            disp('error r in check_neighbor_nodes')
        end
        node_right.spent_time=spent_time_right;
        node_right.cost=cost_right;
        node_right.visited_state=1;
        obj.replace_node_in_node_list(node_right)
    end
end
if ~isempty(node_left)
    spent_time_left=time+obj.turn_cost_left;
    cost_left=spent_time_left+norm([x_left;y_left]-obj.dest);
    if cost_left<node_left.cost
        if node_left.visited_state==2
            disp('error r in check_neighbor_nodes')
        end
        node_left.spent_time=spent_time_left;
        node_left.cost=cost_left;
        node_left.visited_state=1;
        obj.replace_node_in_node_list(node_left)
    end
end
if ~isempty(node_straight)
    spent_time_straight=time+1;
    cost_straight=spent_time_straight+norm([x_straight;y_straight]-obj.dest);
    if cost_straight<node_straight.cost
        if node_straight.visited_state==2
            disp('error r in check_neighbor_nodes')
        end
        node_straight.spent_time=spent_time_straight;
        node_straight.cost=cost_straight;
        node_straight.visited_state=1;
        obj.replace_node_in_node_list(node_straight)
    end
end
current_node.visited_state=2;
obj.replace_node_in_node_list(current_node);
obj.sort_cost;




end