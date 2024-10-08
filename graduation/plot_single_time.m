load('single_different_time.mat')
figure()
plot(time_slot_max_row, mean_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu, '-^');
plot(time_slot_max_row, mean_rate_sens, '-x');
plot(time_slot_max_row, mean_rate_comm, '-*');
ylabel('Total performance (bits)')
xlabel('Time limit (Time slots)')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')


figure()
plot(time_slot_max_row, mean_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_rate_sens_normalized, '-x');
plot(time_slot_max_row, mean_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Total normalized performance')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_N_SAR_dp, '--o');
hold on
plot(time_slot_max_row, mean_N_SAR_heu, '--^');
plot(time_slot_max_row, mean_N_SAR_sens, '--x');
plot(time_slot_max_row, mean_N_SAR_comm, '--*');
ylabel('Coverage (cells)')
xlabel('Time limit (Time slots)')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')

figure()
plot(time_slot_max_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_comm_rate_sens_nomalized, '-x');
plot(time_slot_max_row, mean_comm_rate_comm_normalized, '-*');
xlabel('Time limit (Time slots)')
ylabel('Normalized communication performance')
grid on
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')