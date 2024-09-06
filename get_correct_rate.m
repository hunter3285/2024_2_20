function [rate, rate_vec] = get_correct_rate(all_step, power_vec, cell_matrix)
all_step_with_time=StepWithTimeSlot(all_step);
rate=0;
rate_vec=zeros(1,size(all_step_with_time,2));
for ii=1:size(all_step_with_time,2)
    x=all_step_with_time(1,ii);
    y=all_step_with_time(2,ii);
    if x~=0 && y~=0
        coef_vec=cell_matrix(x,y).coef_array; % N_user * 1
        p=power_vec(ii);
        N_user=cell_matrix(x,y).N_user;
        noice_variance=cell_matrix(x,y).noise_variance;
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