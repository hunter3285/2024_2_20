close all
% x=[9 10 11 12 13 14 15];
% y=[ 0.7690 0.8218 0.8995  0.8898  0.8888 0.9163 0.9724];
% figure();
% 
% plot(x, y, '-o')
% title('Ratio between heristic and optimal vs. turn cost')
% xlabel("turn cost (time slot)")
% ylabel("ratio (heuristic/optimal)")
%%
figure()
x=[100 120 140 160 180 200];
dp_rate=[3126.95 3752.86 4240.94 4616.28 5185.78 5556];
heuristic_rate=[2959.875 2983.94 3784.32 3986.18 4625.06 4912.74];
comm_rate=[2958.875 3299.16 3677.62 4018.22 4321.46 4565.08];
round_rate=[2821.3 3299.16 3677.62 4018.22 4321.46 4565.08];

plot(x, dp_rate, '-o')
hold on
plot(x, heuristic_rate, '-o')
plot(x, comm_rate, '-o')
plot(x, round_rate, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication only'...
    , 'Go round')
title('Average Reward vs. Time Limit')
ylabel 'Reward (bit/Hz)'
xlabel("time limit (time slot)")
%% 
x=[100 120 140 160 180 200];
figure()
dp_grid=[46 56.4 63.4 68.8 76.4 82.6];
heuristic_grid=[47 47 59.6 63 72.2 77.6];
comm_grid=[39.75 38.2 39.8 42.2 40.4 39.6];
round_grid=[41 41 41 41 41 41];
plot(x, dp_grid, '-o')
hold on
plot(x, heuristic_grid, '-o')
plot(x, comm_grid, '-o')
plot(x, round_grid, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication only'...
    , 'Go round')
title('Number of Visited Cells vs. Time Limit')
ylabel 'Number of Visited Cells'
xlabel("time limit (time slot)")
%%
x=[100 120 140 160 180 200];
figure()
dp_rate=[1692.475 1973.74 2259.74 2451.18 2778.18 2977.26];
heuristic_rate=[1494.225 1501.64 1922.12 2004.52 2349.32 2495.6];
comm_rate=[1718.275 2097.12 2433.52 2690.06 3048.96 3327.72];
round_rate=[1542.825 1870.2 2213.02 2577.06 2921.34 3206.56];
plot(x, dp_rate, '-o')
hold on
plot(x, heuristic_rate, '-o')
plot(x, comm_rate, '-o')
plot(x, round_rate, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication'...
    , 'Go round')
title('Communication Rate vs. Time Limit')
ylabel 'Rate (bit/Hz)'
xlabel("time limit (time slot)")

%%
x=[6 7 8 9 10 11];

figure()
dp_rate=[5222.52 5030.7 4646.38 4451.74 4240.94 4001.44 ];
heuristic_rate=[4772.4 4464.96 3918.78 3620.38 3784.32 3777.9];
comm_rate=[4277.68 4446.62 4060.4 3947.16 3677.62 3613.44];
round_rate=[4194.64 3952.58 3812.02 3627.98 3494.24 3369.2];
plot(x, dp_rate, '-o')
hold on
plot(x, heuristic_rate, '-o')
plot(x, comm_rate, '-o')
plot(x, round_rate, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication only'...
    , 'Go round')
title('Total Reward vs. Number of Time Slot per Turn')
ylabel 'Reward (bit/Hz)'
xlabel("Turn Cost")
%%

x=[6 7 8 9 10 11];
figure()
dp_grid=[77 72.2 68.6 66.4 63.4 59];
heuristic_grid=[74.4 68.8 68.8 61.8 59.6 59.6];
comm_grid=[39 45.4 44.2 44.2 39.8 44.2 ];
round_grid=[40.8 41 41 41 41 40.6];
plot(x, dp_grid, '-o')
hold on
plot(x, heuristic_grid, '-o')
plot(x, comm_grid, '-o')
plot(x, round_grid, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication only'...
    , 'Go round')
title('Number of Visited Cells vs. Number of Time Slot per Turn')
ylabel 'Number of Visited Cells'
xlabel("Turn Cost")






%%
x=[6 7 8 9 10 11];

figure()
dp_rate=[2818.34 2743.72 2480.16 2368.34 2259.74 2146.14];
heuristic_rate=[2448.08 2285.24 2244.12 1979.62 1922.12 1894.5];
comm_rate=[3059.12 3008.84 2663.48 2538.2 2559.58 2222.72];
round_rate=[2920.66 2653.74 2513.84 2354.64 2341.44 2092.32];
plot(x, dp_rate, '-o')
hold on
plot(x, heuristic_rate, '-o')
plot(x, comm_rate, '-o')
plot(x, round_rate, '-o')
legend('Dynamic programming', 'Heuristic', 'Optimization on Communication only'...
    , 'Go round')
title 'Communication sum rate vs. Number of Time Slot per Turn'
ylabel 'Reward (bit/Hz)'
xlabel("Turn Cost")












