function [new_current_point, new_sum_rate, new_visited, new_all_step,  new_step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate, visited,...
    all_step, sensing_matrix , step_idx)

%給定next_point，生成新的sum_rate, visited, N_time_slot


mean_rate=mean(all_rate_matrix, "all");
new_current_point=next_point;
new_sum_rate=sum_rate+all_rate_matrix(next_point(1), next_point(2));

if visited(next_point(1), next_point(2))==0 && sensing_matrix(next_point(1), next_point(2))==1
    new_sum_rate=new_sum_rate+mean_rate;
end
new_visited=visited;
new_visited(next_point(1), next_point(2))=step_idx;
new_step_idx=step_idx+1;


new_all_step=[all_step,next_point];

end