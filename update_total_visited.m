function [total_visited, total_visited_2]=update_total_visited(total_visited_old, total_visited_old_2, visited_dp_channel_temp, visited_dp_channel_temp_2)

%%
total_visited_old
total_visited_old_2
total_visited=(total_visited_old+visited_dp_channel_temp)>0
total_visited_2=(total_visited_old_2+visited_dp_channel_temp_2)>0


end


