function BCD_for_UAV_paths_DP(obj)
    for ii=1:obj.N_UAV
        disp(['Now is UAV ',num2str(ii)]);
        Solver_inst=obj.Solver_row(ii); % DP_Solver
        [total_visited, total_visited_2]=obj.get_total_visited(ii);
        
        sensing_matrix=mod(total_visited+1,2);
        sensing_matrix=sensing_matrix.*obj.fixed_sensing_matrix;
        sensing_matrix_2=mod(total_visited_2+1,2);
        sensing_matrix_2=sensing_matrix_2.*obj.fixed_sensing_matrix_2;
        
        Solver_inst.set_sensing_matrices(sensing_matrix, sensing_matrix_2)
        Solver_inst.clear_dp();
        [sum_rate, ~, ~, ~,  ~, ~, ~, n_grid, ~]=Solver_inst.get_dp_result;
        

        n_grid_count=Solver_inst.count_n_grid();
        if Solver_inst.n_grid~=n_grid_count
            disp('error in BCD_for_UAV_paths n_grid');
            n_grid_count
            n_grid
        end

        


        Solver_inst.power_parameters;
        Solver_inst.power_optimization;
        gain_after_power_opt_multi=Solver_inst.rate_after_power_opt+n_grid*Solver_inst.mean_rate-sum_rate
        Solver_inst.record_result();
        Solver_inst.save_power;
        Solver_inst.clear_dp();
        [sum_rate_optimal_dp_class, ~, ~, ~,  ~, ~, ~, ~, ~]=Solver_inst.get_dp_result(); % based on power, solve path again


        Solver_inst.BCD_for_pow_path();
        [all_step_with_time, last_step_turn, last_turn_right_or_left]=Solver_inst.StepWithTimeSlot();

        obj.last_step_turn_row(ii)=last_step_turn;
        obj.last_turn_right_or_left_row(ii)=last_turn_right_or_left;
        obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
        obj.UAV_rate_row(ii)=sum_rate_optimal_dp_class;
        obj.total_sum_rate_row(ii)=sum(obj.get_total_rate);

    end
    disp('Now its second round')
    %% 
    ii=1;
    Niter=4;
    checked_path=zeros(1, obj.N_UAV);
    n=0;
    N_max=obj.N_max;
    while ~isequal(checked_path, ones(1, obj.N_UAV)) && n<N_max
        n=n+1;
        disp(['Now is UAV ',num2str(ii)]);

        Solver_inst=obj.Solver_row(ii); % DP_Solver
        Solver_inst.record_result();
        Solver_inst.save_power;
        Solver_inst.set_power_vec(ones(1, Solver_inst.time_slot_max)*Solver_inst.p_mean);
        % reset power to avoid local optimal points

        [total_visited, total_visited_2]=obj.get_total_visited(ii);
        sensing_matrix=mod(total_visited+1,2);
        sensing_matrix_2=mod(total_visited_2+1,2);
        Solver_inst.set_sensing_matrices(sensing_matrix, sensing_matrix_2)
        Solver_inst.clear_dp();
        [sum_rate, ~, ~, ~,  all_step, ~, ~, n_grid, ~]=Solver_inst.get_dp_result; % with default power
        

        n_grid_count=Solver_inst.count_n_grid();
        if Solver_inst.n_grid~=n_grid_count
            disp('error in BCD_for_UAV_paths n_grid 2');
            n_grid_count
            n_grid
        end

        

        if ~isequal(Solver_inst.all_step, all_step)
            Solver_inst.power_parameters;
            Solver_inst.power_optimization;
            gain_after_power_opt_multi=Solver_inst.rate_after_power_opt+n_grid*Solver_inst.mean_rate-sum_rate
            Solver_inst.record_result();
            Solver_inst.clear_dp();
            [sum_rate, ~, ~, ~,  ~, ~, ~, ~, ...
                ~]=Solver_inst.get_dp_result();
        else
            Solver_inst.power_vec=Solver_inst.power_vec_old;
        end



        Solver_inst.BCD_for_pow_path();
        [all_step_with_time, last_step_turn, last_turn_right_or_left]=Solver_inst.StepWithTimeSlot();

        obj.last_step_turn_row(ii)=last_step_turn;
        obj.last_turn_right_or_left_row(ii)=last_turn_right_or_left;
%         obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
        if ~isequal(all_step_with_time, obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:))
            
            disp(['UAV ', num2str(ii), ' changed']);
            obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
            checked_path=zeros(1, obj.N_UAV);
            checked_path(ii)=1;
        else
            checked_path(ii)=1;
        end

        obj.UAV_rate_row(ii)=sum_rate;
        obj.total_sum_rate_row(Niter)=sum(obj.get_total_rate);
        ii=mod(ii,3)+1;
        Niter=Niter+1;
    end
    if n>N_max
        disp('exceed max iteration limit')
    end
end