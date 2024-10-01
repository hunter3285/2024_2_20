function plot_image(cell_matrix, N_azi)
map=zeros(N_azi*size(cell_matrix, 2), N_azi*size(cell_matrix, 1));
map2=map;
for ii=1:size(cell_matrix, 1)
    for jj=1:size(cell_matrix, 2)
        ii
        jj
        map( N_azi*(10-jj)+1:N_azi*(11-jj), N_azi*(ii-1)+1:N_azi*ii )=cell_matrix(ii,jj).image;
        map2(N_azi*(10-jj)+1:N_azi*(11-jj), N_azi*(ii-1)+1:N_azi*ii )=cell_matrix(ii,jj).image_horizontal;
    end
end
imagesc(1:N_azi*10, 1:N_azi*10, map+map2)
% figure()
% imagesc(1:N_azi*10, 1:N_azi*10, map2)
