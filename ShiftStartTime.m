function [valid, shifted]=ShiftStartTime(step_with_time)
N_UAV=size(step_with_time,1)/2;
vacancy=zeros(N_UAV, 1);
for ii=1:N_UAV
   for jj=size(step_with_time, 2):-1:1
       if step_with_time(2*ii-1, jj)||step_with_time(2*ii, jj)==0
           vacancy(ii)=vacancy(ii)+1;
       end
   end
end
end