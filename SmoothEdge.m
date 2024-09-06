function map=SmoothEdge(map_old)
r=rand;
N_cell_x=size(map_old,1);
N_cell_y=size(map_old,2);
map_temp=map_old;
if r<0.25
    for ii=1:N_cell_x
        for jj=1:N_cell_y
            map_temp=ChangeGroup(ii,jj,map_temp);
        end
    end
elseif r<0.5
    for ii=1:N_cell_y
        for jj=1:N_cell_x
            map_temp=ChangeGroup(jj,ii,map_temp);
        end
    end
elseif r<0.75
    for ii=1:N_cell_x
        for jj=1:N_cell_y
            map_temp=ChangeGroup(N_cell_x-ii+1,N_cell_y-jj+1,map_temp);
        end
    end
else
    for ii=1:N_cell_y
        for jj=1:N_cell_x
            map_temp=ChangeGroup(N_cell_x-jj+1,N_cell_y-ii+1,map_temp);
        end
    end
end
map=map_temp;
end