function N=CountCorner(map)
N_cell_x=size(map, 1);
N_cell_y=size(map, 2);
N=0;
% first row check 2 cells
for ii=1:N_cell_y-1
    if map(1,ii)~=map(1, ii+1)
        N=N+1;
    end
end
% last row
for ii=1:N_cell_y-1
    if map(end,ii)~=map(end, ii+1)
        N=N+1;
    end
end
% first column
for ii=1:N_cell_x-1
    if map(ii,1)~=map(ii+1, 1)
        N=N+1;
    end
end
% last column
for ii=1:N_cell_x-1
    if map(ii,end)~=map(ii+1, end)
        N=N+1;
    end
end
% middle

for ii=1:N_cell_x-1
    for jj=1:N_cell_y-1
        A=[map(ii,jj), map(ii, jj+1);...
           map(ii+1, jj), map(ii+1, jj+1)];
        unique_values=unique(A);
        for kk = 1:length(unique_values)
            if sum(A==unique_values(kk),'all')==1
                N=N+1;
            end
        end
    end
end
end




