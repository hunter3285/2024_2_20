function [rate, rate_vec] = get_correct_rate(obj)
all_step=obj.all_step;
power_vec=obj.power_vec;
% cell_matrix=obj.cell_matrix;
coef_vec_cell_matrix=obj.coef_vec_cell_matrix;
N_user_matrix=obj.N_user_matrix;
all_step_with_time=obj.StepWithTimeSlot(all_step);
rate=0;
rate_vec=zeros(1,size(all_step_with_time,2));
for ii=1:size(all_step_with_time,2)
    x=all_step_with_time(1,ii);
    y=all_step_with_time(2,ii);
    if x~=0 && y~=0
%         coef_vec=coef_vec_cell_matrix(x,y).coef_array; % N_user * 1
        coef_vec=coef_vec_cell_matrix(x,y,:);
        p=power_vec(ii);
        N_user=N_user_matrix(x,y);
        noice_variance=obj.noise_variance;
        snr_vec=p*coef_vec/noice_variance;
        gained_rate=sum(log2(1+snr_vec));
        if N_user~=0
            gained_rate=gained_rate/N_user;
        end
        rate=rate+gained_rate;
        rate_vec(ii)=rate;
    else
        rate_vec(ii)=rate;
    end
    
end
if ~isempty(obj.rate_after_power_opt) && obj.rate_after_power_opt~=rate
    disp('error in get_correct_rate at Path_Solver')
    obj.rate_after_power_opt
    rate
end