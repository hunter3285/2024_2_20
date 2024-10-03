function check_neighbor_nodes(obj, x, y, direction)
if ~obj.check_direction([x;y]) || direction>3 || direction<0
    disp('invalid node in check_neighbor_nodes' )
    return;
end
obj.current_x=x;
obj.current_y=y;
obj.current_direction=direction;
[~, ~, x_straight, y_straight, ~, ~]=obj.get_neighbor();
current_node=obj.find_node(x, y, direction);
time=current_node.spent_time;

direction_right=mod(direction-1,4);
direction_left=mod(direction+1, 4);
direction_straight=direction;


node_straight=obj.find_node(x_straight, y_straight, direction_straight);
node_right=obj.find_node(x_straight, y_straight, direction_right);
node_left=obj.find_node(x_straight, y_straight, direction_left);



if ~isempty(node_straight) % all the node exist
    spent_time_straight=time+1;
    spent_time_right=time+obj.turn_cost_right;
    spent_time_left=time+obj.turn_cost_left;
    cost=spent_time_straight+norm([x_straight;y_straight]-obj.dest);
    if cost<node_straight.cost
        if node_straight.visited_state==2
            disp('error s in check_neighbor_nodes')
        end
        node_straight.spent_time=spent_time_straight;
        node_straight.cost=cost;
        node_straight.visited_state=1;
        node_straight.last_x=x;
        node_straight.last_y=y;
        node_straight.last_direction=direction;
        obj.replace_node_in_node_list(node_straight)
    end
    if cost<node_right.cost
        if node_right.visited_state==2
            disp('error r in check_neighbor_nodes')
        end
        node_right.spent_time=spent_time_right;
        node_right.cost=cost;
        node_right.visited_state=1;
        node_right.last_x=x;
        node_right.last_y=y;
        node_right.last_direction=direction;
        obj.replace_node_in_node_list(node_right)
    end
    if cost<node_left.cost
        if node_left.visited_state==2
            disp('error l in check_neighbor_nodes')
        end
        node_left.spent_time=spent_time_left;
        node_left.cost=cost;
        node_left.visited_state=1;
        node_left.last_x=x;
        node_left.last_y=y;
        node_left.last_direction=direction;
        obj.replace_node_in_node_list(node_left)
    end
end
current_node.visited_state=2;
obj.replace_node_in_node_list(current_node);
obj.sort_cost;




end