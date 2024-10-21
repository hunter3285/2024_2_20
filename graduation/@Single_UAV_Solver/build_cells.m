function build_cells(obj)
N_cell_x=obj.N_cell_x;
N_cell_y=obj.N_cell_y;
p_mean=obj.p_mean;
noise_variance=obj.noise_variance;
fs=obj.fs;
N_azi=obj.N_azi;
cell_side=obj.cell_side;
rho_r=obj.rho_r;
R0=obj.R0;
lambda=obj.lambda;




cell_matrix(obj.N_cell_x, obj.N_cell_y)=UAV_cell;
coef_vec_cell_matrix(obj.N_cell_x, obj.N_cell_y)=coef_array_cell;
for ii=1:N_cell_x
    for jj=1:N_cell_y
        cell_matrix(ii,jj).middle_point=[cell_side*ii-cell_side/2;cell_side*jj-cell_side/2;0];
        cell_matrix(ii,jj).noise_variance=noise_variance;
    end
end
%% setup for the users and profit
N_users=zeros(N_cell_x, N_cell_y);
for ii=1:N_cell_x
    for jj=1:N_cell_y
        N_users(ii,jj)=round(rand()*10);    % mean is 5 users
        N_users(ii,jj)=round(rand()*10);
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
log_normal=makedist('Lognormal');
log_normal.sigma=2;
GTx=100;
GRx=100;
alpha_0=lambda^2/(4*pi)^2*GTx*GRx;
path_loss=alpha_0/R0^2;


for ii=1:N_cell_x
    for jj=1:N_cell_y
        my_channel=comm.RicianChannel(...
            'SampleRate',fs,'PathDelays',[0 1e-9 7e-9 9e-9]...
            ,'AveragePathGains', [0,-5 -2 -7],'ChannelFiltering',false...
            ,'MaximumDopplerShift',5000000);
        % cell_matrix(ii,jj).channel=my_channel;
        r=log_normal.random;
        % r=1;
        % coef_array=path_loss*r*abs(sum(my_channel(),2));%100*n_delay_taps->100*1
        coef_vec=path_loss*r*ones(100,1);
        snr_array=p_mean*coef_vec./cell_matrix(ii,jj).noise_variance; % assuming power=p_mean

        cell_matrix(ii,jj).snr_array=snr_array(1:cell_matrix(ii,jj).N_user);
        cell_matrix(ii,jj).coef_array=coef_vec(1:cell_matrix(ii,jj).N_user);
        coef_vec_cell_matrix(ii,jj).coef_array=coef_vec(1:cell_matrix(ii,jj).N_user);
        cell_matrix(ii,jj).sum_rate=sum(log2(1+cell_matrix(ii,jj).snr_array));
        
        if cell_matrix(ii,jj).N_user~=0
             cell_matrix(ii,jj).sum_rate= cell_matrix(ii,jj).sum_rate/cell_matrix(ii,jj).N_user;
        end
    end
end
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

for ii=1:N_cell_x
    for jj=1:N_cell_y
        cell_matrix(ii, jj).N_scatterer=N_points;
        % a_group=points+[rho_r;rho_r; 0]+cell_matrix(ii, jj).middle_point-[cell_side/2;cell_side/2;0];
        % b_group=points+cell_matrix(ii, jj).middle_point+[cell_side/2;cell_side/2;0]-[rho_r;rho_r; 0];
        % b_group(:,end)=zeros(3,1);
        % cell_matrix(ii, jj).scatterer_pos=[a_group, b_group];
        % cell_matrix(ii, jj).scatterer_pos=points+cell_matrix(ii,jj).middle_point-[cell_side/2;cell_side/2;0]+[rho_r;rho_r;0];
        cell_matrix(ii, jj).scatterer_pos=points+cell_matrix(ii,jj).middle_point;
        % scatterer_pos is 3*N_points
    end
end
%% checking sum rate
all_rate_matrix=zeros(N_cell_x, N_cell_y);
for ii=1:N_cell_x
    for jj=1:N_cell_y
%         cell_matrix(ii,jj).new_cell_profit=mean(all_rate_matrix,'all');
        all_rate_matrix(ii,jj)=cell_matrix(ii,jj).sum_rate;
    end
end



for ii=1:N_cell_x
    for jj=1:N_cell_y
        cell_matrix(ii,jj).image=zeros(N_azi, N_azi);
    end
end





obj.cell_matrix=cell_matrix;
obj.coef_vec_cell_matrix=coef_vec_cell_matrix;
obj.total_users=total_users;
obj.N_user_matrix=N_users;
obj.all_rate_matrix=all_rate_matrix;
obj.mean_rate=mean(all_rate_matrix, 'all')*20;
disp('mean rate is 20 times larger in build_cells (default)')
obj.N_max_user=max(N_users,[], 'all');

end