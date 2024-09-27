function get_first_step(obj)
    start=obj.start;
    obj.all_step=start;
    time=0;
    rate=obj.get_rate(start(1), start(2), time);
    sensing_matrix=obj.sensing_matrix;
    sensing_matrix_2=obj.sensing_matrix_2;
    mean_rate=obj.mean_rate;

    visited_indicator_matrix=zeros(obj.N_cell_x, obj.N_cell_y);
    visited_indicator_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y);
    % get first step
    x1=start(1)+1;
    y1=start(2);
    x2=start(1);
    y2=start(2)+1;
    x3=start(1)-1;
    y3=start(2);
    x4=start(1);
    y4=start(2)-1;
    gain_rate_1=obj.get_rate(x1, y1, time+1-1);
    gain_rate_2=obj.get_rate(x2, y2, time+1-1);
    gain_rate_3=obj.get_rate(x3, y3, time+1-1);
    gain_rate_4=obj.get_rate(x4, y4, time+1-1);
    x_row=[x1,x2,x3,x4];
    y_row=[y1,y2,y3,y4];
    v=[gain_rate_1, gain_rate_2, gain_rate_3, gain_rate_4];
    [value, idx]=max(v);
    direction=idx-1;
    x=x_row(idx);
    y=y_row(idx);
    if direction==0||direction==2
        rate=rate+mean_rate*sensing_matrix(start(1),start(2));
        visited_indicator_matrix(start(1),start(2))=1;
%         rate=rate+mean_rate*sensing_matrix(x,y);
%         visited_indicator_matrix(x,y)=1;
    else
        rate=rate+mean_rate*sensing_matrix_2(start(1),start(2));
        visited_indicator_matrix_2(start(1),start(2))=1;
%         rate=rate+mean_rate*sensing_matrix_2(x,y);
%         visited_indicator_matrix_2(x,y)=1;
    end
    obj.visited_indicator_matrix=visited_indicator_matrix;
    obj.visited_indicator_matrix_2=visited_indicator_matrix_2;
    obj.sum_rate=rate;
    obj.current_x=x;
    obj.current_y=y;
    obj.current_direction=direction;
    obj.current_time=time+1;
    obj.rate_vec=obj.get_rate(start(1), start(2), time);

end