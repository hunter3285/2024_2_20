function get_comm_paths(obj)
for ii=1:obj.N_UAV
    disp(['Now is UAV ',num2str(ii)]);

    [sum_rate_optimal_dp_class, ~, ~, ~,  ~, ~, ~, ~, ~]=obj.Solver_row(ii).get_N_th_dp_result(ii);
    [all_step_with_time, last_step_turn, last_turn_right_or_left]=obj.Solver_row(ii).StepWithTimeSlot();
    obj.Solver_row(ii).power_parameters;
    obj.Solver_row(ii).power_optimization;

    obj.last_step_turn_row(ii)=last_step_turn;
    obj.last_turn_right_or_left_row(ii)=last_turn_right_or_left;
    obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
    obj.UAV_rate_row(ii)=sum_rate_optimal_dp_class;
    obj.total_sum_rate_row(ii)=sum(obj.get_total_rate);
end
for ii=1:obj.N_UAV
    %obj.total_sum_rate_row(ii)=sum(obj.get_total_rate);
end
