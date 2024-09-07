 function set_sensing_matrices(obj, sensing_matrix_in, sensign_matrix_2_in)
     obj.sensing_matrix=sensing_matrix_in;
     obj.sensing_matrix_2=sensign_matrix_2_in;
     if ~isequal(size(sensing_matrix_in), [obj.N_cell_x, obj.N_cell_y])|| ~isequal(size(sensign_matrix_2_in), [obj.N_cell_x, obj.N_cell_y])
         disp('error in set sensing matrices in path solver')
     end
 end