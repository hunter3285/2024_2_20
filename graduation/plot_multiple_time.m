clear all
close all
load('multiple_time10.mat')

mean_comm_rate_dp=mean(comm_rate_dp_matrix);
mean_comm_rate_sens=mean(comm_rate_sens_matrix);
mean_comm_rate_comm=mean(comm_rate_comm_matrix);





figure()
plot(time_slot_max_row, mean_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_rate_sens, 'r-x');
plot(time_slot_max_row, mean_rate_comm, '-*', 'Color',[0.5, 0, 0.5]);
ylabel('Value of objective function (bits)')
xlabel('Time limit (Time slots)')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average value of objective function on different time limit")

figure()
plot(time_slot_max_row, mean_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_rate_sens_normalized, 'r-x');
plot(time_slot_max_row, mean_rate_comm_normalized, '-*', 'Color',[0.5, 0, 0.5]);
xlabel('Time limit (Time slots)')
ylabel('Value of normalized objective function (bits)')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average normalized objective function on different time limit")

figure()
plot(time_slot_max_row, mean_N_SAR_dp, '-o');
hold on
plot(time_slot_max_row, mean_N_SAR_sens, 'r-x');
plot(time_slot_max_row, mean_N_SAR_comm, '-*', 'Color',[0.5, 0, 0.5]);
ylabel('Coverage (cells)')
xlabel('Time limit (Time slots)')
title("Average coverage on different time limit")
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_sens_nomalized, 'r-x');
plot(time_slot_max_row, mean_comm_rate_comm_normalized, '-*', 'Color',[0.5, 0, 0.5]);
xlabel('Time limit (Time slots)')
ylabel('Normalized communication capacity')
title("Average normalized communication capacity on different time limit")
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_comm_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_sens, 'r-x');
plot(time_slot_max_row, mean_comm_rate_comm, '-*', 'Color',[0.5, 0, 0.5]);
xlabel('Time limit (Time slots)')
ylabel('Communication capacity (bits)')
title("Average communication capacity on different time limit")
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')