function map=DistantPoints(N_cell_x, N_cell_y, N, start)
map=zeros(N_cell_x, N_cell_y);

for ii=1:N
    distance_map=ones(N_cell_x, N_cell_y)*-1;
    if ii==1
        map(start(1), start(2))=ii;
        continue;
    end
    distance_map=GetDistanceMap(distance_map, map, ii);
    max_d=max(distance_map, [], 'all');
    [x, y]=find(distance_map==max_d);
    map(x(1), y(1))=ii;

end

end
function distance_map=GetDistanceMap(distance_map_old, map, N)
% There are N-1 points to determine distances
points=zeros(2, N-1);
for ii=1:size(map,1)
    for jj=1:size(map,2)
        if map(ii,jj)~=0
            points(1,map(ii,jj))=ii;
            points(2,map(ii,jj))=jj;
        end
    end
end
for ii=1:size(map,1)
    for jj=1:size(map,2)
        if map(ii,jj)==0
            d=zeros(1,size(points,2));
            for kk=1:size(points,2)
                d(kk)=pdist([ii,jj;points(1,kk), points(2,kk)]);
            end
            distance_map_old(ii,jj)=-std(d)*.5+min(d);
        end
    end
end
distance_map=distance_map_old;
end