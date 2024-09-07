function set_power_vec(obj, p)
obj.power_vec=p;
if length(p)~=obj.time_slot_max
    disp('error in path solver set_power_vec')
    obj.power_vec=[power_vec;zeros(obj.time_slot_max-length(power_vec),1)];
end
end