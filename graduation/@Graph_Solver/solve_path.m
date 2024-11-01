function solve_path(obj)
p=obj.profit_col;
n=obj.N_cell_x*obj.N_cell_y*4;

t=obj.edge_time;
T_max=obj.time_slot_max-1;
%-1 是因為會花一個time slot在飛start這個node

start_node=obj.node_number_matrix(obj.start(1), obj.start(2), obj.start_direction+1);
finish_node=obj.node_number_matrix(obj.finish(1), obj.finish(2), obj.finish_direction+1);
cvx_begin quiet
    variable x(n, n) binary 
    variable y(n, 1) binary
%     variable z(n, 3) binary  % z 是輔助的二進制變數，用來限制 y 的值
    % 目標函數
    z= sum(t.*x).';
    g=geo_mean([p, z, y],2);
    % this means power(p.*z.*y, 1/3)
    maximize(sum(g))
    % 每個 z(i,:) 中僅有一個元素為 1
%     for ii = 1:n
%         sum(z(ii, :)) == 1;  % 只能選擇一個值
%     end
%     y == z(:, 1) * 1 + z(:, 2) * obj.turn_cost_left + z(:, 3) * obj.turn_cost_right;
%     sum(y)<=T_max;
    % 條件 10.2 和 10.3：進出流平衡約束
    for ii = 1:n
        if ii==start_node
            sum(x(ii, :)) == 1;
            sum(x(:, ii)) == 0;
            y(ii)>=1;
            continue
        end
        if ii==finish_node
            sum(x(ii, :)) == 0;
            sum(x(:, ii)) == 1;
            y(ii)>=1;
            continue
        end
        sum(x(ii, :)) == y(ii); % 每個節點的出流
        sum(x(:, ii)) == y(ii); % 每個節點的入流
    end
%     for ii=1:n
%         for jj=1:n
%             if obj.adjacency_matrix(ii,jj)==0
%                 x(ii,jj)==0;
%             end
%         end
%     end
    

    
    % 條件 10.5：最大時間限制
    sum(sum(t .* x)) <= T_max;
    
    
    % 條件 10.7 和 10.8：布林變數約束自動由 CVX 處理
cvx_end
% counter=1;
node_number=start_node;
N_steps=round(sum(y));
all_step=zeros(2,N_steps);

for iter=1:N_steps
    for ii=1:n
        if iter==N_steps
            index=find(obj.node_number_matrix==node_number);
            [a,b,~]=ind2sub(size(obj.node_number_matrix), index);
            all_step(:, iter)=[a;b];
            obj.visited_matrix(a,b)=iter;
            break;
        end
        if abs(x(node_number, ii)-1)<1e-2
            index=find(obj.node_number_matrix==node_number);
            [a,b,~]=ind2sub(size(obj.node_number_matrix), index);
            all_step(:, iter)=[a;b];
            obj.visited_matrix(a,b)=iter;
            node_number=ii;
            break;
        end
    end
end
% for ii=1:length(y)
%     if abs(y(ii)-1)<1e-2
%         index=find(obj.node_number_matrix==ii);
%         [a,b,~]=ind2sub(size(obj.node_number_matrix), index);
%         obj.visited_matrix(a,b)=1;
%         rate=rate+obj.get_rate(a,b,1);
%     end
% end
all_step_new=[];
counter=1;
for ii=1:size(all_step,2)
    if ~isequal(all_step(:, ii), [0;0])
        all_step_new(:, counter)=all_step(:, ii);
        counter=counter+1;
    end
end
obj.solved_col=y;
obj.all_step=all_step_new;
obj.all_step_with_time=obj.StepWithTimeSlot;
obj.solved_adjacency_matrix=x;
obj.sum_rate=obj.get_correct_rate+obj.count_n_grid*obj.mean_rate;
clear;
end
