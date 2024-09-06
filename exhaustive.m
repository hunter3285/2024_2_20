function [sum_rate_optimal_exhaustive, visited_optimal, all_step_optimal]=exhaustive()
clear;format shortG;
%% setup for the SAR parameters
load('SARparams.mat')

%% main program

load('cell_matrix.mat', "time_slot_max", "N_cell_x", "N_cell_y", "all_rate_matrix", "turn_cost", "start", "cell_matrix");
add_mean=1;
mean_rate=mean(all_rate_matrix,'all');
%% find all path combinations

solutions=zeros(floor(time_slot_max/turn_cost)+1,2);

% finding solutions
for ii=0:floor(time_slot_max/turn_cost) 
    for jj=0:time_slot_max
        x=floor(time_slot_max/turn_cost)-ii;
        y=time_slot_max-jj;
        if x*turn_cost+y<=time_slot_max && y<=(10*x+12)
            solutions(ii+1,:)=[x,y];
            break;
        end
    end
end
% deleting redundant solutions
old_solutions=solutions;
counter=1;
solutions(2:end,:)=0;
for ii=1:size(solutions,1)-1
    if old_solutions(counter,1)>=old_solutions(ii+1,1) && old_solutions(counter,2)>=old_solutions(ii+1,2)
        continue;
    end
    solutions(counter+1,:)=old_solutions(ii+1,:);
    counter=counter+1;
end
zero_rows = all(solutions == 0, 2);

% Remove rows with all zeros
solutions = solutions(~zero_rows, :);

%% get all sequences of steps

% Counting the size of sequences
% "-1" in "x+y-1" is for first step is always straight (y-1)
sum_of_N_sequences=0;
max_sum=0;
for ii=1:size(solutions,1)
    x=solutions(ii,1);
    y=solutions(ii,2);
    if y~=0
        sum_of_N_sequences=sum_of_N_sequences+nchoosek(x+y-1,y-1)*2^x;
    else
        sum_of_N_sequences=sum_of_N_sequences+1;
    end
    if x+y-1>max_sum
        max_sum=x+y-1;
    end
end


%%
max_profit=0;
% max_direction=-1;
% max_path=[];
visited_optimal=zeros(N_cell_x, N_cell_x);
starting_profit=cell_matrix(start(1),start(2)).sum_rate;
tic;
for ii=1:size(solutions,1)
    x=solutions(ii,1); % number of turns
    y=solutions(ii,2); % number of straights
    % "-1" in "x+y-1" is for first step is always straight (y-1)
    % turnpos_array=nchoosek(1:(x+y-1), x);
    if y==0
        continue;
    end
    for jj=1:nchoosek(x+y-1, x)
%         turnpos=idx2turnpos(jj,x+y-1,x);
%         turnpos=turnpos_array(jj,:);
        if jj==1
            turnpos=1:x;
        else
            turnpos=get_nxt_nchoosek_array(turnpos, x+y-1);
        end
        for kk=1:2^x
            path=ones(1,x+y);
            l=length(dec2bin(kk-1));
            bin_array=[2*ones(1,x-l), dec2bin(kk-1)-46]; % 2s and 3s for left and right turn
%             l=length(bin_array);
%             bin_array=[2*ones(1,x-l), bin_array];
            for ll=1:x
                path(turnpos(ll)+1)=bin_array(ll);
            end


            step=0; %right=0, upper=1, left=2, lower=3
            [current_path_profit, visited, ~, all_step]=test_a_path(path, start, step, starting_profit,N_cell_y, N_cell_x, all_rate_matrix);
            current_path_profit=current_path_profit+(N_cell_y*N_cell_x - sum(visited==0,'all'))*mean_rate*add_mean;
            step=1;
            [current_path_profit_1, visited_1, ~, all_step_1]=test_a_path(path, start, step, starting_profit,N_cell_y, N_cell_x, all_rate_matrix);
            current_path_profit_1=current_path_profit_1+(N_cell_y*N_cell_x - sum(visited_1==0,'all'))*mean_rate*add_mean;
        
            step=2;
            [current_path_profit_2, visited_2, ~, all_step_2]=test_a_path(path, start, step, starting_profit,N_cell_y, N_cell_x, all_rate_matrix);
            current_path_profit_2=current_path_profit_2+(N_cell_y*N_cell_x - sum(visited_2==0,'all'))*mean_rate*add_mean;
            step=3;
            [current_path_profit_3, visited_3, ~, all_step_3]=test_a_path(path, start, step, starting_profit,N_cell_y, N_cell_x, all_rate_matrix);
            current_path_profit_3=current_path_profit_3+(N_cell_y*N_cell_x - sum(visited_3==0,'all'))*mean_rate*add_mean;
            profits=[current_path_profit;current_path_profit_1;current_path_profit_2;current_path_profit_3];
            [max_profit_current, idx]=max(profits);
            if max_profit_current>max_profit
                max_profit=max_profit_current;
                % max_path=path;
                % max_direction=idx-1;
                if idx==1
                    visited_optimal=visited;
                    all_step_optimal=all_step;
                elseif idx==2
                    visited_optimal=visited_1;
                    all_step_optimal=all_step_1;
                elseif idx==3
                    visited_optimal=visited_2;
                    all_step_optimal=all_step_2;
                else
                    visited_optimal=visited_3;
                    all_step_optimal=all_step_3;
                end
            end
            
        end
    end

end
sum_rate_optimal_exhaustive=max_profit;

end







