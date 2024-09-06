function map=WaveFront(map_old, N)
N_cell_x=size(map_old,1);
N_cell_y=size(map_old,2);
for ii=1:N
    [x_array,y_array]=find(map_old==ii);
    for jj=1:size(x_array)
        x=x_array(jj);
        y=y_array(jj);
        points=FindNeighbor(x,y,N_cell_x, N_cell_y);
        for jj=1:size(points,2)
            x_new=points(1,jj);
            y_new=points(2,jj);
            if map_old(x_new, y_new)==0
                map_old(x_new, y_new)=ii;
            end
        end
    end

end
map=map_old;
end
function points=FindNeighbor(x,y,N_cell_x, N_cell_y)
points=[];
if x-1>0 && y-1>0
    points=[points,[x-1;y-1]];
end
if x-1>0 && y>0
    points=[points,[x-1;y]];
end
if x>0 && y-1>0
    points=[points,[x;y-1]];
end
if x-1>0 && y+1<=N_cell_y
    points=[points,[x-1;y+1]];
end
if x+1<=N_cell_x && y-1>0
    points=[points,[x+1;y-1]];
end
if x+1<=N_cell_x && y+1<=N_cell_y
    points=[points,[x+1;y+1]];
end
if x+1<=N_cell_x && y>0
    points=[points,[x+1;y]];
end
if x>0 && y+1<=N_cell_y
    points=[points,[x;y+1]];
end
end