function [max_profit, max_index]=dp_main(obj)
    for ii=1:obj.N_cell_x
        for jj=1:obj.N_cell_y
            for time_slot=0:obj.time_slot_max-1
                for direction=0:3
                    obj.dp_matrix(ii,jj,direction+1,time_slot+1)=obj.dp_rec(ii,jj,direction,time_slot);
                end
            end
        end
    end
    [max_profit,max_index]=max(obj.dp_matrix(:,:,:,time_slot+1), [], "all");
end