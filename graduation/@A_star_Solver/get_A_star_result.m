function get_A_star_result(obj)
    obj.create_node_list;
    obj.get_first_step;
    min_node=obj.extract_min_unvisited_node;
    min_x=min_node.x;
    min_y=min_node.y;
    min_direction=min_node.direction;
    while ~(min_x==obj.dest(1) && min_y==obj.dest(2))
%     for ii=1:100
        obj.check_neighbor_nodes(min_x, min_y, min_direction);
        min_node=obj.extract_min_unvisited_node;
        min_x=min_node.x;
        min_y=min_node.y;
        min_direction=min_node.direction;
    end
    visited_matrix=zeros(obj.N_cell_x, obj.N_cell_y);
%     for ii=1:obj.N_cell_x
%         for jj=1:obj.N_cell_y
%             for kk=1:4
%                 n=obj.find_node(ii,jj,kk-1);
%                 if n.visited_state==2
%                     visited_matrix(ii,jj)=1;
%                 end
%             end
%         end
%     end
%     visited_matrix
% now, min_x and min_y are dest
n=1;
last_x=min_node.last_x;
last_y=min_node.last_y;
last_direction=min_node.last_direction;
visited_matrix(min_x, min_y)=n;
while ~isempty(last_x)
    n=n+1;
    visited_matrix(last_x, last_y)=n;
    min_node=obj.find_node(last_x, last_y, last_direction);
    last_x=min_node.last_x;
    last_y=min_node.last_y;
    last_direction=min_node.last_direction;

end
n=n+1;
visited_matrix(last_x, last_y)=n
    

end