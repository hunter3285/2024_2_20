function rate=GainedSensing(visited, sensing_matrix)
% the sensing matrix should be the correct sensing matrix of all
load('cell_matrix.mat', 'N_cell_x', 'N_cell_y', 'all_rate_matrix');
rate=0;
mean_rate=mean(all_rate_matrix, 'all');
for ii=1:N_cell_x
    for jj=1:N_cell_y
        if visited(ii,jj)>0 && sensing_matrix(ii,jj)==1
            rate=rate+mean_rate;
        end
    end
end
end