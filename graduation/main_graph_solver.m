clear
clc;
s=Single_UAV_Solver;
d=s.Solver_row(1);
[sum_rate_optimal_dp, ~, ~, ~,  ~, ~, ~, n_grid, ~]=d.get_dp_result;

g=Graph_Solver(s);
g.start=d.start;

g.start_direction=d.start_direction;
g.finish=d.finish;
g.finish_direction=d.finish_direction;
g.set_edge_time;

g.solve_path
diff_graph=(g.sum_rate-sum_rate_optimal_dp)*isequal(d.all_step, g.all_step)
[rate_dp, N_SAR_dp, comm_rate_dp]=d.get_BCD_result();
isequal(d.all_step, g.all_step)

d.sum_rate>g.sum_rate

%% below are for many tests
% Remember to set the parameters in Single_UAV_Solver, 
% e.g., small time_slot_max
clear
clc
close all
N_iter=100;
results=zeros(N_iter,6);
dp_larger=0;
graph_larger=0;

for ii=1:N_iter
    [rate_dp, N_SAR_dp, comm_rate_dp, rate_graph, N_SAR_graph, comm_rate_graph, d, g]=test_graph();
    results(ii,:)=[rate_dp, N_SAR_dp, comm_rate_dp, rate_graph, N_SAR_graph, comm_rate_graph];
    if abs(rate_dp-rate_graph)>1e-4
         dp_larger=dp_larger+(rate_dp>rate_graph);
         graph_larger=graph_larger+(rate_graph>rate_dp);
    end
    %if rate_graph-rate_dp>1e-4
    %    disp('not ended')
    %    break;
    %end
end
dp_larger
graph_larger















