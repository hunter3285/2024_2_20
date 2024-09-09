m=Multiple_UAV_Solver;
if exist('cell_matrix', 'var')
    m.set_cells(cell_matrix);
end
m.initialize_DP_multi_Solver();
d=m.Solver_row(1); % DP_Solver_multi
d.BCD_for_UAV_paths();