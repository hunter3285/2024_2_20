function BCD_for_pow_path(obj)
ii=1;
obj.N_iter=0;
obj.BCD_rate_row_old=obj.BCD_rate_row;
obj.BCD_rate_row=[];
while ~isequal(obj.all_step, obj.all_step_old)  && ii<=obj.N_max_pow_path% after some power optimization, the path has changed
    disp(['one UAV has power path BCD ', num2str(ii), 'th iteration'])
    obj.N_iter=obj.N_iter+1;
    obj.BCD_rate_row(obj.N_iter)=obj.sum_rate; % before finding the path again
    obj.power_parameters();
    obj.power_optimization();
    improvement_in_this_iteration=obj.get_correct_rate()+obj.n_grid*obj.mean_rate-obj.sum_rate
    obj.record_result();
    obj.clear_dp();
    obj.get_dp_result();
    diff_pow_path=(obj.get_correct_rate+obj.n_grid*obj.mean_rate-obj.sum_rate)*isequal(obj.all_step, obj.all_step_old)
    if obj.get_correct_rate+obj.n_grid*obj.mean_rate-obj.sum_rate_old<-1e-3
        obj.sum_rate
        obj.sum_rate_old
        disp("BCD didn't improve rate in BCD_for_pow_path")
    end
    ii=ii+1;
end
% Now, all_step and all_step_old is equal
% It means that the power and the path are matched
if abs(obj.get_correct_rate()-obj.rate_after_power_opt)>1e-3
    disp('rate error in BCD_for_pow_path')
    obj.get_correct_rate()
    obj.rate_after_power_opt
end
obj.BCD_rate_row(obj.N_iter+1)=obj.sum_rate;
disp('BCD_for_pow_path ended')
end