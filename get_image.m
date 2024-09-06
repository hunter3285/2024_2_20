function cell_matrix=get_image(UAV_start_end, all_step, cell_matrix)

load('SARparams.mat');
N_steps=size(all_step, 2);
direction=-1;
for ii=1:N_steps
    ii
    old_direction=direction;
    if ii<N_steps % Not the last step
        x1=all_step(1, ii);
        x2=all_step(1,ii+1);
        y1=all_step(2, ii);
        y2=all_step(2, ii+1);
        
        if x1-x2==1
            direction=2;
        elseif x2-x1==1
            direction=0;
        elseif y1-y2==1
            direction=3;
        elseif y2-y1==1
            direction=1;
        else
            disp('error diagonal');
            % disp('er1');
            disp(num2str(x1));
            disp(num2str(y1));
            disp(num2str(x2));
            disp(num2str(y2));
        end
    else
        direction=old_direction;
    end

    current_point=all_step(:, ii);
    current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
    
%     N_azi=round(cell_side/vr/T_PRI);
%     N_azi=N_azi-mod(N_azi, N_range_cell);
%     vr=cell_side/N_azi/T_PRI;
    range_axis_size=round(T_PRI/Ts);
    azimuth_axis_size=N_azi;
    received_signal=zeros(range_axis_size, azimuth_axis_size);
    UAV_start=UAV_start_end(:,ii*2-1);
    UAV_end=UAV_start_end(:,ii*2);
    if abs(UAV_start(1)-UAV_end(1))>abs(UAV_start(2)-UAV_end(2))
        pos_array=linspace(UAV_start(1), UAV_end(1), N_azi);
        UAV_pos_array=[pos_array;ones(1, N_azi)*UAV_end(2);ones(1, N_azi)*H];
    else
        pos_array=linspace(UAV_start(2), UAV_end(2), N_azi);
        UAV_pos_array=[ones(1, N_azi)*UAV_end(1);pos_array;ones(1, N_azi)*H];
    end

    PN=comm.PNSequence('SamplesPerFrame',N);
    S=PN()*2-1;% N by 1
    s=zeros(N,1);
    k=(0:N-1).';
    for jj=0:N-1
        exp_vec=exp(1j*2*pi*k*jj/N);
        s(jj+1)=sum(S.*exp_vec);% ii+1 to map 0:N-1 to array indices 1:N 
    end
    s=s/sqrt(N);
    s_CP=[s(end-(M-2):end);s]; %add CP with length M-1 

    L=size(s_CP,1);%   613=512+102-1
    N_points=cell_matrix(current_point(1), current_point(2)).N_scatterer;
    R=zeros(N_points, N_azi);
    aperture_radius=150/2;%can be changed in the future
    %first scatter for range imaging

    switch direction
        case 0
            first_scatterer=[current_middle(1);current_middle(2)+cell_side/2;0];
        case 1
            first_scatterer=[current_middle(1)-cell_side/2;current_middle(2);0];
        case 2
            first_scatterer=[current_middle(1);current_middle(2)-cell_side/2;0];
        case 3
            first_scatterer=[current_middle(1)+cell_side/2;current_middle(2);0];
    end
    R_row=vecnorm(UAV_pos_array-first_scatterer);
    Rc=min(R_row);
    Rc_delay=2*Rc/c/Ts;
    fraction=Rc_delay-floor(Rc_delay);
    t_start=fraction*Ts;                            %start sampling at this time to align with the first range cell
    front=round((2*Rc/c-t_start)/Ts)+1;
    front_array_first_scatter=ones(N_azi,1)*front;

    points=cell_matrix(current_point(1), current_point(2)).scatterer_pos;
    for jj=1:N_points

        scatter=points(:, jj);
        R_row=vecnorm(UAV_pos_array-scatter);
        R(jj,:)=R_row;
    
        Rc=min(R_row);
        Rc_delay=2*Rc/c/Ts;
        fraction=Rc_delay-floor(Rc_delay);
        t_start=fraction*Ts;                            % start sampling at this time to align with the first range cell
        front=round((2*Rc/c-t_start)/Ts);
