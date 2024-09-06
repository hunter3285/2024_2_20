function N_user_max=get_max_user(cell_matrix)
N_user_max=0;
for ii=1:size(cell_matrix,1)
    for jj=1:size(cell_matrix,2)
        if cell_matrix(ii,jj).N_user>N_user_max
            N_user_max=cell_matrix(ii,jj).N_user;
        end
    end
end