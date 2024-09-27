function [x_right, y_right, x_straight, y_straight, x_left, y_left]=get_neighbor(obj)
direction=obj.current_direction;
x=obj.current_x;
y=obj.current_y;
if direction==0 % facing right
    x_right=x;
    y_right=y-1;

    x_straight=x+1;
    y_straight=y;


    x_left=x;
    y_left=y+1;

elseif direction==1 % facing upwards
    x_right=x+1;
    y_right=y;


    x_straight=x;
    y_straight=y+1;

    
    x_left=x-1;
    y_left=y;

elseif direction==2 % facing left
    x_right=x;
    y_right=y+1;


    x_straight=x-1;
    y_straight=y;


    x_left=x;
    y_left=y-1;

elseif direction==3 % facing downwards
    x_right=x-1;
    y_right=y;


    x_straight=x;
    y_straight=y-1;


    x_left=x+1;
    y_left=y;

end
if ~obj.check_direction([x_right;y_right])
    x_right=0;
    y_right=0;
end
if ~obj.check_direction([x_straight;y_straight])
    x_straight=0;
    y_straight=0;
end
if ~obj.check_direction([x_left;y_left])
    x_left=0;
    y_left=0;
end




end