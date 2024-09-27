function valid=go_a_step(obj)
    valid=1;
    x=obj.current_x;
    y=obj.current_y;
    direction=obj.current_direction;
    time=obj.current_time;
    rate=obj.sum_rate;
    visited_indicator_matrix=obj.visited_indicator_matrix;
    visited_indicator_matrix_2=obj.visited_indicator_matrix_2;


    [x_right, y_right, x_straight, y_straight, x_left, y_left]=obj.get_neighbor();
    [visited_if_right, visited_if_straight, visited_if_left]=obj.get_current_visited();


    valid_right=obj.check_direction([x_right; y_right])*(time+obj.turn_cost_right<=obj.time_slot_max);
    valid_left=obj.check_direction([x_left; y_left])*(time+obj.turn_cost_left<=obj.time_slot_max);
    valid_straight=obj.check_direction([x_straight; y_straight])*(time+1<=obj.time_slot_max);

    gained_rate_right=0;
    for ii=1:obj.turn_cost_right*valid_right
        gained_rate_right=gained_rate_right+obj.get_rate(obj.current_x, obj.current_y, time+ii-1);
    end
    
    gained_rate_right=gained_rate_right*valid_right;

    if valid_straight
        gained_rate_straight=obj.get_rate(obj.current_x, obj.current_y, time+1-1);
    else
        gained_rate_straight=0;
    end
    
    gained_rate_straight=gained_rate_straight*valid_straight;

    gained_rate_left=0;
    for ii=1:obj.turn_cost_left*valid_left
        gained_rate_left=gained_rate_left+obj.get_rate(obj.current_x, obj.current_y, time+ii-1);
    end
    
    gained_rate_left=gained_rate_left*valid_left;

    average_rate_right=gained_rate_right/obj.turn_cost_right;
    average_rate_left=gained_rate_left/obj.turn_cost_left;
    average_rate_staight=gained_rate_straight;

    
    

    score_right=(average_rate_right+obj.mean_rate*(visited_if_right==0))*valid_right;
    if valid_right
        score_right=score_right+obj.get_rate(x_right, y_right, time+obj.turn_cost_right-1);
    end
    score_left=(average_rate_left+obj.mean_rate*(visited_if_left==0))*valid_left;
    if valid_left
        score_left=score_left+obj.get_rate(x_left, y_left, time+obj.turn_cost_left-1);
    end
    score_straight=(average_rate_staight+obj.mean_rate*(visited_if_straight==0))*valid_straight;
    if valid_straight
        score_straight=score_straight+obj.get_rate(x_straight, y_straight, time+1-1);
    end
%     valid_right
%     valid_left
%     valid_straight
%     time
    max_score=max([score_right, score_left, score_straight]);
    
    if max_score<=0
        valid=0;
        return;
    else
        obj.all_step=[obj.all_step,[x;y]];
    end
    if max_score==score_right
%         disp('right')
        x=x_right;
        y=y_right;
        direction=mod(direction-1,4);
        time=time+obj.turn_cost_right;
        rate=rate+gained_rate_right+obj.mean_rate*(visited_if_right==0);
        added_rate=gained_rate_right;
    elseif max_score==score_straight
%         disp('straight')
        x=x_straight;
        y=y_straight;
        time=time+1;
        rate=rate+gained_rate_straight+obj.mean_rate*(visited_if_straight==0);
        added_rate=gained_rate_straight;
    elseif max_score==score_left
%         disp('left')
        x=x_left;
        y=y_left;
        direction=mod(direction+1, 4);
        time=time+obj.turn_cost_left;
        rate=rate+gained_rate_left+obj.mean_rate*(visited_if_left==0);
        added_rate=gained_rate_left;
    end

    if direction==0||direction==2
        visited_indicator_matrix(obj.current_x,obj.current_y)=1;
    else
        visited_indicator_matrix_2(obj.current_x,obj.current_y)=1;
    end
%     added_time=time-obj.current_time;
    
    obj.visited_indicator_matrix=visited_indicator_matrix;
    obj.visited_indicator_matrix_2=visited_indicator_matrix_2;
    obj.sum_rate=rate;
    obj.current_x=x;
    obj.current_y=y;
    obj.current_direction=direction;
    obj.rate_vec(obj.current_time+1:time)=obj.rate_vec(obj.current_time)+added_rate;
    obj.current_time=time;
    
    

        
end