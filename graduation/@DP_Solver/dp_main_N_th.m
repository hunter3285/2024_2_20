function [max_profit, max_index]=dp_main_N_th(obj, N)
    for ii=1:obj.N_cell_x
        for jj=1:obj.N_cell_y
            for time_slot=0:obj.time_slot_max-1
                for direction=0:3
                    obj.dp_matrix(ii,jj,direction+1,time_slot+1)=obj.dp_rec(ii,jj,direction,time_slot);
                end
            end
        end
    end
    [max_profit,max_index]=max(obj.dp_matrix(:,:,:,:), [], "all");
%     dp_array=reshape(obj.dp_matrix(:,:,:,time_slot+1), 1, []);
    for jj=1:N-1
        obj.dp_matrix(max_index)=0;
        [max_profit,max_index]=max(obj.dp_matrix(:,:,:,:), [], "all");
    end
    [max_profit,max_index]=max(obj.dp_matrix(:,:,:,time_slot+1), [], "all");
end