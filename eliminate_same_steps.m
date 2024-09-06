function all_step=eliminate_same_steps(step_with_time_slot)
all_step=[];
pointer=1;
for ii=2:size(step_with_time_slot,2)
    if ~isequal(step_with_time_slot(:,pointer),step_with_time_slot(:,ii))
        all_step=[all_step, step_with_time_slot(:, pointer)];
        pointer=ii;
    end
end
all_step=[all_step, step_with_time_slot(:, pointer)];
