function [visited_if_right, visited_if_straight, visited_if_left]=get_current_visited(obj)
direction=obj.current_direction;

visited_indicator_matrix=obj.visited_indicator_matrix;
visited_indicator_matrix_2=obj.visited_indicator_matrix_2;

x=obj.current_x;
y=obj.current_y;



if direction==0 || direction==2
    visited_if_right=visited_indicator_matrix_2(x,y);
    visited_if_straight=visited_indicator_matrix(x,y);
    visited_if_left=visited_indicator_matrix_2(x,y);
else
    visited_if_right=visited_indicator_matrix(x,y);
    visited_if_straight=visited_indicator_matrix_2(x,y);
    visited_if_left=visited_indicator_matrix(x,y);
end

end