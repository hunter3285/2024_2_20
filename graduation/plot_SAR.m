s=Single_UAV_Solver;
if exist('cell_matrix', 'var')
    s.set_cells(cell_matrix);
end
s.initialize_DP_Solver();
%% test DP
d=s.Solver_row(1);
[sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_class, ...
    rate_vec_class]=d.get_dp_result;
d.get_image;
% d.plot_image;

N_azi=d.N_azi;
N_cell_y=d.N_cell_y;
N_cell_x=d.N_cell_x;
map=zeros(N_azi*N_cell_y, N_azi*N_cell_x);
map2=map;
for ii=1:N_cell_x
    for jj=1:N_cell_y
        map( N_azi*(d.N_cell_y-jj)+1:N_azi*(d.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=d.image_cell_matrix(ii,jj).image;
        map2(N_azi*(d.N_cell_y-jj)+1:N_azi*(d.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=d.image_cell_matrix(ii,jj).image_horizontal;
    end
end
%%
imagesc(1:N_azi*d.N_cell_x, 1:N_azi*d.N_cell_y, map+map2)
title("DP (proposed)")
%%
s.initialize_DP_comm_Solver;
c=s.dp_solver_communication;
[sum_rate_comm, visited_dp_comm, visited_inidicator_comm, visited_indicator_comm_2,  all_step_dp_comm, ~, ~, n_grid_comm, ...
    rate_vec_comm]=c.get_dp_result;
c.get_image;
% c.plot_image;


map=zeros(N_azi*N_cell_y, N_azi*N_cell_x);
map2=map;
for ii=1:N_cell_x
    for jj=1:N_cell_y
        map( N_azi*(c.N_cell_y-jj)+1:N_azi*(c.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=c.image_cell_matrix(ii,jj).image;
        map2(N_azi*(c.N_cell_y-jj)+1:N_azi*(c.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=c.image_cell_matrix(ii,jj).image_horizontal;
    end
end
%%
figure()
imagesc(1:N_azi*c.N_cell_x, 1:N_azi*c.N_cell_y, map+map2)
title("Communciation optimization only")
