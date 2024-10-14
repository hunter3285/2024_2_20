function [rate_dp, N_SAR_dp, comm_rate_dp, rate_graph, N_SAR_graph, comm_rate_graph]=test_graph()


s=Single_UAV_Solver;
sensing_matrix=zeros(s.N_cell_x, s.N_cell_y);
sensing_matrix_2=sensing_matrix;
for ii=1:s.N_cell_x
    for jj=1:s.N_cell_y
        sensing_matrix(ii,jj)=rand>0.5;
        sensing_matrix_2(ii,jj)=rand>0.5;
    end
end
s.sensing_matrix=sensing_matrix;
s.sensing_matrix_2=sensing_matrix_2;
s.initialize_DP_Solver;
d=s.Solver_row(1);
[sum_rate_optimal_dp, ~, ~, ~,  ~, ~, ~, ~, ~]=d.get_dp_result;

g=Graph_Solver(s);
g.start=d.start;

g.start_direction=d.start_direction;
g.finish=d.finish;
g.finish_direction=d.finish_direction;
g.set_edge_time;

g.solve_path
error_graph=g.sum_rate-sum_rate_optimal_dp
g.power_parameters;
g.power_optimization;
g.sum_rate=g.get_correct_rate+g.n_grid*g.mean_rate;
[rate_dp, N_SAR_dp, comm_rate_dp]=d.get_BCD_result();
rate_graph=g.sum_rate;
N_SAR_graph=g.n_grid;
comm_rate_graph=g.get_correct_rate;
difference_graph=d.sum_rate-g.sum_rate

end