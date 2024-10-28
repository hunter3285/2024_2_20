clear all
close all
load('single_time10.mat')

mean_comm_rate_dp=mean(comm_rate_dp_matrix);
mean_comm_rate_sens=mean(comm_rate_sens_matrix);
mean_comm_rate_comm=mean(comm_rate_comm_matrix);
mean_comm_rate_heu=mean(comm_rate_heu_matrix);




figure()
plot(time_slot_max_row, mean_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu, '-^');
plot(time_slot_max_row, mean_rate_sens, 'r-x');
plot(time_slot_max_row, mean_rate_comm, '-*');
ylabel('Value of objective function (bits)')
xlabel('Time limit (Time slots)')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average value of objective function on different time slot")

figure()
plot(time_slot_max_row, mean_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_rate_sens_normalized, 'r-x');
plot(time_slot_max_row, mean_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Total normalized performance')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average normalized total performance on different time limit")

figure()
plot(time_slot_max_row, mean_N_SAR_dp, '-o');
hold on
plot(time_slot_max_row, mean_N_SAR_heu, '-^');
plot(time_slot_max_row, mean_N_SAR_sens, 'r-x');
plot(time_slot_max_row, mean_N_SAR_comm, '-*');
ylabel('Coverage (cells)')
xlabel('Time limit (Time slots)')
title("Average coverage on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_comm_rate_sens_nomalized, 'r-x');
plot(time_slot_max_row, mean_comm_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Normalized communication performance')
title("Average normalized communication capacity on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_comm_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_heu, '-^');
plot(time_slot_max_row, mean_comm_rate_sens, 'r-x');
plot(time_slot_max_row, mean_comm_rate_comm, '-*');
xlabel('Time limit (Time slots)')
ylabel('Communication performance (bits)')
title("Average communication capacity on different time limit")
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')