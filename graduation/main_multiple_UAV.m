m=Multiple_UAV_Solver();
if exist('cell_matrix', 'var')
    m.set_cells(cell_matrix);
    m.initialize_DP_multi_Solver();
end

DP_Solver_multi_inst=m.Solver_row(1); % DP_Solver_multi
DP_Solver_multi_inst.BCD_for_UAV_paths();