%% setting the test
N_iter=50;
N_Solver=4;
time_slot_max_row=[40 80 120 160 200];
rate_dp_matrix          =zeros(N_iter, length(time_slot_max_row));
N_SAR_dp_matrix         =zeros(N_iter, length(time_slot_max_row));
comm_rate_dp_matrix     =zeros(N_iter, length(time_slot_max_row));
rate_heu_matrix         =zeros(N_iter, length(time_slot_max_row));
N_SAR_heu_matrix        =zeros(N_iter, length(time_slot_max_row));
comm_rate_heu_matrix    =zeros(N_iter, length(time_slot_max_row));
rate_sens_matrix        =zeros(N_iter, length(time_slot_max_row));
N_SAR_sens_matrix       =zeros(N_iter, length(time_slot_max_row));
comm_rate_sens_matrix   =zeros(N_iter, length(time_slot_max_row));
rate_comm_matrix        =zeros(N_iter, length(time_slot_max_row));
N_SAR_comm_matrix       =zeros(N_iter, length(time_slot_max_row));
comm_rate_comm_matrix   =zeros(N_iter, length(time_slot_max_row));

rate_dp_matrix_normalized=          zeros(N_iter,length(time_slot_max_row));
comm_rate_dp_matrix_normalized=     zeros(N_iter,length(time_slot_max_row));
rate_heu_matrix_normalized=         zeros(N_iter,length(time_slot_max_row));
comm_rate_heu_matrix_normalized=    zeros(N_iter,length(time_slot_max_row));
rate_sens_matrix_normalized=        zeros(N_iter,length(time_slot_max_row));
comm_rate_sens_matrix_normalized=   zeros(N_iter,length(time_slot_max_row));
rate_comm_matrix_normalized=        zeros(N_iter,length(time_slot_max_row));
comm_rate_comm_matrix_normalized=   zeros(N_iter,length(time_slot_max_row));
tic;

for ii=1:N_iter
    for jj=1:length(time_slot_max_row)
        [rate_dp, N_SAR_dp, comm_rate_dp, rate_heu, N_SAR_heu, comm_rate_heu, ...
            rate_sens, N_SAR_sens, comm_rate_sens, rate_comm, N_SAR_comm, comm_rate_comm]...
            = test_single_UAV_time(time_slot_max_row(jj));



        rate_dp_matrix(ii,jj)           =rate_dp;
        N_SAR_dp_matrix(ii,jj)          =N_SAR_dp;
        comm_rate_dp_matrix(ii,jj)      =comm_rate_dp;
        rate_heu_matrix (ii,jj)         =rate_heu;
        N_SAR_heu_matrix(ii,jj)         =N_SAR_heu;
        comm_rate_heu_matrix(ii,jj)     =comm_rate_heu;
        rate_sens_matrix(ii,jj)         =rate_sens;
        N_SAR_sens_matrix(ii,jj)        =N_SAR_sens;
        comm_rate_sens_matrix(ii,jj)    =comm_rate_sens;
        rate_comm_matrix(ii,jj)         =rate_comm;
        N_SAR_comm_matrix(ii,jj)        =N_SAR_comm;
        comm_rate_comm_matrix(ii,jj)    =comm_rate_comm;
        % if normalized according to max_rate
        max_rate=max([rate_dp, rate_heu, rate_sens, rate_comm]);

        rate_dp_normalized=rate_dp/max_rate;
        rate_heu_normalized=rate_heu/max_rate;
        rate_sens_normalized=rate_sens/max_rate;
        rate_comm_normalized=rate_comm/max_rate;
        


        max_comm_rate=max([comm_rate_dp, comm_rate_heu, comm_rate_sens, comm_rate_comm]);

        comm_rate_dp_normalized=comm_rate_dp/max_comm_rate;
        comm_rate_heu_normalized=comm_rate_heu/max_comm_rate;
        comm_rate_sens_normalized=comm_rate_sens/max_comm_rate;
        comm_rate_comm_normalized=comm_rate_comm/max_comm_rate;

        rate_dp_matrix_normalized(ii,jj)=       rate_dp_normalized;
        comm_rate_dp_matrix_normalized(ii,jj)=  comm_rate_dp_normalized;
        rate_heu_matrix_normalized(ii,jj)=      rate_heu_normalized;
        comm_rate_heu_matrix_normalized(ii,jj)= comm_rate_heu_normalized;
        rate_sens_matrix_normalized(ii,jj)=     rate_sens_normalized;
        comm_rate_sens_matrix_normalized(ii,jj)=comm_rate_sens_normalized;
        rate_comm_matrix_normalized(ii,jj)=     rate_comm_normalized;
        comm_rate_comm_matrix_normalized(ii,jj)=comm_rate_comm_normalized;



    end
