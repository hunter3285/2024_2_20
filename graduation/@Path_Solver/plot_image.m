function plot_image(obj)
N_azi=obj.N_azi;
N_cell_y=obj.N_cell_y;
N_cell_x=obj.N_cell_x;
map=zeros(N_azi*N_cell_y, N_azi*N_cell_x);
map2=map;
for ii=1:N_cell_x
    for jj=1:N_cell_y
        map( N_azi*(obj.N_cell_y-jj)+1:N_azi*(obj.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=obj.image_cell_matrix(ii,jj).image;
        map2(N_azi*(obj.N_cell_y-jj)+1:N_azi*(obj.N_cell_y+1-jj), N_azi*(ii-1)+1:N_azi*ii )=obj.image_cell_matrix(ii,jj).image_horizontal;
    end
end
imagesc(1:N_azi*obj.N_cell_x, 1:N_azi*obj.N_cell_y, map+map2)
end