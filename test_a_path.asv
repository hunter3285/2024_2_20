function [current_path_profit, visited, valid, all_step]=test_a_path( path, start, step, starting_profit, N_cell_y, N_cell_x, all_rate_matrix)
    switch step
        case 0
            next_point=[start(1)+1, start(2)];
        case 1
            next_point=[start(1), start(2)+1];
        case 2
            next_point=[start(1)-1, start(2)];
        case 3
            next_point=[start(1), start(2)-1];
        otherwise
            disp('error')
    end
    all_step=zeros(2, length(path)+1);
    valid=check_direction(next_point, N_cell_x, N_cell_y);
    visited=zeros(N_cell_x, N_cell_y);
    visited(start(1), start(2))=1;
    all_step(:,1)=[start(1);start(2)];
    current_point=start;
    current_path_profit=starting_profit;
    for jj=1:length(path)
        current_step=path(jj);
        left=[current_point(1)-1;current_point(2)];
        right=[current_point(1)+1;current_point(2)];
        upper=[current_point(1);current_point(2)+1];
        lower=[current_point(1);current_point(2)-1];
        directions=[right,upper, left, lower];
        switch current_step % step is the memory
            case 2 % turn left
                step=mod(step+1,4);
            case 3 % turn right
                step=mod(step-1,4);
            case 1
            case 0
                break;
                
            otherwise
                disp('error in path')
                break;
        end
        point_to_check=directions(:,step+1); % +1 maps 0:3(step) to 1:4 (col idx)
        valid=check_direction(point_to_check, N_cell_x, N_cell_y);
        if ~valid
            break;
        end
        current_point=point_to_check;
        
        all_step(:,jj+1)=[current_point(1);current_point(2)];
        visited(current_point(1),current_point(2))=jj+1;
        current_path_profit=current_path_profit+all_rate_matrix(current_point(1), current_point(2));
    end
end