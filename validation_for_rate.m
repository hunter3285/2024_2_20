function valid=validation_for_rate(all_step_with_time, n_grid, mean_rate, sum_rate_optimal_dp)
load('cell_matrix.mat', 'all_rate_matrix')
rate=0;
count=0;
for ii = 1: size(all_step_with_time,2)
    x=all_step_with_time(1,ii);
    y=all_step_with_time(2,ii);
    if x~=0 && y~=0
        rate=rate+all_rate_matrix(x,y);
        count=count+1;
    end
end
count
mean_rate
rate=rate+mean_rate*(n_grid)
sum_rate_optimal_dp
if abs(rate-sum_rate_optimal_dp)<1e-4
% if rate==sum_rate_optimal_dp
    valid=1;
else
    valid=abs(rate-sum_rate_optimal_dp);
end