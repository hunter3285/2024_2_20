function set_cells(obj, UAV_Solver_instance)
%called after set cell in UAV_Solver's
for ii=1:size(obj.Solver_row, 2)
    obj.Solver_row(ii).set_cells(UAV_Solver_instance);
end
end