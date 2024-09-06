function [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp, N_user_matrix, time_slot_max, noise_variance)
N_user_max=max(N_user_matrix,[], 'all');
coef_matrix=zeros(N_user_max, time_slot_max);

steps=StepWithTimeSlot(all_step_dp);
N_user_vec=zeros(size(steps, 2),1);
for ii=1:size(steps, 2)
    x=steps(1,ii);
    y=steps(2,ii);
    if x==0 && y==0
        continue;
    end
    N_user=N_user_matrix(x,y);
    coef_matrix(1:N_user,ii)=cell_matrix(x,y).coef_array;
%     coef_matrix(1,ii)=cell_matrix(x,y).coef_array;
    N_user_vec(ii)=N_user;
end

noise_variance_matrix=ones(N_user_max, time_slot_max)*noise_variance;