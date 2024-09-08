function BCD_for_pow_path(obj)
while ~isequal(obj.all_step, obj.all_step_old)
    obj.N_iter=obj.N_iter+1;
    obj.power_parameters();
    obj.power_optimization();
    gain_after_power_opt_class=obj.get_correct_rate()+obj.n_grid*obj.mean_rate-obj.sum_rate
    obj.clear();
    obj.record_result();
    obj.get_dp_result();
    difference=(obj.get_correct_rate+obj.n_grid*obj.mean_rate-obj.sum_rate)...
        *isequal(obj.all_step, obj.all_step_old)
end
disp('BCD ended')
end