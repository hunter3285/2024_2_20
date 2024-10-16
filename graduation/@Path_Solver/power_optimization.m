function power_optimization(obj)
coef_matrix=obj.step_coef_matrix;
p_max_total=obj.p_max_total;
p_min=obj.p_min;
p_max=obj.p_max;
time_slot_max=obj.time_slot_max;
noise_variance_matrix=obj.step_noise_variance_matrix; 
N_user_vec=obj.step_N_user_vec;
noise_variance=noise_variance_matrix(1,1);

cvx_begin quiet
    variable p(1, time_slot_max)
    val=0;
    for ii=1:time_slot_max
        for jj=1:N_user_vec(ii)
            snr=p(ii)*coef_matrix(jj,ii)/noise_variance;
            rate=log(1+snr)/log(2);
            if N_user_vec(ii)~=0
                rate=rate/N_user_vec(ii);
            end
            val=val+rate;
        end
    end
    maximize val
    subject to
        p>=ones(1, time_slot_max)*p_min;
        p<=ones(1, time_slot_max)*p_max;
        sum(p)<=p_max_total;

cvx_end
optval=cvx_optval;

obj.power_vec=p;
obj.rate_after_power_opt=optval;
clear;
end