end
mean_rate_dp=mean(rate_dp_matrix);
mean_rate_heu=mean(rate_heu_matrix);
mean_rate_sens=mean(rate_sens_matrix);
mean_rate_comm=mean(rate_comm_matrix);

mean_rate_dp_normalized=mean(rate_dp_matrix_normalized);
mean_rate_heu_normalized=mean(rate_heu_matrix_normalized);
mean_rate_sens_normalized=mean(rate_sens_matrix_normalized);
mean_rate_comm_normalized=mean(rate_comm_matrix_normalized);


mean_N_SAR_dp=mean(N_SAR_dp_matrix);
mean_N_SAR_heu=mean(N_SAR_heu_matrix);
mean_N_SAR_sens=mean(N_SAR_sens_matrix);
mean_N_SAR_comm=mean(N_SAR_comm_matrix);

mean_comm_rate_dp_normalized=mean(comm_rate_dp_matrix_normalized);
mean_comm_rate_heu_normalized=mean(comm_rate_heu_matrix_normalized);
mean_comm_rate_sens_nomalized=mean(comm_rate_sens_matrix_normalized);
mean_comm_rate_comm_normalized=mean(comm_rate_comm_matrix_normalized);
%%
figure()
plot(time_slot_max_row, mean_rate_dp, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu, '-^');
plot(time_slot_max_row, mean_rate_sens, '-x');
plot(time_slot_max_row, mean_rate_comm, '-*');
ylabel bits
xlabel('time slot')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average performance on different time limit")

figure()
plot(time_slot_max_row, mean_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_rate_sens_normalized, '-x');
plot(time_slot_max_row, mean_rate_comm_normalized, '-*');
xlabel('time slot')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average normalized performance on different time limit")

figure()
plot(time_slot_max_row, mean_N_SAR_dp, '--o');
hold on
plot(time_slot_max_row, mean_N_SAR_heu, '--^');
plot(time_slot_max_row, mean_N_SAR_sens, '--x');
plot(time_slot_max_row, mean_N_SAR_comm, '--*');
ylabel cells
xlabel('time slot')
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average SAR coverage on different time limit")

figure()
plot(time_slot_max_row, mean_comm_rate_dp_normalized, '-o');
hold on
plot(time_slot_max_row, mean_comm_rate_heu_normalized, '-^');
plot(time_slot_max_row, mean_comm_rate_sens_nomalized, '-x');
plot(time_slot_max_row, mean_comm_rate_comm_normalized, '-*');
xlabel('time slot')
grid on
grid on
legend('DP(Proposed)', 'Heurstic', 'Sensing only', 'Communication only')
title("Average communiation performance on different time limit")
toc;
%%

save('single_different_time50.mat')

% assume cell_matrix is done

% s=Single_UAV_Solver;
% if exist('cell_matrix', 'var')
%     s.set_cells(cell_matrix);
% end
% s.initialize_DP_Solver();

%% 
% a=A_star_Solver(s);
% a.create_node_list;
% a.get_first_step;
% 
% n=a.node_list(1);
% a.check_neighbor_nodes(n.x, n.y, n.direction)
% a.extract_min_unvisited_node
% a.get_A_star_result;






