function valid=check_direction(obj, point_to_check)
N_cell_x=obj.N_cell_x;
N_cell_y=obj.N_cell_y;
if (point_to_check(2)>0 && point_to_check(1)>0 && ...
        point_to_check(2)<=N_cell_y && point_to_check(1)<=N_cell_x)
    valid=1;
else
    valid=0;
end
end