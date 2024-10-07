%% setting the test
N_iter=2;
N_Solver=4;
alpha_row=[1 10 100 1000];
rate_dp_matrix          =zeros(N_iter, length(alpha_row));
N_SAR_dp_matrix         =zeros(N_iter, length(alpha_row));
comm_rate_dp_matrix     =zeros(N_iter, length(alpha_row));
% rate_heu_matrix         =zeros(N_iter, length(alpha_row));
% N_SAR_heu_matrix        =zeros(N_iter, length(alpha_row));
% comm_rate_heu_matrix    =zeros(N_iter, length(alpha_row));
rate_sens_matrix        =zeros(N_iter, length(alpha_row));
N_SAR_sens_matrix       =zeros(N_iter, length(alpha_row));
comm_rate_sens_matrix   =zeros(N_iter, length(alpha_row));
rate_comm_matrix        =zeros(N_iter, length(alpha_row));
N_SAR_comm_matrix       =zeros(N_iter, length(alpha_row));
comm_rate_comm_matrix   =zeros(N_iter, length(alpha_row));

rate_dp_matrix_normalized=          zeros(N_iter,length(alpha_row));
comm_rate_dp_matrix_normalized=     zeros(N_iter,length(alpha_row));
% rate_heu_matrix_normalized=         zeros(N_iter,length(alpha_row));
% comm_rate_heu_matrix_normalized=    zeros(N_iter,length(alpha_row));
rate_sens_matrix_normalized=        zeros(N_iter,length(alpha_row));
comm_rate_sens_matrix_normalized=   zeros(N_iter,length(alpha_row));
rate_comm_matrix_normalized=        zeros(N_iter,length(alpha_row));
comm_rate_comm_matrix_normalized=   zeros(N_iter,length(alpha_row));


for ii=1:N_iter
    for jj=1:length(alpha_row)
        [rate_dp, N_SAR_dp, comm_rate_dp, rate_heu, N_SAR_heu, comm_rate_heu, ...
            rate_sens, N_SAR_sens, comm_rate_sens, rate_comm, N_SAR_comm, comm_rate_comm]...
            = test_single_UAV_alpha(alpha_row(jj));



        rate_dp_matrix(ii,jj)           =rate_dp;
        N_SAR_dp_matrix(ii,jj)          =N_SAR_dp;
        comm_rate_dp_matrix(ii,jj)      =comm_rate_dp;
        % rate_heu_matrix (ii,jj)         =rate_heu;
        % N_SAR_heu_matrix(ii,jj)         =N_SAR_heu;
        % comm_rate_heu_matrix(ii,jj)     =comm_rate_heu;
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
        % rate_heu_matrix_normalized(ii,jj)=      rate_heu_normalized;
        % comm_rate_heu_matrix_normalized(ii,jj)= comm_rate_heu_normalized;
        rate_sens_matrix_normalized(ii,jj)=     rate_sens_normalized;
        comm_rate_sens_matrix_normalized(ii,jj)=comm_rate_sens_normalized;
        rate_comm_matrix_normalized(ii,jj)=     rate_comm_normalized;
        comm_rate_comm_matrix_normalized(ii,jj)=comm_rate_comm_normalized;



    end
end
mean_rate_dp=mean(rate_dp_matrix);
% mean_rate_heu=mean(rate_heu_matrix);
mean_rate_sens=mean(rate_sens_matrix);
mean_rate_comm=mean(rate_comm_matrix);

mean_rate_dp_normalized=mean(rate_dp_matrix_normalized);
% mean_rate_heu_normalized=mean(rate_heu_matrix_normalized);
mean_rate_sens_normalized=mean(rate_sens_matrix_normalized);
mean_rate_comm_normalized=mean(rate_comm_matrix_normalized);

mean_N_SAR_dp=mean(N_SAR_dp_matrix);
% mean_N_SAR_heu=mean(N_SAR_heu_matrix);
mean_N_SAR_sens=mean(N_SAR_sens_matrix);
mean_N_SAR_comm=mean(N_SAR_comm_matrix);

mean_comm_rate_dp_normalized=mean(comm_rate_dp_matrix_normalized);
mean_comm_rate_heu_normalized=mean(comm_rate_heu_matrix_normalized);
mean_comm_rate_sens_nomalized=mean(comm_rate_sens_matrix_normalized);
mean_comm_rate_comm_normalized=mean(comm_rate_comm_matrix_normalized);
%%

figure()
semilogx(alpha_row, mean_rate_dp, '-o');
hold on
% semilogx(time_slot_max_row, mean_rate_heu, '-^');
semilogx(alpha_row, mean_rate_sens, '-x');
semilogx(alpha_row, mean_rate_comm, '-*');
ylabel bits
xlabel('times of average rate')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average performance on different alpha")


figure()
semilogx(alpha_row, mean_rate_dp_normalized);
hold on
% semilogx(alpha_row, mean_rate_heu_normalized);
semilogx(alpha_row, mean_rate_sens_normalized);
semilogx(alpha_row, mean_rate_comm_normalized);
xlabel('times of average rate')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average normalized performance on different alpha")

figure()
semilogx(alpha_row, mean_N_SAR_dp);
hold on
% semilogx(alpha_row, mean_N_SAR_heu);
semilogx(alpha_row, mean_N_SAR_sens);
semilogx(alpha_row, mean_N_SAR_comm);
ylabel cells
xlabel('times of average rate')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average SAR coverage on different alpha")

figure()
semilogx(alpha_row, mean_comm_rate_dp_normalized);
hold on
% semilogx(alpha_row, mean_comm_rate_heu_normalized);
semilogx(alpha_row, mean_comm_rate_sens_nomalized);
semilogx(alpha_row, mean_comm_rate_comm_normalized);
ylabel bits
xlabel('times of average rate')
grid on
legend('DP(Proposed)', 'Sensing only', 'Communication only')
title("Average communication performance on different alpha")


save('single_different_alpha.mat')

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






