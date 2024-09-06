function map=ChangeGroup(x, y, map_old)
map=map_old;
N_cell_x=size(map_old,1);
N_cell_y=size(map_old,2);
groups=[];
if x+1<=N_cell_x
    groups=[groups, map(x+1, y)];
end
if y-1>0
    groups=[groups, map(x, y-1)];
end
if x-1>0 
    groups=[groups, map(x-1, y)];
end
if y+1<=N_cell_y
    groups=[groups, map(x, y+1)];
end
groups=unique(groups);
Corners=zeros(length(groups),1);
for ii=1:size(groups,2)
    map_temp=map_old;
    map_temp(x,y)= groups(ii);
    Corners(ii)=CountCorner(map_temp);
end
[value, idx]=min(Corners);
Corners_old=CountCorner(map_old);
if Corners_old<=value
    return;
end
map(x,y)=groups(idx);
end