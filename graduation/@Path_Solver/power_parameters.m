function power_parameters(obj)

coef_vec_cell_matrix=obj.coef_vec_cell_matrix;
N_user_matrix=obj.N_user_matrix;
time_slot_max=obj.time_slot_max;
noise_variance=obj.noise_variance;
step_N_user_max=max(N_user_matrix,[], 'all');
step_coef_matrix=zeros(step_N_user_max, time_slot_max);

steps_with_time=obj.StepWithTimeSlot();
step_N_user_vec=zeros(size(steps_with_time, 2),1);
N_max_user=obj.N_max_user;
for ii=1:size(steps_with_time, 2)
    x=steps_with_time(1,ii);
    y=steps_with_time(2,ii);
    if x==0 && y==0
        continue;
    end
    N_user=N_user_matrix(x,y);
    step_coef_matrix(1:N_max_user,ii)=coef_vec_cell_matrix(x,y, :);
%     coef_matrix(1,ii)=cell_matrix(x,y).coef_array;
    step_N_user_vec(ii)=N_user;
end

step_noise_variance_matrix=ones(step_N_user_max, time_slot_max)*noise_variance;

obj.step_coef_matrix=step_coef_matrix;
obj.step_N_user_max=step_N_user_vec;
obj.step_noise_variance_matrix=step_noise_variance_matrix;
obj.step_N_user_vec=step_N_user_vec;