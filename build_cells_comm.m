function [cell_matrix, N_users, total_users, all_rate_matrix]=...
    build_cells_comm(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell, communication_matrix )
% for communicion dense area
load('SARparams.mat', 'fs')
%% Building the cell matrix

cell_matrix(N_cell_y, N_cell_x)=UAV_cell;
for ii=1:N_cell_y
    for jj=1:N_cell_x
        cell_matrix(ii,jj).middle_point=[cell_side*ii-cell_side/2;cell_side*jj-cell_side/2;0];
    end
end
%% setup for the users and profit
N_users=zeros(N_cell_y, N_cell_x);
mode=mod(randi(12),2); % 0 to 2
for ii=1:N_cell_y
    for jj=1:N_cell_x
        N_users(ii,jj)=round(rand()*10);    % mean is 5 users
        if ii+jj==10
            N_users(ii,jj)=5;
        end
        switch mode
            case 0
                if jj>5
                    N_users(ii,jj)=10-N_users(ii, 10-jj+1);
                end
            case 1
                if ii>5
                    N_users(ii,jj)=10-N_users(10-ii+1, jj);
                end
%             case 2
%                 N_users(ii,jj)=5;
        end
        N_users(ii,jj)=N_users(ii,jj)*communication_matrix(ii,jj);
        for kk=1:N_users(ii,jj)
            dx=(randn()-0.5)*cell_side;
            dy=(randn()-0.5)*cell_side;
            location=cell_matrix(ii,jj).middle_point+[dx;dy;0];
            cell_matrix(ii,jj).user_locations=[cell_matrix(ii,jj).user_locations,location];
            cell_matrix(ii,jj).user_distances=[cell_matrix(ii,jj).user_distances,norm([dx;dy;0])];
            cell_matrix(ii,jj).N_user=cell_matrix(ii,jj).N_user+1;
            cell_matrix(ii,jj).sum_rate=cell_matrix(ii,jj).N_user;%temporarly
        end
    end
end
total_users=sum(N_users, 'all');
%% setup for the channel in each cell
for ii=1:N_cell_y
    for jj=1:N_cell_x
        my_channel=comm.RicianChannel(...
            'SampleRate',fs,'PathDelays',[0 1e-9 7e-9 9e-9]...
            ,'AveragePathGains', [0,-3 -5 -7],'ChannelFiltering',false...
            ,'MaximumDopplerShift',5000000);
        cell_matrix(ii,jj).channel=my_channel;
        coef_array=abs(sum(my_channel(),2));%100*4->100*1
        snr_array=coef_array./cell_matrix(ii,jj).noise_variance;
        cell_matrix(ii,jj).snr=snr_array(1:cell_matrix(ii,jj).N_user);
        cell_matrix(ii,jj).sum_rate=sum(log2(1+cell_matrix(ii,jj).snr))*communication_matrix(ii,jj);
    end
end
%% Setup for communication densed area

%%
% N_points=N_range_cell*2;
% points=zeros(3, N_points);
% rho_r=rho_r*0.99;
% for ii=1:N_points
% %     points(:, ii)=[(30+mod(ii-1,5))*rho_r;(ceil(ii/5)-1)*rho_r;0];
%     if ii<=N_points/2
%         points(:, ii)=[(ii-1)*rho_r;0;0];
%     else
%         points(:,ii)=[(ii-floor(N_points/2)-1)*rho_r;rho_r*2;0];
%     end
% end
N_points=9;
points=zeros(3, N_points);
points(:, 1)=[0;0;0];
points(:, 2)=[rho_r;0;0];
points(:, 3)=[-rho_r ;0;0];
points(:, 4)=[0;rho_r;0];
points(:, 5)=[rho_r;rho_r;0];
points(:, 6)=[-rho_r ;rho_r;0];
points(:, 7)=[0;-rho_r;0];
points(:, 8)=[rho_r;-rho_r;0];
points(:, 9)=[-rho_r ;-rho_r;0];
points=points*0.99;
for ii=1:N_cell_y
    for jj=1:N_cell_x
        cell_matrix(ii, jj).N_scatterer=N_points;
        cell_matrix(ii, jj).scatterer_pos=points+cell_matrix(ii, jj).middle_point;
    end
end
%% checking sum rate
all_rate_matrix=zeros(N_cell_y, N_cell_x);
for ii=1:N_cell_y
    for jj=1:N_cell_x
%         cell_matrix(ii,jj).new_cell_profit=mean(all_rate_matrix,'all');
        all_rate_matrix(ii,jj)=cell_matrix(ii,jj).sum_rate;
    end
end
%%
% N_azi=round(cell_side/vr/T_PRI);
for ii=1:N_cell_y
    for jj=1:N_cell_x
        cell_matrix(ii,jj).image=zeros(N_range_cell, N_range_cell);
    end
end





end