m=Multiple_UAV_Solver;
if exist('cell_matrix', 'var')
    m.set_cells(cell_matrix);
end
m.initialize_DP_multi_Solver();
DP_Solver_multi_inst=m.Solver_row(1); % DP_Solver_multi
DP_Solver_multi_inst.BCD_for_UAV_paths();