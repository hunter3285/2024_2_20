function [rate, N_SAR, rate_comm]=get_BCD_result(obj)
[sum_rate_optimal_dp, ~, ~, ~,  ~, ~, ~, n_grid, ~]=obj.get_dp_result;
mean_rate=obj.mean_rate;
error_get_BCD_result=obj.get_correct_rate()+n_grid*mean_rate-sum_rate_optimal_dp
obj.power_parameters();
obj.power_optimization();

gain_after_power_get_BCD_result=obj.rate_after_power_opt+n_grid*mean_rate-sum_rate_optimal_dp

obj.record_result();
obj.clear_dp();
[sum_rate_optimal_dp, ~, ~, ~,  ~, ~, ~, n_grid, ~]=obj.get_dp_result();
obj.BCD_for_pow_path();
rate=sum_rate_optimal_dp;
N_SAR=n_grid;
rate_comm=obj.get_correct_rate;
if abs(rate_comm+n_grid*mean_rate-sum_rate_optimal_dp)>1e-3
    disp('error in get_BCD_result')
end
end