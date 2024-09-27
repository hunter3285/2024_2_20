function initialize_Heuristic_Solver(obj)
    obj.N_Solver=obj.N_Solver+1;
    obj.heuristic_solver=Heuristic_Solver(obj);
end