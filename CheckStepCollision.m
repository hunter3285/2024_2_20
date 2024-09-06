function [valid, time]=CheckStepCollision(step_with_time)
N_UAV=size(step_with_time,1)/2;
load('cell_matrix.mat', 'N_cell_x', 'N_cell_y');
valid=1;
time=[];
visited_matrix=zeros(N_cell_x, N_cell_y);
for ii=1:size(step_with_time,2)
    for jj=1:N_UAV
        point=step_with_time(jj*2-1:jj*2, ii);
        if isequal(point, [0;0])
            continue;
        end
        if visited_matrix(point(1), point(2))>0
            valid=0;
            time=[time, ii];
        else
            visited_matrix(point(1), point(2))=1;
        end
    end
    visited_matrix=visited_matrix-visited_matrix;
end

end