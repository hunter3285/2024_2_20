function [Popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec)
load('SARparams.mat', 'p_min', 'p_max')
load('cell_matrix.mat', 'time_slot_max')
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
Popt=p;
end