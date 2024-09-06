clear all;
N_UAV=3;
N_cell_x=10;
N_cell_y=10;
start=[1;1];
map=DistantPoints(N_cell_x, N_cell_y, N_UAV+1, start)
map=(map-1).*((map-1)>0)
%%
map_last=zeros(size(map, 1), size(map, 2));
while ~isequal(map,map_last)
    map_last=map;
    map=WaveFront(map, N_UAV);
end
map_old=map
map_new=SmoothEdge(map);
while ~isequal(map,map_new)
    map=map_new;
    map_new=SmoothEdge(map);
end
map_new
map_old~=map_new