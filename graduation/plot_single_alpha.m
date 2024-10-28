clear all
close all
load('single_alpha10.mat')

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
ylabel('Value of objective function (bits)')
xlabel('alpha (times of cell average rate)')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average value of objective function on different alpha")

figure()
plot(alpha_row, mean_rate_dp_normalized, '-o');
hold on
plot(alpha_row, mean_rate_heu_normalized, '-^');
plot(alpha_row, mean_rate_sens_normalized, '-x');
plot(alpha_row, mean_rate_comm_normalized, '-*');
xlabel('alpha (times of cell average rate)')
ylabel('Total normalized objective function')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average normalized objective function on different alpha")

figure()
plot(alpha_row, mean_N_SAR_dp, '--o');
hold on
plot(alpha_row, mean_N_SAR_heu, '--^');
plot(alpha_row, mean_N_SAR_sens, '--x');
plot(alpha_row, mean_N_SAR_comm, '--*');
ylabel('Coverage (cells)')
xlabel('alpha (times of cell average rate)')
title("Average coverage on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(alpha_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(alpha_row, mean_comm_rate_heu_normalized, '-^');
plot(alpha_row, mean_comm_rate_sens_nomalized, '-x');
plot(alpha_row, mean_comm_rate_comm_normalized, '-*');
xlabel('alpha (times of cell average rate)')
ylabel('Normalized communication performance')
title("Average normalized communication capacity on different alpha")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(alpha_row, mean_comm_rate_dp, '-o');
hold on
plot(alpha_row, mean_comm_rate_heu, '-^');
plot(alpha_row, mean_comm_rate_sens, '-x');
plot(alpha_row, mean_comm_rate_comm, '-*');
xlabel('alpha (times of cell average rate)')
ylabel('Normalized communication performance')
title("Average communication capacity on different alpha")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')