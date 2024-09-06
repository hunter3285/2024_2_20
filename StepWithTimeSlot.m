function [step_with_time, last_step_turn, last_turn_right_or_left]=StepWithTimeSlot(steps)

load("cell_matrix.mat", "turn_cost_right", "turn_cost_left", "time_slot_max", 'start');
if ~isequal(steps(:, 1), start)
    step_with_time=zeros(2,time_slot_max);
    last_step_turn=0;
    last_turn_right_or_left=0;
    return;
end
last_turn_right_or_left=0;
last_step_turn=0;
if size(steps,2)<=1
    step_with_time=steps;
    return;
end
x_diff=steps(1, 1)-steps(1, 2);
y_diff=steps(2, 1)-steps(2, 2);
if x_diff==1
    direction=0;
elseif y_diff==1
    direction=1;
elseif x_diff==-1
    direction=2;
elseif y_diff==-1
    direction=3;
else
    disp('step error 1')
end
old_direction=direction;
step_with_time=zeros(2, time_slot_max);
step_with_time(:,1)=start;
time=2;
for ii=2:size(steps, 2)-1
    x_diff=steps(1, ii)-steps(1, ii+1);
    y_diff=steps(2, ii)-steps(2, ii+1);
    % if steps(1, ii+1)==0 || steps(2, ii+1)==0
    %     break;
    % end
    if x_diff==1
        direction=0;
    elseif y_diff==1
        direction=1;
    elseif x_diff==-1
        direction=2;
    elseif y_diff==-1
        direction=3;
    else
        disp('step error 2')
    end
    if direction~=old_direction
        if direction==mod(old_direction-1,4)
            step_with_time(:, time:time+turn_cost_right-1)=ones(2, turn_cost_right).*steps(:, ii);
            time=time+turn_cost_right;
        elseif direction==mod(old_direction+1,4)
            step_with_time(:, time:time+turn_cost_left-1)=ones(2, turn_cost_left).*steps(:, ii);
            time=time+turn_cost_left;
        else
            disp('error in StepWithTimeSlot')
        end
    else
        step_with_time(:, time)=steps(:, ii);
        time=time+1;
    end
    old_direction=direction;


end
if 2>size(steps, 2)-1
    ii=1;
end
step_with_time(:, time)=steps(:, ii+1);

n=0;
for ii=size(step_with_time,2):-1:1
    if isequal(step_with_time(:,ii), [0;0])
        n=n+1;
    else
        break;
    end
end
if n==turn_cost_left-1 || n==turn_cost_right-1
    step_with_time(:, end-n+1:end)=step_with_time(:, end-n)*ones(1,n);
    last_step_turn=1;
    if n==turn_cost_left-1
        last_turn_right_or_left=2;
    else
        last_turn_right_or_left=1; %right
    end
end


end