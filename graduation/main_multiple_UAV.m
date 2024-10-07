m=Multiple_UAV_Solver();
if exist('cell_matrix', 'var')
    m.set_cells(cell_matrix);
    m.initialize_DP_multi_Solver();
end

% DP_Solver_multi_inst=m.Solver_row(1); % DP_Solver_multi
% DP_Solver_multi_inst.BCD_for_UAV_paths_DP();

m.initialize_DP_comm_multi_Solver();
DP_comm_Solver_multi_inst=m.DP_comm_multi_Solver; % an DP_Solver_multi object
DP_comm_Solver_multi_inst.get_comm_paths();

m.initialize_DP_sens_multi_Solver();
DP_sens_Solver_multi_inst=m.DP_sens_multi_Solver;
DP_sens_Solver_multi_inst.get_sens_paths;