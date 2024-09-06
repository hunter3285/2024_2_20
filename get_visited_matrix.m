function [visited_matrix, visited_matrix_2]=get_visited_matrix(dp_inst)
time_slot=dp_inst.time_slot_max-1;
[~,max_index]=max(dp_inst.dp_matrix(:,:,:,time_slot+1), [], "all");
direction=ceil(max_index / 100)-1 % 0 to 3
real_index=(max_index-direction*100);
x=mod(real_index - 1, 10)+1;
y=ceil(real_index/10);
visited_matrix=zeros(dp_inst.N_cell_x, dp_inst.N_cell_y);
visited_matrix_2=visited_matrix;
for ii=1:dp_inst.N_cell_x
    for jj=1:dp_inst.N_cell_y
        visited_matrix(ii,jj)=dp_inst.visited_cells_matrix(x,y,direction+1, time_slot+1, (jj-1)*10+ii);
        visited_matrix_2(ii,jj)=dp_inst.visited_cells_matrix_2(x,y,direction+1, time_slot+1, (jj-1)*10+ii);
    end
end
end