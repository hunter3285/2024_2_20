clear all
% s=Single_UAV_Solver;
% d=s.Solver_row(1);
% [sum_rate_optimal_dp, ~, ~, ~,  ~, ~, ~, n_grid, ~]=d.get_dp_result;
% 
% g=Graph_Solver(s);
% g.start=d.start;
% 
% g.start_direction=d.start_direction;
% g.finish=d.finish;
% g.finish_direction=d.finish_direction;
% g.set_edge_time;
% 
% g.solve_path
% error_graph=g.sum_rate-sum_rate_optimal_dp
% [rate_dp, N_SAR_dp, comm_rate_dp]=d.get_BCD_result();
%% below are for many tests
% Remember to set the parameters in Single_UAV_Solver, 
% e.g., small time_slot_max
N_iter=100;
results=zeros(N_iter,6);
dp_larger=0;
graph_larger=0;

for ii=1:N_iter
    [rate_dp, N_SAR_dp, comm_rate_dp, rate_graph, N_SAR_graph, comm_rate_graph]=test_graph();
    results(ii,:)=[rate_dp, N_SAR_dp, comm_rate_dp, rate_graph, N_SAR_graph, comm_rate_graph];
    if abs(rate_dp-rate_graph)>1e-4
         dp_larger=dp_larger+(rate_dp>rate_graph);
         graph_larger=graph_larger+(rate_graph>rate_dp);
    end
end
