%         front_array=ones(N_azi,1)*front;                % all aligned at front (closest distance of UAV)
        if direction==1||direction==3
            aperture_filter=(UAV_pos_array(2,:)<scatter(2)+aperture_radius)&(UAV_pos_array(2,:)>scatter(2)-aperture_radius);
        else
            aperture_filter=(UAV_pos_array(1,:)<scatter(1)+aperture_radius)&(UAV_pos_array(1,:)>scatter(1)-aperture_radius);
        end
        % if sum(aperture_filter)==0
        %     disp('errororo')
        % end
        phase=4*pi*fc*R_row/c;
        sample=exp(-1j*phase).*aperture_filter;
        signal=s_CP*sample;     %(N+M-1)*N_azi
        received_signal(front+1:front+L, :)=received_signal(front+1:front+L, :)+signal; % Do RCMC directly(all delay are the same)
        % signal_all for old section
        % signal_all(:,:,ii)=s_CP*sample;%(N+M-1)*N_azi
    
    end
    
    front=front_array_first_scatter(1);
    range_data=received_signal(front+1+M-1:front+L, :);%removing first M-1 samples  
    range_data_FT=fft(range_data);
    S_back=(fft(s_CP(M:end))); %excluding cp
    D_hat=range_data_FT./S_back;
    d_hat=(ifft(D_hat));
    d_hat_zero=[d_hat;zeros(2*M-2, N_azi)];
    
    d_hat_zero_azi_FT=fft(d_hat_zero.');%transpose for azimuth direction fft
    d_hat_zero_azi_FT=fftshift(d_hat_zero_azi_FT,1);
    
    Rc_array=R0+(1:N+2*M-2)*rho_r;
    d_hat_zero_azi_FT=fftshift(d_hat_zero_azi_FT,1);
    d_hat_zero=ifft(d_hat_zero_azi_FT).';
    
    received_signal(front+1:front+N+2*M-2,:)=d_hat_zero;
    index=((1:N_azi)-round(N_azi/2))-1;
    fl_old=(index/N_azi/T_PRI).';
    R0_array=R0+(1:M)*rho_r;
    Ka=2*fc*vr^2/c./R0_array;
    one_over_Ka=1./Ka;
    H_az=exp(-1j*pi*(fl_old).^2*one_over_Ka);
    received_signal_FT=fft(received_signal.'); % column for fft (fft on row)
    received_signal_FT=fftshift(received_signal_FT, 1);
    received_signal_FT(:,front+1:front+M)=received_signal_FT(:,front+1:front+M).*H_az;% H_az was a row, multiply column => each column do .*
    received_signal_FT=fftshift(received_signal_FT,1);
    received_signal=ifft(received_signal_FT).';

    % figure();
    x_lim=[1, N_azi];
    y_lim=[front+1, front+N_range_cell];%in number of samples
    azi_lim=x_lim*vr*T_PRI;
    % range_lim=y_lim*Ts*c/2/sin(slant_angle);
    % range_lim=y_lim*rho_r;
    range_lim=[R0, R0+N_range_cell*rho_r];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%需要驗算
    
    % C=abs(received_signal(:,:));
    C=abs(received_signal(y_lim(1):y_lim(2),x_lim(1):x_lim(2)));
    x=linspace(azi_lim(1),azi_lim(2),x_lim(2)-x_lim(1)+1);
    % y=linspace(range_lim(1),range_lim(2),y_lim(2)-y_lim(1)+1);
    
%     if ii==5
        % imagesc(x,y,C)
%     end

    C_new=zeros(N_azi, N_azi);
    batch_size=floor(N_azi/N_range_cell);
    for kk=1:N_range_cell
%         C_cols=C(:, batch_size*(kk-1)+1:batch_size*kk);
%         C_new(:, kk)=...
%             ones(size(C,1),1).*mean(C_cols,2);
        C_new((kk-1)*batch_size+1:kk*batch_size, :)=ones(batch_size,1)*C(kk,:);
        if kk==N_range_cell
            C_new( kk*batch_size+1:end,:)=ones(N_azi-kk*batch_size,1)*C(kk,:);
        end
    end
    y=linspace(range_lim(1),range_lim(2),N_azi);
    % figure();
    % imagesc(x,y,C_new)
    if direction==3
        C_new=rot90(C_new);
        cell_matrix(current_point(1), current_point(2)).image=C_new;
        cell_matrix(current_point(1), current_point(2)).image_x=x;
        cell_matrix(current_point(1), current_point(2)).image_y=y;
    elseif direction==0
        C_new=rot90(C_new,2);
        cell_matrix(current_point(1), current_point(2)).image_horizontal=C_new;
        cell_matrix(current_point(1), current_point(2)).image_x_horizontal=x;
        cell_matrix(current_point(1), current_point(2)).image_y_horizontal=y;
    elseif direction==2
        % C_new=rot90(C_new,2);
        cell_matrix(current_point(1), current_point(2)).image_horizontal=C_new;
        cell_matrix(current_point(1), current_point(2)).image_x_horizontal=x;
        cell_matrix(current_point(1), current_point(2)).image_y_horizontal=y;
    elseif direction==1
        C_new=rot90(C_new,3);
        cell_matrix(current_point(1), current_point(2)).image=C_new;
        cell_matrix(current_point(1), current_point(2)).image_x=x;
        cell_matrix(current_point(1), current_point(2)).image_y=y;
    end
end














end