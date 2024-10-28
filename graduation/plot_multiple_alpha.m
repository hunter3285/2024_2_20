% 1. load 原本的
% 2. 改第二個section的檔名
load('multiple_alpha10.mat')
%%

mean_rate_dp_old=mean_rate_dp;
mean_rate_sens_old=mean_rate_sens;
mean_rate_comm_old=mean_rate_comm;
mean_rate_dp_normalized_old=mean_rate_dp_normalized;
mean_rate_sens_normalized_old=mean_rate_sens_normalized;
mean_rate_comm_normalized_old=mean_rate_comm_normalized;
mean_N_SAR_dp_old=mean_N_SAR_dp;
mean_N_SAR_sens_old=mean_N_SAR_sens;
mean_N_SAR_comm_old=mean_N_SAR_comm;
mean_comm_rate_dp_normalized_old=mean_comm_rate_dp_normalized;
mean_comm_rate_sens_nomalized_old=mean_comm_rate_sens_nomalized;
mean_comm_rate_comm_normalized_old=mean_comm_rate_comm_normalized;

mean_comm_rate_dp_old=mean_comm_rate_dp;
mean_comm_rate_sens_old=mean_comm_rate_sens;
mean_comm_rate_comm_old=mean_comm_rate_comm;
%%
load('multiple_different_alpha.mat', 'mean_rate_dp', 'mean_rate_sens', 'mean_rate_comm')
load('multiple_different_alpha.mat', 'mean_rate_dp_normalized', 'mean_rate_sens_normalized', 'mean_rate_comm_normalized')
load('multiple_different_alpha.mat', 'mean_N_SAR_dp', 'mean_N_SAR_sens', 'mean_N_SAR_comm')
load('multiple_different_alpha.mat', 'mean_comm_rate_dp_normalized', 'mean_comm_rate_sens_nomalized', 'mean_comm_rate_comm_normalized')
load('multiple_different_alpha.mat', 'mean_comm_rate_dp', 'mean_comm_rate_sens', 'mean_comm_rate_comm')
%%
mean_rate_dp=(mean_rate_dp+mean_rate_dp_old)/2;
mean_rate_sens=(mean_rate_sens+mean_rate_sens_old)/2;
mean_rate_comm=(mean_rate_comm+mean_rate_comm_old)/2;
mean_rate_dp_normalized=(mean_rate_dp_normalized+mean_rate_dp_normalized_old)/2;
mean_rate_sens_normalized=(mean_rate_sens_normalized+mean_rate_sens_normalized_old)/2;
mean_rate_comm_normalized=(mean_rate_comm_normalized+mean_rate_comm_normalized_old)/2;
mean_N_SAR_dp=(mean_N_SAR_dp+mean_N_SAR_dp_old)/2;
mean_N_SAR_sens=(mean_N_SAR_sens+mean_N_SAR_sens_old)/2;
mean_N_SAR_comm=(mean_N_SAR_comm+mean_N_SAR_comm_old)/2;
mean_comm_rate_dp_normalized=(mean_comm_rate_dp_normalized+mean_comm_rate_dp_normalized_old)/2;
mean_comm_rate_sens_nomalized=(mean_comm_rate_sens_nomalized+mean_comm_rate_sens_nomalized_old)/2;
mean_comm_rate_comm_normalized=(mean_comm_rate_comm_normalized+mean_comm_rate_comm_normalized_old)/2;
mean_comm_rate_dp=(mean_comm_rate_dp+mean_comm_rate_dp_old)/2;
mean_comm_rate_sens=(mean_comm_rate_sens+mean_comm_rate_sens_old)/2;
mean_comm_rate_comm=(mean_comm_rate_comm+mean_comm_rate_comm_old)/2;

%%

figure()
plot(alpha_row, mean_rate_dp, '-o');
hold on
% plot(time_slot_max_row, mean_rate_heu, '-^');
plot(alpha_row, mean_rate_sens, '-x');
plot(alpha_row, mean_rate_comm, '-*');
ylabel('Total performance (bits)')
xlabel('alpha (times of average rate)')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average total performance on different alpha")

figure()
plot(alpha_row, mean_rate_dp_normalized, '-o');
hold on
% plot(time_slot_max_row, mean_rate_heu_normalized, '-^');
plot(alpha_row, mean_rate_sens_normalized, '-x');
plot(alpha_row, mean_rate_comm_normalized, '-*');
xlabel('alpha (times of average rate)')
ylabel('Total normalized performance')
grid on
legend('DP(Proposed)', 'DP for Sensing only', 'DP for Communication only')
title("Average normalized total performance on different alpha")

figure()
plot(alpha_row, mean_N_SAR_dp, '--o');
hold on
% plot(time_slot_max_row, mean_N_SAR_heu, '--^');
plot(alpha_row, mean_N_SAR_sens, '--x');
plot(alpha_row, mean_N_SAR_comm, '--*');
ylabel('Coverage (cells)')
xlabel('alpha (times of average rate)')
grid on
legend('DP(Proposed)', 'DP for Sensing only', 'DP for Communication only')
title("Average SAR coverage on different time limit")

figure()
plot(alpha_row, mean_comm_rate_dp_normalized, '-o');
hold on
% plot(time_slot_max_row, mean_comm_rate_heu_normalized, '-^');
plot(alpha_row, mean_comm_rate_sens_nomalized, '-x');
plot(alpha_row, mean_comm_rate_comm_normalized, '-*');
xlabel('alpha (times of average rate)')
ylabel('Normalized communication performance')
grid on
legend('DP(Proposed)', 'DP for Sensing only', 'DP for Communication only')
title("Average normalized communiation performance on different alpha")

figure()
plot(alpha_row, mean_comm_rate_dp, '-o');
hold on
% plot(time_slot_max_row, mean_comm_rate_heu_normalized, '-^');
plot(alpha_row, mean_comm_rate_sens, '-x');
plot(alpha_row, mean_comm_rate_comm, '-*');
xlabel('alpha (times of average rate)')
ylabel('Communication performance')
grid on
legend('DP(Proposed)', 'DP for Sensing only', 'DP for Communication only')
title("Average communiation performance on different alpha")