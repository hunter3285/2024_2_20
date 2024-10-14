function set_edge_time(obj)
index=1;
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        for kk=1:4
            obj.node_number_matrix(ii,jj,kk)=index;
            obj.profit_col(index)=obj.all_rate_matrix(ii,jj);
            index=index+1;
        end
    end
end
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        for kk=1:4
            obj.current_x=ii;
            obj.current_y=jj;
            obj.current_direction=kk-1;
            current_node_number=obj.node_number_matrix(ii,jj,kk);
            [~, ~, x_straight, y_straight, ~, ~]=obj.get_neighbor;
            direction_right=mod(obj.current_direction-1, 4);
            direction_left=mod(obj.current_direction+1, 4);
            direction_straight=obj.current_direction;
            if obj.check_direction([x_straight;y_straight])
                node_number=obj.node_number_matrix(x_straight, y_straight, direction_right+1);
                obj.edge_time(current_node_number, node_number)=obj.turn_cost_right;
                obj.adjacency_matrix(current_node_number, node_number)=1;
                node_number=obj.node_number_matrix(x_straight, y_straight, direction_straight+1);
                obj.edge_time(current_node_number, node_number)=1;
                obj.adjacency_matrix(current_node_number, node_number)=1;
                node_number=obj.node_number_matrix(x_straight, y_straight, direction_left+1);
                obj.edge_time(current_node_number, node_number)=obj.turn_cost_left;
                obj.adjacency_matrix(current_node_number, node_number)=1;
            end
        end
    end
end





for ii=1:size(obj.edge_time,1)
    for jj=1:size(obj.edge_time,2)
        if obj.edge_time(ii,jj)==0
            obj.edge_time(ii,jj)=1e9;
        end
    end
end


end