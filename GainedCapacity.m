function rate=GainedCapacity(all_step)
load('cell_matrix.mat', 'all_rate_matrix');
rate=0;
for ii=1:size(all_step,2)
    step=all_step(:,ii);
    rate=rate+all_rate_matrix(step(1), step(2));
end
end