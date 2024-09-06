function UAV_pos_array=get_start_end(all_step, cell_matrix, distance, cell_side)
UAV_pos_array=[];
for ii=1:size(all_step,2)-1

    current_point=all_step(:, ii);
    next_point=all_step(:, ii+1);
    x1=current_point(1);    y1=current_point(2);
    x2=next_point(1);       y2=next_point(2);
    current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
    % direction=-1;
    % old_direction=direction;
    if x1-x2==1
        direction=2;
        UAV_start=[current_middle(1)+cell_side/2; current_middle(2)-distance-cell_side/2];
        UAV_end=[current_middle(1)-cell_side/2; current_middle(2)-distance-cell_side/2];
    elseif x2-x1==1
        direction=0;
        UAV_start=[current_middle(1)-cell_side/2; current_middle(2)+distance+cell_side/2];
        UAV_end=[current_middle(1)+cell_side/2; current_middle(2)+distance+cell_side/2];
    elseif y1-y2==1
        direction=3;
        UAV_start=[current_middle(1)+distance+cell_side/2; current_middle(2)+cell_side/2];
        UAV_end=[current_middle(1)+distance+cell_side/2; current_middle(2)-cell_side/2];
    elseif y2-y1==1
        direction=1;
        UAV_start=[current_middle(1)-distance-cell_side/2; current_middle(2)-cell_side/2];
        UAV_end=[current_middle(1)-distance-cell_side/2; current_middle(2)+cell_side/2];
    else
        disp('error diagonal');
    end
    UAV_pos_array=[UAV_pos_array, UAV_start, UAV_end];

end
current_point=all_step(:, end);
current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;

switch direction
    case 0
        UAV_start=[current_middle(1)+cell_side/2; current_middle(2)-distance];
        UAV_end=[current_middle(1)-cell_side/2; current_middle(2)-distance];
    case 1
        UAV_start=[current_middle(1)-distance; current_middle(2)-cell_side/2];
        UAV_end=[current_middle(1)-distance; current_middle(2)+cell_side/2];
    case 2
        UAV_start=[current_middle(1)-cell_side/2; current_middle(2)+distance];
        UAV_end=[current_middle(1)+cell_side/2; current_middle(2)+distance];
    case 3
        UAV_start=[current_middle(1)+distance; current_middle(2)+cell_side/2];
        UAV_end=[current_middle(1)+distance; current_middle(2)-cell_side/2];
end
UAV_pos_array=[UAV_pos_array, UAV_start, UAV_end];


end