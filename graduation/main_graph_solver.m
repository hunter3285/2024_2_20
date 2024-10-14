clear all
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
d.visited_matrix















