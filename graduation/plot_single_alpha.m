clear all
close all
load('single_different_alpha50.mat')

mean_comm_rate_dp=mean(comm_rate_dp_matrix);
mean_comm_rate_sens=mean(comm_rate_sens_matrix);
mean_comm_rate_comm=mean(comm_rate_comm_matrix);
mean_comm_rate_heu=mean(comm_rate_heu_matrix);




figure()
plot(alpha_row, mean_rate_dp, '-o');
hold on
plot(alpha_row, mean_rate_heu, '-^');
plot(alpha_row, mean_rate_sens, '-x');
plot(alpha_row, mean_rate_comm, '-*');
ylabel('Total performance (bits)')
xlabel('Time limit (Time slots)')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average total performance on different time limit")

figure()
plot(alpha_row, mean_rate_dp_normalized, '-o');
hold on
plot(alpha_row, mean_rate_heu_normalized, '-^');
plot(alpha_row, mean_rate_sens_normalized, '-x');
plot(alpha_row, mean_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Total normalized performance')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average normalized total performance on different time limit")

figure()
plot(alpha_row, mean_N_SAR_dp, '--o');
hold on
plot(alpha_row, mean_N_SAR_heu, '--^');
plot(alpha_row, mean_N_SAR_sens, '--x');
plot(alpha_row, mean_N_SAR_comm, '--*');
ylabel('Coverage (cells)')
xlabel('Time limit (Time slots)')
title("Average coverage on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(alpha_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(alpha_row, mean_comm_rate_heu_normalized, '-^');
plot(alpha_row, mean_comm_rate_sens_nomalized, '-x');
plot(alpha_row, mean_comm_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Normalized communication performance')
title("Average normalized communication performance on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(alpha_row, mean_comm_rate_dp, '-o');
hold on
plot(alpha_row, mean_comm_rate_heu, '-^');
plot(alpha_row, mean_comm_rate_sens, '-x');
plot(alpha_row, mean_comm_rate_comm, '-*');
xlabel('Time limit (Time slots)')
ylabel('Normalized communication performance')
title("Average communication capacity on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')