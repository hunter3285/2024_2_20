function rate=get_rate(obj, x,y, time)
    if time<0
        rate=0;
        return;
    end
    p=obj.power_vec(time+1);
    channel_vec=obj.coef_vec_cell_matrix(x,y,:);
    if isempty(channel_vec)
        rate=0;
        return
    end
    channel_vec=reshape(channel_vec,length(channel_vec),1);
    signal_vec=p*channel_vec;
    rate=sum(log2(1+signal_vec/obj.noise_variance));
    if obj.N_user_matrix(x,y)~=0
        rate=rate/obj.N_user_matrix(x,y);
    end
    % [x,y,rate]
end